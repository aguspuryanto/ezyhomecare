-- =============================================================================
-- EzyHomecare — Supabase schema (backend bersama CustomerApp & TherapistApp)
-- =============================================================================
-- Cara pakai: Supabase Dashboard → SQL Editor → paste seluruh file → Run.
-- Script ini idempotent sebatas `if not exists` / `create or replace`; untuk
-- reset total, drop schema public dulu.
--
-- Alur auth mitra (terapis):
--   1. Register  : supabase.auth.signUp({ email, password, options: { data: {
--                    role: 'THERAPIST', full_name, phone } } })
--                  → trigger handle_new_user() membuat baris `profiles`
--                    (role THERAPIST) + `therapists` (verification_status = pending).
--   2. Upload dokumen (KTP, STR/SIP, sertifikat) ke bucket `therapist-documents`
--      di path `<user_id>/<nama-file>`, lalu insert ke `therapist_documents`.
--   3. Admin memverifikasi → therapists.verification_status = 'approved'.
--   4. Login     : supabase.auth.signInWithPassword(...) lalu panggil
--                  rpc('get_my_role'). Aplikasi Mitra menolak (signOut) jika
--                  hasilnya bukan 'THERAPIST'. Cek juga
--                  rpc('get_my_therapist_status') untuk menampilkan layar
--                  "menunggu verifikasi" bila belum approved.
--
-- Role ADMIN tidak bisa didapat dari signup; set manual lewat SQL Editor:
--   update public.profiles set role = 'ADMIN' where id = '<uuid>';
-- =============================================================================

create extension if not exists pgcrypto;

-- -----------------------------------------------------------------------------
-- Enums
-- -----------------------------------------------------------------------------
do $$ begin
  create type public.user_role as enum ('CUSTOMER', 'THERAPIST', 'ADMIN');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.verification_status as enum ('pending', 'approved', 'rejected', 'suspended');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.document_type as enum ('KTP', 'STR', 'SIP', 'CERTIFICATE', 'SELFIE', 'OTHER');
exception when duplicate_object then null; end $$;

-- Alur status mengikuti prd-therapist.md §3
do $$ begin
  create type public.booking_status as enum (
    'WAITING_THERAPIST', -- "baru"
    'CONFIRMED',         -- "terkonfirmasi"
    'ON_THE_WAY',        -- "menuju_lokasi"
    'ARRIVED',           -- "tiba_lokasi"
    'IN_PROGRESS',       -- "berlangsung"
    'COMPLETED',         -- "selesai"
    'REJECTED',          -- "ditolak"
    'CANCELLED'          -- "dibatalkan"
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.transaction_kind as enum ('income', 'tip', 'withdrawal', 'compensation', 'adjustment');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.withdrawal_status as enum ('requested', 'processing', 'paid', 'rejected');
exception when duplicate_object then null; end $$;

-- -----------------------------------------------------------------------------
-- Helper: updated_at
-- -----------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

-- -----------------------------------------------------------------------------
-- profiles — 1:1 dengan auth.users, menyimpan role (RBAC)
-- -----------------------------------------------------------------------------
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  role        public.user_role not null default 'CUSTOMER',
  full_name   text not null default '',
  phone       text,
  avatar_url  text,
  fcm_token   text,             -- push notification (Capacitor)
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists profiles_role_idx on public.profiles(role);

drop trigger if exists profiles_updated_at on public.profiles;
create trigger profiles_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

-- Helper role (security definer agar tidak rekursif terhadap RLS profiles)
create or replace function public.get_my_role()
returns public.user_role
language sql stable security definer set search_path = public as $$
  select role from public.profiles where id = auth.uid()
$$;

create or replace function public.is_admin()
returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'ADMIN')
$$;

