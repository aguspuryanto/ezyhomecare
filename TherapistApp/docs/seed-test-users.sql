-- =============================================================================
-- EzyHomecare — Akun dummy untuk TESTING (jangan dijalankan di production)
-- =============================================================================
-- Jalankan setelah schema.sql: Supabase Dashboard → SQL Editor → Run.
-- Aman dijalankan berulang: akun yang emailnya sudah ada akan dilewati,
-- tapi datanya tetap di-reset ke nilai di bawah.
--
-- Semua akun memakai kata sandi: Test1234!
--
-- | Email                           | Role      | Status    | Hasil login di app Mitra       |
-- |---------------------------------|-----------|-----------|--------------------------------|
-- | mitra.approved@ezyhomecare.test | THERAPIST | approved  | Masuk ke /order                |
-- | mitra.pending@ezyhomecare.test  | THERAPIST | pending   | Diarahkan ke /verifikasi       |
-- | mitra.rejected@ezyhomecare.test | THERAPIST | rejected  | /verifikasi + alasan penolakan |
-- | customer@ezyhomecare.test       | CUSTOMER  | -         | Ditolak: "bukan akun mitra"    |
--
-- Hapus semua akun uji (lihat bagian paling bawah file).
-- =============================================================================

set search_path = public, extensions;

-- Buat user langsung di auth.users (sudah terkonfirmasi, tanpa kirim email).
-- Trigger handle_new_user() otomatis membuat profiles (+ therapists).
create or replace function pg_temp.create_test_user(p_email text, p_password text, p_meta jsonb)
returns uuid language plpgsql as $$
declare
  v_id uuid;
begin
  select id into v_id from auth.users where email = p_email;
  if v_id is not null then
    return v_id;
  end if;

  v_id := gen_random_uuid();

  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
    -- kolom token harus string kosong, bukan NULL, agar GoTrue bisa login
    confirmation_token, recovery_token, email_change, email_change_token_new
  ) values (
    '00000000-0000-0000-0000-000000000000', v_id, 'authenticated', 'authenticated',
    p_email, crypt(p_password, gen_salt('bf')), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, p_meta, now(), now(),
    '', '', '', ''
  );

  insert into auth.identities (
    id, user_id, provider_id, provider, identity_data, last_sign_in_at, created_at, updated_at
  ) values (
    gen_random_uuid(), v_id, v_id::text, 'email',
    jsonb_build_object('sub', v_id::text, 'email', p_email, 'email_verified', true),
    now(), now(), now()
  );

  return v_id;
end $$;

do $$
declare
  v_approved uuid;
  v_pending  uuid;
  v_rejected uuid;
begin
  -- 1. Mitra terverifikasi (data mengikuti app/data/dummy.ts)
  v_approved := pg_temp.create_test_user(
    'mitra.approved@ezyhomecare.test', 'Test1234!',
    '{"role":"THERAPIST","full_name":"Ahmad Fauzi","phone":"081234500001","license_no":"SIP.446/2024/DPMPTSP.SBY","area":"Surabaya Timur"}'
  );
  update public.therapists set
    verification_status = 'approved',
    verified_at         = now(),
    rejection_reason    = null,
    is_available        = true,
    radius_km           = 5,
    specialties         = array['Bekam Medis', 'Akupresur'],
    bank_name           = 'BCA',
    bank_account_no     = '1234564521',
    bank_account_name   = 'Ahmad Fauzi',
    completed_sessions  = 342,
    rating_avg          = 4.9,
    review_count        = 148,
    sop_violations      = 0
  where id = v_approved;

  insert into public.therapist_services (therapist_id, service_id, is_active)
  select v_approved, s.id, s.slug <> 'refleksi-relaksasi'
    from public.services s
   where s.slug in ('bekam-sunnah', 'bekam-premium', 'refleksi-relaksasi')
  on conflict (therapist_id, service_id) do update set is_active = excluded.is_active;

  -- 2. Mitra baru daftar, menunggu verifikasi
  v_pending := pg_temp.create_test_user(
    'mitra.pending@ezyhomecare.test', 'Test1234!',
    '{"role":"THERAPIST","full_name":"Rina Wulandari","phone":"081234500002","license_no":"SIP.446/2025/DPMPTSP.SBY","area":"Surabaya Barat"}'
  );
  update public.therapists set
    verification_status = 'pending', verified_at = null, rejection_reason = null, is_available = false
  where id = v_pending;

  -- 3. Mitra ditolak
  v_rejected := pg_temp.create_test_user(
    'mitra.rejected@ezyhomecare.test', 'Test1234!',
    '{"role":"THERAPIST","full_name":"Dedi Kurniawan","phone":"081234500003","license_no":"-","area":"Sidoarjo"}'
  );
  update public.therapists set
    verification_status = 'rejected', verified_at = null, is_available = false,
    rejection_reason    = 'Nomor SIP tidak valid. Silakan hubungi Tim Kemitraan dengan dokumen SIP terbaru.'
  where id = v_rejected;

  -- 4. Customer (untuk menguji penolakan login di app Mitra)
  perform pg_temp.create_test_user(
    'customer@ezyhomecare.test', 'Test1234!',
    '{"role":"CUSTOMER","full_name":"Budi Santoso","phone":"081234500004"}'
  );
end $$;

-- Cek hasil
select u.email, p.role, t.verification_status, t.is_available
  from auth.users u
  join public.profiles p on p.id = u.id
  left join public.therapists t on t.id = u.id
 where u.email like '%@ezyhomecare.test'
 order by u.email;

-- =============================================================================
-- Hapus semua akun uji (jalankan terpisah bila perlu):
--   delete from auth.users where email like '%@ezyhomecare.test';
-- profiles, therapists, dan data turunannya ikut terhapus (on delete cascade).
-- =============================================================================
