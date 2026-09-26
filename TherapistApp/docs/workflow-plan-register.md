# Work Plan: Hubungkan `useAuth` TherapistApp ke Supabase (Register & Login)

## Context

`TherapistApp/app/composables/useAuth.ts` masih dummy: `login()` hanya mengubah `isLoggedIn = true`, dan `user` berisi `therapistProfile` dari `app/data/dummy.ts`. Skema Supabase sudah tersedia di `docs/schema.sql` (tabel `profiles`, `therapists`, trigger `handle_new_user`, RPC `get_my_role` & `get_my_therapist_status`). Target: mitra bisa **daftar** (data dasar) dan **login dengan email + password**. Hanya akun ber-role `THERAPIST` yang boleh masuk, dan mitra yang belum di-approve admin diarahkan ke layar "menunggu verifikasi".

Keputusan yang sudah diambil:
- Login memakai **email + password**. Nomor HP tetap disimpan di profil.
- Register **hanya data dasar**. Upload dokumen menyusul di tahap berikutnya.
- Di luar scope: lupa password, OTP, upload dokumen, dan booking/jadwal ke Supabase.

## Pendekatan

Pakai `@supabase/supabase-js` langsung, bukan modul `@nuxtjs/supabase`. Alasannya, aplikasi akan menjadi SPA di dalam APK Capacitor (PRD §5.3), sehingga tidak butuh sesi berbasis cookie/SSR. Sesi disimpan di localStorage bawaan supabase-js, yang juga berfungsi di WebView Capacitor.

## Langkah

### 1. Setup & konfigurasi
- `bun add @supabase/supabase-js`
- [nuxt.config.ts](../nuxt.config.ts):
  - tambahkan `ssr: false`
  - tambahkan `runtimeConfig.public.supabaseUrl` dan `supabaseKey`
- `.env`: ganti nama `VITE_SUPABASE_URL` / `VITE_SUPABASE_PUBLISHABLE_KEY` menjadi `NUXT_PUBLIC_SUPABASE_URL` / `NUXT_PUBLIC_SUPABASE_KEY`, supaya terbaca oleh runtimeConfig Nuxt.
- Buat `.env.example` berisi nama variabel tanpa nilai. File ini sudah di-whitelist di `.gitignore`.

### 2. Client Supabase
- **Baru** `app/plugins/supabase.client.ts`: `createClient(url, key)`, lalu `provide('supabase', client)`.
- **Baru** `app/composables/useSupabase.ts`: `() => useNuxtApp().$supabase`.

### 3. Tulis ulang [useAuth.ts](../app/composables/useAuth.ts)

**State (`useState`):**
- `session`
- `user`: bentuknya tetap sama dengan `therapistProfile` agar UI tidak berubah
- `verificationStatus`
- `ready` (sesi awal sudah dicek)

**Nama yang tetap diekspor** (untuk kompatibilitas): `isLoggedIn` (computed dari `session`), `user`, `available`, `login`, `logout`.

**Fungsi:**
- `init()`: dipanggil sekali oleh plugin.
  - Panggil `getSession()`, lalu `loadProfile()`.
  - Pasang `onAuthStateChange` untuk sinkronisasi dan logout otomatis.
- `login(email, password)`:
  1. Panggil `signInWithPassword`.
  2. Panggil `rpc('get_my_role')`. Jika hasilnya bukan `THERAPIST`: `signOut()` lalu throw `"Akun ini bukan akun mitra"`.
  3. Panggil `loadProfile()`.
- `register({ fullName, phone, email, password, licenseNo, area })`:
  - Panggil `signUp` dengan `options.data = { role: 'THERAPIST', full_name, phone, license_no, area }`.
  - Trigger `handle_new_user` otomatis membuat `profiles` + `therapists` (status `pending`) + jadwal default.
  - Return `{ needsEmailConfirm: !data.session }`.
- `loadProfile()`:
  - Ambil data: `select` dari `profiles` join `therapists`.
  - Petakan hasilnya ke `user`:
    - `name`, `initials` (diturunkan dari nama)
    - `licenseNo`, `area`, `radiusKm`, `specialties`
    - `completedSessions`, `rating`, `reviewCount`, `sopViolations`
    - `bankAccount` dengan mask `•••• 1234`
    - `onTimePct`: belum ada di DB, isi `null` dan tampilkan `-`
  - Set `verificationStatus` dan `available` (`is_available`).