-- -----------------------------------------------------------------------------
-- therapists — data mitra (1:1 dengan profiles ber-role THERAPIST)
-- -----------------------------------------------------------------------------
create table if not exists public.therapists (
  id                   uuid primary key references public.profiles(id) on delete cascade,
  license_no           text,                         -- mis. SIP.446/2024/DPMPTSP.SBY
  gender               text check (gender in ('L', 'P')),
  birth_date           date,
  bio                  text,
  area                 text,                         -- mis. "Surabaya Timur"
  base_lat             double precision,
  base_lng             double precision,
  radius_km            numeric(5,2) not null default 5,
  specialties          text[] not null default '{}',
  is_available         boolean not null default false, -- toggle tersedia/tidak
  verification_status  public.verification_status not null default 'pending',
  verified_at          timestamptz,
  verified_by          uuid references public.profiles(id),
  rejection_reason     text,
  bank_name            text,
  bank_account_no      text,
  bank_account_name    text,
  -- statistik (diperbarui trigger)
  completed_sessions   integer not null default 0,
  rating_avg           numeric(3,2) not null default 0,
  review_count         integer not null default 0,
  sop_violations       integer not null default 0,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

create index if not exists therapists_status_idx on public.therapists(verification_status, is_available);

drop trigger if exists therapists_updated_at on public.therapists;
create trigger therapists_updated_at before update on public.therapists
  for each row execute function public.set_updated_at();

-- Mitra tidak boleh mengubah kolom milik admin/sistem lewat API
create or replace function public.protect_therapist_columns()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if public.is_admin() or auth.uid() is null
     or current_setting('app.trusted_write', true) = 'on' then
    return new;  -- admin / service role / fungsi internal
  end if;
  new.verification_status := old.verification_status;
  new.verified_at         := old.verified_at;
  new.verified_by         := old.verified_by;
  new.rejection_reason    := old.rejection_reason;
  new.completed_sessions  := old.completed_sessions;
  new.rating_avg          := old.rating_avg;
  new.review_count        := old.review_count;
  new.sop_violations      := old.sop_violations;
  -- belum terverifikasi → tidak boleh online
  if new.verification_status <> 'approved' then
    new.is_available := false;
  end if;
  return new;
end $$;

drop trigger if exists therapists_protect on public.therapists;
create trigger therapists_protect before update on public.therapists
  for each row execute function public.protect_therapist_columns();

-- Mitra & customer tidak boleh mengganti role sendiri
create or replace function public.protect_profile_role()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.role is distinct from old.role and not public.is_admin() and auth.uid() is not null then
    new.role := old.role;
  end if;
  return new;
end $$;

drop trigger if exists profiles_protect_role on public.profiles;
create trigger profiles_protect_role before update on public.profiles
  for each row execute function public.protect_profile_role();

create or replace function public.get_my_therapist_status()
returns public.verification_status
language sql stable security definer set search_path = public as $$
  select verification_status from public.therapists where id = auth.uid()
$$;

-- -----------------------------------------------------------------------------
-- Trigger signup: auth.users → profiles (+ therapists)
-- -----------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  v_role public.user_role;
begin
  -- Hanya CUSTOMER / THERAPIST yang boleh dipilih saat signup
  v_role := case upper(coalesce(new.raw_user_meta_data->>'role', 'CUSTOMER'))
              when 'THERAPIST' then 'THERAPIST'::public.user_role
              else 'CUSTOMER'::public.user_role
            end;

  insert into public.profiles (id, role, full_name, phone)
  values (
    new.id,
    v_role,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    coalesce(new.raw_user_meta_data->>'phone', new.phone)
  );

  if v_role = 'THERAPIST' then
    insert into public.therapists (id, license_no, area)
    values (
      new.id,
      new.raw_user_meta_data->>'license_no',
      new.raw_user_meta_data->>'area'
    );
  end if;

  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- -----------------------------------------------------------------------------
-- therapist_documents — berkas verifikasi pendaftaran mitra
-- -----------------------------------------------------------------------------
create table if not exists public.therapist_documents (
  id            uuid primary key default gen_random_uuid(),
  therapist_id  uuid not null references public.therapists(id) on delete cascade,
  doc_type      public.document_type not null,
  storage_path  text not null,          -- path di bucket therapist-documents
  status        public.verification_status not null default 'pending',
  note          text,
  created_at    timestamptz not null default now()
);

create index if not exists therapist_documents_therapist_idx on public.therapist_documents(therapist_id);

-- -----------------------------------------------------------------------------
-- services — katalog layanan (dikelola admin)
-- -----------------------------------------------------------------------------
create table if not exists public.services (
  id                 uuid primary key default gen_random_uuid(),
  slug               text unique not null,        -- mis. bekam-sunnah
  name               text not null,
  description        text,
  category           text,
  duration_minutes   integer not null check (duration_minutes > 0),
  price              integer not null check (price >= 0),   -- rupiah
  partner_share_pct  numeric(4,3) not null default 0.8 check (partner_share_pct between 0 and 1),
  image_url          text,
  is_active          boolean not null default true,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

drop trigger if exists services_updated_at on public.services;
create trigger services_updated_at before update on public.services
  for each row execute function public.set_updated_at();

-- Layanan yang bisa dikerjakan mitra (halaman layanan/index.vue)
create table if not exists public.therapist_services (
  therapist_id  uuid not null references public.therapists(id) on delete cascade,
  service_id    uuid not null references public.services(id) on delete cascade,
  is_active     boolean not null default true,
  created_at    timestamptz not null default now(),
  primary key (therapist_id, service_id)
);

-- -----------------------------------------------------------------------------
-- Jadwal kerja (profil/jadwal.vue) — prd §26
-- -----------------------------------------------------------------------------
create table if not exists public.schedules (
  therapist_id  uuid not null references public.therapists(id) on delete cascade,
  day_of_week   smallint not null check (day_of_week between 0 and 6), -- 0=Minggu … 6=Sabtu
  is_active     boolean not null default true,
  start_time    time not null default '08:00',
  end_time      time not null default '20:00',
  break_start   time,
  break_end     time,
  primary key (therapist_id, day_of_week),
  check (end_time > start_time)
);

create table if not exists public.therapist_time_off (
  id            uuid primary key default gen_random_uuid(),
  therapist_id  uuid not null references public.therapists(id) on delete cascade,
  starts_at     timestamptz not null,
  ends_at       timestamptz not null,
  reason        text,
  created_at    timestamptz not null default now(),
  check (ends_at > starts_at)
);

create index if not exists therapist_time_off_idx on public.therapist_time_off(therapist_id, starts_at);

-- Jadwal default saat mitra baru dibuat (Senin–Jumat 08–20, Sabtu 09–17, Minggu libur)
create or replace function public.seed_therapist_schedule()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.schedules (therapist_id, day_of_week, is_active, start_time, end_time)
  values
    (new.id, 1, true,  '08:00', '20:00'),
    (new.id, 2, true,  '08:00', '20:00'),
    (new.id, 3, true,  '08:00', '20:00'),
    (new.id, 4, true,  '08:00', '20:00'),
    (new.id, 5, true,  '08:00', '20:00'),
    (new.id, 6, true,  '09:00', '17:00'),
    (new.id, 0, false, '09:00', '17:00')
  on conflict do nothing;
  return new;
end $$;

drop trigger if exists therapists_seed_schedule on public.therapists;
create trigger therapists_seed_schedule after insert on public.therapists
  for each row execute function public.seed_therapist_schedule();

-- -----------------------------------------------------------------------------
-- customer_addresses (dipakai CustomerApp, direferensikan booking)
-- -----------------------------------------------------------------------------
create table if not exists public.customer_addresses (
  id            uuid primary key default gen_random_uuid(),
  customer_id   uuid not null references public.profiles(id) on delete cascade,
  label         text not null default 'Rumah',
  address_line  text not null,
  notes         text,
  lat           double precision,
  lng           double precision,
  is_default    boolean not null default false,
  created_at    timestamptz not null default now()
);

create index if not exists customer_addresses_customer_idx on public.customer_addresses(customer_id);

-- -----------------------------------------------------------------------------
-- bookings
-- -----------------------------------------------------------------------------
create sequence if not exists public.booking_code_seq start 10000;

create table if not exists public.bookings (
  id                    uuid primary key default gen_random_uuid(),
  code                  text unique not null default ('BK-' || nextval('public.booking_code_seq')),
  customer_id           uuid not null references public.profiles(id),
  therapist_id          uuid references public.therapists(id),
  service_id            uuid not null references public.services(id),
  address_id            uuid references public.customer_addresses(id) on delete set null,
  -- snapshot saat booking dibuat (agar riwayat tidak berubah bila master berubah)
  service_name          text not null,
  duration_minutes      integer not null,
  price                 integer not null,
  partner_share_pct     numeric(4,3) not null,
  address_text          text not null,
  lat                   double precision,
  lng                   double precision,
  customer_note         text,
  scheduled_at          timestamptz not null,
  status                public.booking_status not null default 'WAITING_THERAPIST',
  service_notes         text,          -- catatan terapis setelah sesi
  cancel_reason         text,
  cancel_compensation   integer not null default 0,
  confirmed_at          timestamptz,
  started_at            timestamptz,
  completed_at          timestamptz,
  cancelled_at          timestamptz,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create index if not exists bookings_therapist_idx on public.bookings(therapist_id, status, scheduled_at);
create index if not exists bookings_customer_idx on public.bookings(customer_id, created_at desc);

drop trigger if exists bookings_updated_at on public.bookings;
create trigger bookings_updated_at before update on public.bookings
  for each row execute function public.set_updated_at();

-- Riwayat status (untuk halaman lacak customer & audit)
create table if not exists public.booking_status_logs (
  id          bigint generated always as identity primary key,
  booking_id  uuid not null references public.bookings(id) on delete cascade,
  status      public.booking_status not null,
  changed_by  uuid references public.profiles(id),
  lat         double precision,
  lng         double precision,
  created_at  timestamptz not null default now()
);

create index if not exists booking_status_logs_booking_idx on public.booking_status_logs(booking_id, created_at);

-- Penolakan terapis (agar booking dialihkan ke terapis lain dan tidak ditawarkan lagi)
create table if not exists public.booking_rejections (
  booking_id    uuid not null references public.bookings(id) on delete cascade,
  therapist_id  uuid not null references public.therapists(id) on delete cascade,
  reason        text,
  created_at    timestamptz not null default now(),
  primary key (booking_id, therapist_id)
);

-- -----------------------------------------------------------------------------
-- reviews
-- -----------------------------------------------------------------------------
create table if not exists public.reviews (
  id            uuid primary key default gen_random_uuid(),
  booking_id    uuid unique not null references public.bookings(id) on delete cascade,
  customer_id   uuid not null references public.profiles(id),
  therapist_id  uuid not null references public.therapists(id),
  rating        smallint not null check (rating between 1 and 5),
  comment       text,
  created_at    timestamptz not null default now()
);

create index if not exists reviews_therapist_idx on public.reviews(therapist_id);

create or replace function public.refresh_therapist_rating()
returns trigger language plpgsql security definer set search_path = public as $$
declare v_id uuid := coalesce(new.therapist_id, old.therapist_id);
begin
  perform set_config('app.trusted_write', 'on', true);
  update public.therapists t
     set rating_avg   = coalesce((select round(avg(rating)::numeric, 2) from public.reviews where therapist_id = v_id), 0),
         review_count = (select count(*) from public.reviews where therapist_id = v_id)
   where t.id = v_id;
  return null;
end $$;

drop trigger if exists reviews_refresh_rating on public.reviews;
create trigger reviews_refresh_rating after insert or update or delete on public.reviews
  for each row execute function public.refresh_therapist_rating();

-- -----------------------------------------------------------------------------
-- Pendapatan mitra (pendapatan/index.vue)
-- -----------------------------------------------------------------------------
create table if not exists public.transactions (
  id            uuid primary key default gen_random_uuid(),
  therapist_id  uuid not null references public.therapists(id) on delete cascade,
  booking_id    uuid references public.bookings(id) on delete set null,
  kind          public.transaction_kind not null,
  amount        integer not null,     -- positif = masuk, negatif = keluar
  label         text not null,
  created_at    timestamptz not null default now()
);

create index if not exists transactions_idx on public.transactions(therapist_id, created_at desc);

create table if not exists public.withdrawals (
  id                 uuid primary key default gen_random_uuid(),
  therapist_id       uuid not null references public.therapists(id) on delete cascade,
  amount             integer not null check (amount > 0),
  bank_name          text not null,
  bank_account_no    text not null,
  bank_account_name  text not null,
  status             public.withdrawal_status not null default 'requested',
  processed_at       timestamptz,
  created_at         timestamptz not null default now()
);

create or replace view public.therapist_balances
with (security_invoker = true) as
  select therapist_id, coalesce(sum(amount), 0)::bigint as balance
    from public.transactions
   group by therapist_id;

-- -----------------------------------------------------------------------------
-- Transisi status booking oleh terapis (dipanggil via rpc)
-- -----------------------------------------------------------------------------
create or replace function public.therapist_update_booking(
  p_booking_id  uuid,
  p_action      text,            -- accept | reject | next | complete
  p_notes       text default null,
  p_lat         double precision default null,
  p_lng         double precision default null
)
returns public.bookings
language plpgsql security definer set search_path = public as $$
declare
  b         public.bookings;
  v_uid     uuid := auth.uid();
  v_next    public.booking_status;
begin
  if not exists (
    select 1 from public.therapists
     where id = v_uid and verification_status = 'approved'
  ) then
    raise exception 'Akun mitra belum terverifikasi' using errcode = '42501';
  end if;

  select * into b from public.bookings where id = p_booking_id for update;
  if not found then
    raise exception 'Booking tidak ditemukan' using errcode = 'P0002';
  end if;
  if b.therapist_id is distinct from v_uid then
    raise exception 'Booking bukan milik Anda' using errcode = '42501';
  end if;

  if p_action = 'accept' then
    if b.status <> 'WAITING_THERAPIST' then raise exception 'Status tidak valid'; end if;
    v_next := 'CONFIRMED';
    update public.bookings set status = v_next, confirmed_at = now() where id = b.id;

  elsif p_action = 'reject' then
    if b.status <> 'WAITING_THERAPIST' then raise exception 'Status tidak valid'; end if;
    insert into public.booking_rejections (booking_id, therapist_id, reason)
    values (b.id, v_uid, p_notes) on conflict do nothing;
    -- lepas terapis; admin/dispatcher akan menugaskan terapis lain
    update public.bookings set therapist_id = null where id = b.id;
    v_next := 'REJECTED';

  elsif p_action = 'next' then
    v_next := case b.status
                when 'CONFIRMED'  then 'ON_THE_WAY'
                when 'ON_THE_WAY' then 'ARRIVED'
                when 'ARRIVED'    then 'IN_PROGRESS'
              end;
    if v_next is null then raise exception 'Status tidak valid'; end if;
    update public.bookings
       set status = v_next,
           started_at = case when v_next = 'IN_PROGRESS' then now() else started_at end
     where id = b.id;

  elsif p_action = 'complete' then
    if b.status <> 'IN_PROGRESS' then raise exception 'Status tidak valid'; end if;
    v_next := 'COMPLETED';
    update public.bookings
       set status = v_next, completed_at = now(), service_notes = coalesce(p_notes, service_notes)
     where id = b.id;

    insert into public.transactions (therapist_id, booking_id, kind, amount, label)
    values (v_uid, b.id, 'income', round(b.price * b.partner_share_pct)::integer,
            'Bagi Hasil • Order #' || b.code);

    perform set_config('app.trusted_write', 'on', true);
    update public.therapists set completed_sessions = completed_sessions + 1 where id = v_uid;

  else
    raise exception 'Aksi tidak dikenal: %', p_action;
  end if;

  insert into public.booking_status_logs (booking_id, status, changed_by, lat, lng)
  values (b.id, v_next, v_uid, p_lat, p_lng);

  select * into b from public.bookings where id = p_booking_id;
  return b;
end $$;

-- =============================================================================
-- Row Level Security
-- =============================================================================
alter table public.profiles              enable row level security;
alter table public.therapists            enable row level security;
alter table public.therapist_documents   enable row level security;
alter table public.services              enable row level security;
alter table public.therapist_services    enable row level security;
alter table public.schedules   enable row level security;
alter table public.therapist_time_off    enable row level security;
alter table public.customer_addresses    enable row level security;
alter table public.bookings              enable row level security;
alter table public.booking_status_logs   enable row level security;
alter table public.booking_rejections    enable row level security;
alter table public.reviews               enable row level security;
alter table public.transactions enable row level security;
alter table public.withdrawals           enable row level security;

-- profiles
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles for select to authenticated
  using (
    id = auth.uid() or public.is_admin()
    -- terapis & customer saling lihat nama/HP bila terhubung lewat booking
    or exists (select 1 from public.bookings b
                where (b.customer_id = profiles.id and b.therapist_id = auth.uid())
                   or (b.therapist_id = profiles.id and b.customer_id = auth.uid()))
  );

drop policy if exists profiles_update on public.profiles;
create policy profiles_update on public.profiles for update to authenticated
  using (id = auth.uid() or public.is_admin())
  with check (id = auth.uid() or public.is_admin());

-- therapists: publik (customer) hanya lihat mitra approved
drop policy if exists therapists_select on public.therapists;
create policy therapists_select on public.therapists for select to authenticated
  using (id = auth.uid() or verification_status = 'approved' or public.is_admin());

drop policy if exists therapists_update on public.therapists;
create policy therapists_update on public.therapists for update to authenticated
  using (id = auth.uid() or public.is_admin())
  with check (id = auth.uid() or public.is_admin());

-- therapist_documents
drop policy if exists therapist_documents_rw on public.therapist_documents;
create policy therapist_documents_rw on public.therapist_documents for all to authenticated
  using (therapist_id = auth.uid() or public.is_admin())
  with check (therapist_id = auth.uid() or public.is_admin());

-- services: semua boleh baca, hanya admin yang tulis
drop policy if exists services_select on public.services;
create policy services_select on public.services for select to anon, authenticated
  using (is_active or public.is_admin());

drop policy if exists services_admin on public.services;
create policy services_admin on public.services for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- therapist_services / schedules / time_off: mitra kelola miliknya
drop policy if exists therapist_services_select on public.therapist_services;
create policy therapist_services_select on public.therapist_services for select to authenticated using (true);

drop policy if exists therapist_services_write on public.therapist_services;
create policy therapist_services_write on public.therapist_services for all to authenticated
  using (therapist_id = auth.uid() or public.is_admin())
  with check (therapist_id = auth.uid() or public.is_admin());

drop policy if exists schedules_select on public.schedules;
create policy schedules_select on public.schedules for select to authenticated using (true);

drop policy if exists schedules_write on public.schedules;
create policy schedules_write on public.schedules for all to authenticated
  using (therapist_id = auth.uid() or public.is_admin())
  with check (therapist_id = auth.uid() or public.is_admin());

drop policy if exists therapist_time_off_rw on public.therapist_time_off;
create policy therapist_time_off_rw on public.therapist_time_off for all to authenticated
  using (therapist_id = auth.uid() or public.is_admin())
  with check (therapist_id = auth.uid() or public.is_admin());

-- customer_addresses
drop policy if exists customer_addresses_rw on public.customer_addresses;
create policy customer_addresses_rw on public.customer_addresses for all to authenticated
  using (customer_id = auth.uid() or public.is_admin())
  with check (customer_id = auth.uid() or public.is_admin());

-- bookings: customer buat & lihat miliknya; terapis lihat yang ditugaskan.
-- Terapis mengubah status HANYA via rpc therapist_update_booking (tidak ada policy update untuk terapis).
drop policy if exists bookings_select on public.bookings;
create policy bookings_select on public.bookings for select to authenticated
  using (customer_id = auth.uid() or therapist_id = auth.uid() or public.is_admin());

drop policy if exists bookings_insert on public.bookings;
create policy bookings_insert on public.bookings for insert to authenticated
  with check (customer_id = auth.uid() and status = 'WAITING_THERAPIST');

drop policy if exists bookings_admin_update on public.bookings;
create policy bookings_admin_update on public.bookings for update to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- booking_status_logs
drop policy if exists booking_status_logs_select on public.booking_status_logs;
create policy booking_status_logs_select on public.booking_status_logs for select to authenticated
  using (exists (select 1 from public.bookings b where b.id = booking_id
                  and (b.customer_id = auth.uid() or b.therapist_id = auth.uid()))
         or public.is_admin());

-- booking_rejections
drop policy if exists booking_rejections_select on public.booking_rejections;
create policy booking_rejections_select on public.booking_rejections for select to authenticated
  using (therapist_id = auth.uid() or public.is_admin());

-- reviews: publik baca; customer tulis untuk booking COMPLETED miliknya
drop policy if exists reviews_select on public.reviews;
create policy reviews_select on public.reviews for select to authenticated using (true);

drop policy if exists reviews_insert on public.reviews;
create policy reviews_insert on public.reviews for insert to authenticated
  with check (
    customer_id = auth.uid()
    and exists (select 1 from public.bookings b
                 where b.id = booking_id and b.customer_id = auth.uid()
                   and b.therapist_id = reviews.therapist_id and b.status = 'COMPLETED')
  );

-- transactions: read-only untuk mitra; ditulis oleh fungsi/admin
drop policy if exists transactions_select on public.transactions;
create policy transactions_select on public.transactions for select to authenticated
  using (therapist_id = auth.uid() or public.is_admin());

drop policy if exists transactions_admin on public.transactions;
create policy transactions_admin on public.transactions for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- withdrawals
drop policy if exists withdrawals_select on public.withdrawals;
create policy withdrawals_select on public.withdrawals for select to authenticated
  using (therapist_id = auth.uid() or public.is_admin());

drop policy if exists withdrawals_insert on public.withdrawals;
create policy withdrawals_insert on public.withdrawals for insert to authenticated
  with check (therapist_id = auth.uid() and status = 'requested');

drop policy if exists withdrawals_admin on public.withdrawals;
create policy withdrawals_admin on public.withdrawals for update to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- Grants untuk RPC
grant execute on function public.get_my_role()               to authenticated;
grant execute on function public.get_my_therapist_status()   to authenticated;
grant execute on function public.therapist_update_booking(uuid, text, text, double precision, double precision) to authenticated;

-- =============================================================================
-- Storage: bucket privat untuk dokumen pendaftaran mitra
-- Path wajib: <auth.uid()>/<file>, mis. "8f1c.../ktp.jpg"
-- =============================================================================
insert into storage.buckets (id, name, public)
values ('therapist-documents', 'therapist-documents', false)
on conflict (id) do nothing;

drop policy if exists "therapist docs owner read" on storage.objects;
create policy "therapist docs owner read" on storage.objects for select to authenticated
  using (bucket_id = 'therapist-documents'
         and ((storage.foldername(name))[1] = auth.uid()::text or public.is_admin()));

drop policy if exists "therapist docs owner insert" on storage.objects;
create policy "therapist docs owner insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'therapist-documents'
              and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "therapist docs owner delete" on storage.objects;
create policy "therapist docs owner delete" on storage.objects for delete to authenticated
  using (bucket_id = 'therapist-documents'
         and (storage.foldername(name))[1] = auth.uid()::text);

-- =============================================================================
-- Realtime: status booking live untuk customer (lacak) & order masuk untuk mitra
-- =============================================================================
do $$ begin
  alter publication supabase_realtime add table public.bookings;
exception when duplicate_object or undefined_object then null; end $$;

do $$ begin
  alter publication supabase_realtime add table public.booking_status_logs;
exception when duplicate_object or undefined_object then null; end $$;

-- =============================================================================
-- Seed layanan (dari app/data/dummy.ts)
-- =============================================================================
insert into public.services (slug, name, duration_minutes, price, partner_share_pct) values
  ('bekam-sunnah',       'Bekam Sunnah Medis',        60, 175000, 0.8),
  ('bekam-premium',      'Bekam Premium & Akupresur', 60, 250000, 0.8),
  ('refleksi-relaksasi', 'Pijat Refleksi Relaksasi',  90, 150000, 0.8)
on conflict (slug) do nothing;
