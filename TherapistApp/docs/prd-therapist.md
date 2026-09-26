# PRD: EzyHomecare Mitra (Aplikasi Terapis)

> Dokumen turunan dari [prd.txt](prd.txt). Fokusnya aplikasi untuk terapis/mitra, yang dirilis sebagai **APK terpisah** dari aplikasi customer.

---

## 1. Ringkasan

Terapis memakai aplikasi sendiri untuk menerima booking, melihat lokasi customer, mengubah status kunjungan, mengatur jadwal, dan melihat pendapatan.

| | Customer | Mitra (Terapis) |
|---|---|---|
| Nama aplikasi | EzyHomecare | EzyHomecare Mitra |
| appId / package | `com.ezyhomecare.app` | `com.ezyhomecare.mitra` |
| Folder proyek | `CustomerApp/` | `TherapistApp/` |
| Pengguna | Customer | Terapis (role `THERAPIST`) |

Kedua APK bisa terpasang bersamaan di satu HP karena package name-nya berbeda.

> **Perubahan dari prd.txt §16:** sebelumnya aplikasi terapis direncanakan sebagai PWA (`carehome.id/therapist`). Sekarang aplikasi terapis menjadi **APK Android native (Capacitor)** agar bisa memakai push notification, GPS, dan dirilis di Play Store.

---

## 2. Arsitektur

```text
┌──────────────────┐      ┌──────────────────┐
│  CustomerApp     │      │  TherapistApp    │
│  Nuxt + Capacitor│      │  Nuxt + Capacitor│
│  com.ezyhomecare │      │  com.ezyhomecare │
│  .app            │      │  .mitra          │
└────────┬─────────┘      └────────┬─────────┘
         │        HTTPS / REST      │
         └───────────┬──────────────┘
                     ▼
            ┌──────────────────┐
            │  Backend API     │
            │  + Database      │
            └──────────────────┘
```

Prinsip:

- **Dua proyek Nuxt terpisah**, satu backend. Halaman terapis **tidak** ditaruh di `CustomerApp/app/pages/therapist/` (ide lama di STRUCTURE.md), karena satu bundle tidak bisa dipecah jadi dua APK dengan rapi.
- Otorisasi memakai **RBAC** (prd.txt §33). Login di aplikasi Mitra hanya menerima akun ber-role `THERAPIST`. Akun customer yang mencoba login ditolak, dan sebaliknya.
- Kedua aplikasi berjalan sebagai **SPA** (`ssr: false`). File web dibundel di dalam APK, dan data diambil dari API.

---

## 3. Fitur MVP Terapis

Halaman-halaman ini sudah ada di `TherapistApp/app/pages/` (masih memakai data dummy):

| Menu | Halaman | Fungsi |
|---|---|---|
| Login | `login.vue` | Login terapis (email/password, OTP opsional) |
| Order | `order/index.vue` | Booking masuk & hari ini, jumlah booking, estimasi pendapatan hari ini |
| Detail Order | `order/[id].vue` | Data customer, layanan, jadwal, alamat, tombol **Navigasi**, **Terima / Tolak**, update status |
| Layanan | `layanan/index.vue` | Layanan yang bisa dikerjakan terapis |
| Riwayat | `riwayat/index.vue` | Booking yang sudah selesai/dibatalkan |
| Pendapatan | `pendapatan/index.vue` | Ringkasan pendapatan per periode |
| Profil | `profil/index.vue` | Data diri, toggle **tersedia/tidak tersedia**, logout |
| Jadwal | `profil/jadwal.vue` | Jam kerja per hari, hari libur, jam istirahat (prd.txt §26) |

### Alur status kunjungan (dari sisi terapis)

```text
WAITING_THERAPIST ──[Terima]──► CONFIRMED
        │                           │
     [Tolak]                 [Mulai Perjalanan]
        ▼                           ▼
   (dialihkan ke               ON_THE_WAY
    terapis lain)                   │ [Saya Sudah Tiba]
                                    ▼
                                 ARRIVED
                                    │ [Mulai Layanan]
                                    ▼
                               IN_PROGRESS
                                    │ [Selesai]
                                    ▼
                                COMPLETED
```

Setiap perubahan status dikirim ke customer (halaman lacak booking).

### Notifikasi terapis (prd.txt §28)

- Booking baru
- Booking dibatalkan
- Pengingat sebelum jadwal booking

Untuk APK: push notification (FCM via `@capacitor/push-notifications`) menggantikan Web Push.

---

## 4. Menjalankan di Browser (Development)

```bash
cd ../TherapistApp          # dari folder CustomerApp
bun install
bun run dev                 # http://localhost:3000
```

Kalau CustomerApp juga sedang berjalan di port 3000, pakai port lain:

```bash
bunx nuxt dev --port 3001
```

Buka di browser dengan DevTools mode mobile (lebar ±390px). Login masih dummy: tekan tombol login dan Anda langsung masuk.

---

## 5. Setup Capacitor untuk APK Terpisah

Saat ini TherapistApp **belum** memakai Capacitor. Ikuti langkah berikut, yang sama dengan setup CustomerApp.

### 5.1 Install dependency

```bash
cd ../TherapistApp
bun add @capacitor/core @capacitor/android @capacitor/app @capacitor/splash-screen @capacitor/status-bar @capacitor/keyboard @capacitor/preferences
bun add -d @capacitor/cli
```

### 5.2 Buat `capacitor.config.json`

```json
{
  "appId": "com.ezyhomecare.mitra",
  "appName": "EzyHomecare Mitra",
  "webDir": ".output/public"
}
```

> ⚠️ **Jangan** isi `server.url` dengan `http://localhost:3000`. Di HP, `localhost` artinya HP itu sendiri, sehingga aplikasi hanya menampilkan layar kosong dengan ikon. Masalah ini pernah terjadi di CustomerApp.

### 5.3 Mode SPA di `nuxt.config.ts`

```ts
export default defineNuxtConfig({
  // ...
  // SPA mode for Capacitor (bundled static files, no server)
  ssr: false,
})
```

### 5.4 Tambahkan script di `package.json`

```json
"scripts": {
  "mobile": "bun run generate && bunx cap sync",
  "mobile:android": "bun run mobile && bunx cap open android"
}
```

Pakai `generate`, bukan `build`, karena `nuxt build` tidak menghasilkan `index.html` yang dibutuhkan Capacitor.

### 5.5 Tambahkan platform Android

```bash
bun run generate
bunx cap add android
```

Perintah ini membuat folder `TherapistApp/android/` dengan `applicationId "com.ezyhomecare.mitra"`.

### 5.6 Ikon & splash sendiri

Supaya ikon Mitra tidak tertukar dengan ikon aplikasi Customer di HP:

```bash
bun add -d @capacitor/assets
# siapkan assets/icon.png (1024x1024) dan assets/splash.png (2732x2732)
bunx capacitor-assets generate --android
```

Gunakan warna/identitas mitra dari `TherapistApp/DESIGN.md` (primary `#00685d`).

---

## 6. Menjalankan di Real Device

1. Aktifkan **Developer Options → USB Debugging** di HP, lalu sambungkan ke PC.
2. Build & buka Android Studio:
   ```bash
   bun run mobile:android
   ```
3. Di Android Studio, pilih device, lalu klik **Run ▶**.
4. **Setiap ada perubahan kode**, jalankan `bun run mobile` lagi, lalu Run ulang.

### Live reload (opsional, hanya saat development)

Isi IP LAN PC di `capacitor.config.json` (HP dan PC harus satu Wi-Fi):

```json
"server": { "url": "http://192.168.x.x:3000", "cleartext": true }
```

```bash
bunx nuxt dev --host
bunx cap sync
```

Hapus lagi blok `server` sebelum build rilis.

---

## 7. Build Rilis

- Setiap aplikasi punya **keystore/alias sendiri** (misalnya `mitra-release.jks`). Simpan keystore di luar repo.
- Atur `versionCode` & `versionName` di `TherapistApp/android/app/build.gradle`, terpisah dari versi aplikasi Customer.
- Di Play Console, aplikasi Mitra memakai **listing sendiri**: nama "EzyHomecare Mitra", package `com.ezyhomecare.mitra`.
- Build: Android Studio → **Build → Generate Signed App Bundle / APK**.

---

## 8. Kode Bersama (nanti)

Untuk MVP, tipe data (booking, user, service) dan API client **disalin** di kedua proyek. Setelah backend stabil, pertimbangkan memindahkannya ke paket bersama (misalnya `shared/` sebagai workspace bun atau Nuxt layer) agar tidak dobel.

---

## 9. Checklist Implementasi

- [ ] Pasang Capacitor di TherapistApp (bagian 5.1–5.5)
- [ ] Ikon & splash Mitra (5.6)
- [ ] Uji di real device (6)
- [ ] Ganti `useAuth` dummy dengan login API + validasi role `THERAPIST`
- [ ] Simpan token dengan `@capacitor/preferences`
- [ ] Hubungkan Order/Detail Order ke API booking, termasuk update status
- [ ] Tombol Navigasi membuka Google Maps (`geo:` / `https://maps.google.com/?daddr=`)
- [ ] Push notification (FCM) untuk booking baru/batal/pengingat
- [ ] Jadwal kerja tersimpan ke backend (`therapist_schedules`, `therapist_time_off`)
- [ ] Keystore & build rilis (7)
