PRD — Aplikasi Home Care & Wellness
Web Responsive + PWA

Nama sementara: CareHome
Platform: Web App + PWA
Target: Mobile-first, responsive desktop
Model: Customer melakukan booking layanan ke terapis yang datang ke rumah.

1. Product Vision

Aplikasi untuk memudahkan pelanggan memesan layanan kesehatan/wellness ke rumah seperti:
Akupunktur
Bekam
Pijat refleksi
Pijat tradisional
Massage
Pijat relaksasi
Terapi kebugaran
Layanan wellness lainnya

Customer tidak perlu datang ke tempat praktik. Customer cukup:

Pilih layanan → pilih jadwal → masukkan alamat → pilih terapis → bayar → terapis datang ke rumah.

2. Target User

Ada 3 role utama.

2.1 Customer
Pengguna yang membutuhkan layanan home care.

Fitur:
Register/login
Browse layanan
Pilih layanan
Pilih terapis
Pilih tanggal & jam
Input alamat
Booking
Pembayaran
Tracking status booking
Riwayat layanan
Rating/review

2.2 Therapist / Practitioner
Contoh:
Terapis bekam
Terapis pijat
Terapis refleksi
Praktisi akupunktur

Fitur:
Login
Profil
Jadwal kerja
Terima/tolak booking
Melihat booking
Detail customer
Navigasi ke lokasi
Update status kunjungan
Catatan layanan
Pendapatan

2.3 Admin
Mengelola seluruh sistem.

3. Business Model

Untuk MVP, gunakan model sederhana:

Commission Based

Contoh:

Customer membayar:

Rp150.000

Platform mengambil:

20% = Rp30.000

Terapis mendapatkan:

Rp120.000

Admin dapat mengatur:

commission_type:
- percentage
- fixed
----------------
mulai dari 10 layar ini dulu:

#Customer
Login/Register
Home
Service Detail
Therapist Selection
Schedule
Address
Checkout
Payment Success
Booking Tracking
History

====
Saya telah menyelesaikan tahap awal perancangan CareHome, fokus pada alur utama Customer sesuai spesifikasi "Professional Healthcare + Warm Wellness".

Berikut adalah apa yang telah saya siapkan:

Design System: Menggunakan palet Teal (#16877A) yang menenangkan, tipografi Plus Jakarta Sans yang modern, serta sistem radius dan spacing yang dioptimalkan untuk kenyamanan penggunaan (30-55 tahun).
Aset Brand: Logo minimalis CareHome dan foto profil Agus untuk memberikan sentuhan personal.
8 Layar Utama Customer:
Home: Navigasi intuitif dengan pencarian dan kategori layanan.
Kategori & Detail: Informasi layanan yang transparan dan berorientasi pada konversi.
Booking Flow: Proses pemilihan terapis, jadwal, dan lokasi yang disederhanakan menjadi 4 langkah utama.
Tracking: Pelacakan status pesanan secara real-time untuk membangun rasa aman bagi pengguna.
Semua desain ini mengikuti pendekatan mobile-first untuk memastikan pengalaman terbaik di perangkat seluler.

Langkah selanjutnya: Apakah Anda ingin saya melanjutkan ke perancangan 5 layar untuk Therapist UI, atau ada penyesuaian yang ingin Anda lakukan pada alur Customer ini?

----
A Go Client library for Supabase
https://github.com/supabase-community/supabase-go

https://medium.com/@lengzuo/accelerating-your-golang-backend-with-supabase-api-23bd377cbae6
https://github.com/lengzuo/supa

https://piccalil.li/blog/a-look-at-the-geolocation-html-element-and-how-it-works/?via=dailydev

package main

import (
    "fmt"
    "github.com/lengzuo/supa"
)

func main() {
    conf := supabase.Config{
        // Your project api key, you can use either `anon` or `service_role`.
        // but i will suggest you to use `service_role` as your api key and keep it secret.
        ApiKey:     "your-project-api-key",
        // Retrieve your project ref from project url
        // eg: https://this-your-project-ref.supabase.co
        ProjectRef: "your-project-ref",
        // Set it `false` in production to avoid extra log print.
        Debug:      true,
     }
     supaClient, err := supabase.New(conf)
     if err != nil {
          fmt.Println("failed in init supa client: ", err)
          return
     }
}

func signUp(supaClient *supabase.Client) {
    body := dto.SignUpRequest{
        Email:    "user@email.com",
	Password: "user-password",
    }
    resp, err := supaClient.Auth.SignUp(ctx, body)
    if err != nil {
        var supaErr catch.Exception
        // use this to catch the error of http status code != 2xx 
        if errors.As(err, &supaErr) {
	     log.Error("status: %d, err: %s", supaErr.StatusCode(), supaErr.Error())
	     return
	}
        fmt.Println("failed in sign up: ", err)
        return
    }
    bytes, _ := json.Marshal(resp)
    fmt.Printf("sign up success: %s", bytes)
}

func signInWithPassword(supaClient *supabase.Client) {
    body := dto.SignInRequest{
        Email:    "user@email.com",
        Password: "user-password",
    }
    resp, err := supaClient.Auth.SignInWithPassword(ctx, body)
    if err != nil {
       ...
    }
    bytes, _ := json.Marshal(resp)
    fmt.Printf("sign in with password success: %s", bytes)
}

func getAuthUser(supaClient *supabase.Client) {
    token = "logged-in-access-token"
    user, err := supaClient.Auth.User(ctx, token)
    if err != nil {
       ...
    }
    bytes, _ := json.Marshal(resp)
    fmt.Printf("sign in with password success: %s", bytes)
}

----
PRD-nya berhenti di Bagian 3 (Business Model). Berikut lanjutan lengkapnya supaya dokumen siap dipakai sebagai acuan development.

---

## 4. Fitur Detail per Role

### 4.1 Customer
**Akun & Profil**
- Register/login: nomor HP + OTP (primary), email/password, Google
- Alamat tersimpan (multi-address): label (Rumah/Kantor), alamat lengkap, pin lokasi di peta, catatan untuk terapis
- Data kesehatan singkat (opsional): alergi, kondisi medis
- Booking untuk anggota keluarga (nama + hubungan)

**Booking & Pembayaran**
- Browse layanan per kategori, search, filter (harga, durasi, rating)
- Detail layanan: deskripsi, manfaat, durasi, harga, ulasan
- Pilih terapis: profil, rating, pengalaman, spesialisasi; opsi *"biarkan sistem pilih terapis"*
- Pilih tanggal & slot dari ketersediaan real-time
- Kode promo
- Bayar: QRIS, VA bank, e-wallet (via Midtrans/Xendit)

**Pasca-Booking**
- Tracking status real-time + push notification
- Cancel/reschedule sesuai kebijakan
- Riwayat + invoice
- Rating & review (hanya booking selesai)
- Re-booking 1 klik

### 4.2 Therapist
- Profil: bio, foto, spesialisasi, pengalaman, sertifikat (upload → verifikasi admin)
- Jadwal kerja: set ketersediaan mingguan + blok waktu libur
- Booking masuk: notifikasi, terima/tolak (dengan alasan), timeout auto-reject → sistem re-assign
- Detail booking: info customer, alamat + tombol navigasi Google Maps
- Update status kunjungan: *on the way → arrived → in progress → completed*
- Catatan layanan: hasil treatment, kondisi customer, rekomendasi tindak lanjut
- Dompet: saldo, riwayat earning, status payout
- Statistik: rating, jumlah sesi, pendapatan bulanan

### 4.3 Admin
- Dashboard: booking hari ini, revenue, terapis aktif, rating rata-rata
- Verifikasi terapis: KTP, sertifikat kompetensi, izin praktik (khusus akupunktur) → approve/reject
- Manajemen layanan: CRUD kategori & layanan, harga default, durasi
- Manajemen booking: monitoring, re-assign terapis, cancel + refund manual
- Pengaturan komisi: `commission_type` (percentage/fixed), nilai, scope
- Payout: kalkulasi otomatis, approve, tandai sudah dibayar
- Promo: CRUD kode promo (diskon %/nominal, kuota, periode)
- Moderasi review, blokir user, laporan

---

## 5. Status Booking (State Machine)

| Status | Trigger | Transisi berikutnya |
|---|---|---|
| `draft` | Checkout, belum bayar | `paid` / `expired` |
| `paid` | Webhook pembayaran | `finding_therapist` |
| `finding_therapist` | Broadcast ke terapis | `accepted` / re-assign / `cancelled_refund` |
| `accepted` | Terapis terima | `on_the_way` |
| `on_the_way` | Terapis | `arrived` |
| `arrived` | Terapis | `in_progress` |
| `in_progress` | Terapis | `completed` |
| `completed` | Sesi selesai + catatan | `reviewed` (opsional) |

**Kebijakan pendukung:**
- Cancel customer: ≥24 jam = refund penuh; <24 jam = refund 50%; terapis sudah *on the way* = tanpa refund
- Cancel terapis: refund penuh + penalti skor reputasi + auto re-assign
- Travel buffer: minimal 60 menit jeda antar booking terapis
- Slot lock 10 menit saat checkout untuk cegah double-booking

---

## 6. Data Model (Ringkas)

- `users` (id, role, name, phone, email, password_hash, avatar_url, status)
- `addresses` (id, customer_id, label, full_address, lat, lng, notes)
- `therapists` (id, user_id, bio, experience_years, rating_avg, verification_status, area_city)
- `therapist_documents` (id, therapist_id, type, file_url, verified_at)
- `services` (id, category_id, name, description, duration_min, base_price, is_active)
- `therapist_services` (therapist_id, service_id, price_override)
- `availabilities` (id, therapist_id, day_of_week, start_time, end_time)
- `bookings` (id, code, customer_id, therapist_id, service_id, address_id, scheduled_at, duration_min, status, total_price, discount, commission_amount, therapist_earning, recipient_name, notes)
- `payments` (id, booking_id, provider, method, amount, status, paid_at)
- `payouts` (id, therapist_id, amount, period, status, processed_at)
- `reviews` (id, booking_id, rating, comment)
- `promos` (id, code, discount_type, value, quota, used, valid_from, valid_until)
- `settings` (key, value) → commission_type, commission_value, dll.
- `notifications` (id, user_id, type, title, body, payload, read_at)

---

## 7. Business Logic Komisi (melanjutkan Bagian 3)

**Perhitungan saat booking dibayar:**
- `percentage`: commission = round(total_bayar × 20%) → contoh: 150rb × 20% = 30rb, terapis 120rb
- `fixed`: commission = nilai tetap (mis. Rp25.000)
- `therapist_earning = total_bayar − commission`

**Aturan:**
- Override scope: per terapis > per layanan > global
- Earning masuk ledger terapis setelah `completed` (hold 1×24 jam untuk dispute)
- Refund penuh → komisi dibatalkan; refund 50% → komisi proporsional
- Pembulatan ke ratusan terdekat
- Payout: manual/weekly oleh admin (MVP) → otomatis via disbursement API (Phase 2)

---

## 8. Pembayaran

- Gateway: Midtrans Snap atau Xendit Invoice (QRIS, VA, e-wallet)
- Flow: create transaction → customer bayar → webhook → verifikasi signature → update booking → assign terapis
- Webhook wajib idempotent + log retry
- Unpaid booking timeout 30 menit → auto-cancel, slot dilepas

---

## 9. Tech Stack (Rekomendasi)

| Layer | Pilihan | Catatan |
|---|---|---|
| Frontend | Next.js + Tailwind | PWA-ready, SEO untuk halaman layanan |
| Backend | NestJS / Laravel | Sesuaikan dengan tim |
| Database | PostgreSQL | Transaksi + scheduling |
| Cache/Queue | Redis | Job webhook, notifikasi |
| Realtime | WebSocket / Supabase Realtime | Tracking status |
| Storage | S3 / Cloudflare R2 | Foto, sertifikat, invoice |
| Maps | Google Maps Platform | Geocoding, distance, navigasi |
| Push | FCM (Web Push) | Notifikasi PWA |
| Auth | JWT + refresh, OTP WhatsApp/SMS | |

*Alternatif cepat untuk MVP: Supabase (DB + auth + storage + realtime sekaligus).*

---

## 10. PWA & Non-Functional

- Manifest + ikon maskable + splash screen, installable (add-to-homescreen)
- Service worker: cache app shell, offline fallback
- Push notification untuk setiap perubahan status booking
- Target: LCP < 2,5s, bundle awal < 200KB gzip
- Keamanan: argon2/bcrypt, rate limiting, webhook signature, enkripsi PII
- Privasi: consent khusus data kesehatan (intake form), akses catatan medis terbatas

---

## 11. Scope MVP & Roadmap

**Phase 1 — MVP (6–8 minggu):** Auth + OTP, 3–5 layanan awal, alur booking lengkap, 1 gateway pembayaran, accept/reject booking, tracking status, review, admin dasar (verifikasi terapis, set komisi, payout manual), PWA installable + push.

**Phase 2:** Chat in-app, promo engine lengkap, paket sesi (5+1), booking untuk keluarga, multi-kota, disbursement otomatis.

**Phase 3:** Matching otomatis terapis terdekat, langganan wellness bulanan, B2B perusahaan, loyalty/referral.

---

## 12. Edge Cases & Kebijakan Penting

- Customer tidak di rumah → hubungi 3× (15 menit) → no-show, tanpa refund
- Terapis telat >30 menit → notifikasi ETA + kebijakan kompensasi
- Kontraindikasi kesehatan → intake form wajib (hamil, hipertensi, luka terbuka) → terapis boleh tolak dengan aman
- Keselamatan terapis → tombol SOS (opsional MVP), verifikasi identitas customer
- Webhook duplikat → idempotency key

---

## 13. Open Questions (perlu keputusan)

1. Area coverage MVP — kota mana dulu?
2. Auto-assign terapis vs terapis accept manual?
3. Preferensi gender terapis (penting untuk layanan pijat)?
4. Komisi dihitung dari harga sebelum atau sesudah diskon promo?
5. Minimum lead time booking (mis. 2 jam sebelum sesi)?
6. Booking untuk anggota keluarga — MVP atau Phase 2?
7. Jadwal payout — mingguan / bi-weekly / on-demand?

---

Mau saya lanjutkan ke salah satu dari ini?

1. **ERD lengkap + skema SQL** (siap migrasi)
2. **API specification** per role
3. **Daftar layar/wireframe** (customer, therapist, admin)
4. **Langsung scaffold kode MVP** (Next.js + Supabase)

--- Jual Rumah
Pph		2.5
BPHTB		5%
Biaya Notaris
KPR
Agency Fee	3
---------------------- +
Total Biaya	10-15%

---

Total Aset - Total Utang

Total Aset
- Rumah			375juta *
- Tanah Kavling 72M	135juta *
- Tanah Kavling 119M	145juta *
- Saham			 34juta
- Warisan		250juta *

Total Utang
- Kredit Rumah		 90juta
- Kredit Kartu		  6juta

Target Aset Bersih
1,5 Miliar

Target Waktu
3 Tahun

---

Konsisten
- Broadcast 3x sehari

Skill

Keberuntungan


https://drive.google.com/file/d/1eoXI4nb9eKV4F_WA7Ad5bR0yIqhDzFVq/view?usp=sharing