- `available`: writable computed. Setter-nya melakukan `update therapists set is_available`. Kalau gagal atau belum approved, nilainya di-revert. Trigger DB memang sudah memaksa `false` untuk mitra yang belum approved.
- `logout()`: `signOut()`, lalu reset semua state.
- `mapAuthError()`: menerjemahkan error Supabase ke bahasa Indonesia:
  - `Invalid login credentials` → "Email atau kata sandi salah"
  - `Email not confirmed` → "Email belum dikonfirmasi"
  - `User already registered` → "Email sudah terdaftar"

Pemanggil yang sudah ada tetap jalan tanpa diubah: [TopBar.vue](../app/components/TopBar.vue), [order/index.vue](../app/pages/order/index.vue), [profil/index.vue](../app/pages/profil/index.vue).

Hapus `therapistProfile` dari [dummy.ts](../app/data/dummy.ts) setelah tidak dipakai lagi. Tipe `TherapistUser` dipindah ke `useAuth.ts`.

### 4. Middleware [auth.global.ts](../app/middleware/auth.global.ts)
- Tunggu `ready` (`await init()`) sebelum memutuskan apa pun.
- Route publik: `/login` dan `/daftar`.
  - Jika sudah login dan approved → redirect ke `/order`.
- Belum login → `/login`.
- Login tapi `verificationStatus !== 'approved'` → `/verifikasi`. Halaman `/verifikasi` sendiri tetap boleh dibuka.

### 5. Halaman
- [login.vue](../app/pages/login.vue):
  - Input HP diganti email (ikon `Mail`, `type="email"`).
  - Tambahkan state `loading`/`error` dan tombol disabled saat submit.
  - `submit`: `await login()`, lalu `navigateTo` sesuai status.
  - Teks "Hubungi Tim Kemitraan" diganti link `NuxtLink` ke `/daftar`.
  - Tombol "Lupa kata sandi?" dibiarkan (di luar scope).
- **Baru** `app/pages/daftar.vue`:
  - Layout `blank`, gaya visual sama dengan login.
  - Field: Nama lengkap, No. HP, Email, Kata sandi (min. 8 karakter), No. SIP, Area.
  - Validasi di client.
  - Setelah sukses:
    - jika `needsEmailConfirm`: tampilkan "Cek email untuk konfirmasi", lalu arahkan ke `/login`
    - jika tidak: `/verifikasi`
- **Baru** `app/pages/verifikasi.vue`:
  - Layout `blank`, isi status sesuai kondisi:
    - `pending`: "Akun sedang ditinjau"
    - `rejected`: tampilkan `rejection_reason`
    - `suspended`
  - Tombol "Cek status lagi" (`loadProfile()`) dan tombol "Keluar".

### 6. Supabase Dashboard (manual)
- Jalankan `docs/schema.sql` (sudah dilakukan).
- Auth → Providers → Email: aktif.
- Pilih salah satu:
  - matikan **Confirm email** untuk MVP, atau
  - biarkan aktif dan isi Site URL / Redirect URL.

## File yang disentuh

| Aksi | File |
|---|---|
| Ubah | `nuxt.config.ts`, `package.json`, `.env`, `app/composables/useAuth.ts`, `app/middleware/auth.global.ts`, `app/pages/login.vue`, `app/data/dummy.ts` |
| Baru | `.env.example`, `app/plugins/supabase.client.ts`, `app/composables/useSupabase.ts`, `app/pages/daftar.vue`, `app/pages/verifikasi.vue` |

## Verifikasi

1. Jalankan `bun run dev`, buka `http://localhost:3000` dengan DevTools mode mobile. Aplikasi harus langsung diarahkan ke `/login`.
2. Buka `/daftar` dan isi form. Di Dashboard, pastikan baris baru muncul di:
   - `auth.users`
   - `profiles` (role `THERAPIST`)
   - `therapists` (`pending`)
   - `schedules` (7 baris)
3. Login dengan akun tadi. Karena masih pending, aplikasi harus masuk ke `/verifikasi`.
4. Di SQL Editor, jalankan:
   ```sql
   update therapists set verification_status = 'approved' where id = '<uuid>';
   ```
   Klik "Cek status lagi". Aplikasi harus pindah ke `/order`, dan nama/area/rating diambil dari DB.
5. Toggle **Siaga** di TopBar. Kolom `therapists.is_available` harus ikut berubah.
6. Reload halaman. Sesi harus bertahan dan tidak kembali ke login.
7. Coba login dengan akun ber-role `CUSTOMER` (signup tanpa `role`). Login harus ditolak dengan pesan "bukan akun mitra".
8. Coba password salah. Harus muncul pesan error berbahasa Indonesia.
9. Klik Keluar di Profil. Aplikasi harus kembali ke `/login`, dan route terlindungi tidak bisa diakses.
10. Jalankan `bun run generate` untuk memastikan build SPA sukses (penting untuk Capacitor).
