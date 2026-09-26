<script setup lang="ts">
import {
  Bell,
  PenLine,
  Award,
  HeartPulse,
  Heart,
  MapPin,
  ClipboardList,
  Wallet,
  Star,
  Headphones,
  ShieldCheck,
  Shield,
  LogOut,
  ChevronRight,
  Settings
} from '@lucide/vue'

definePageMeta({ showBottomNav: true })

const { user, logout } = useAuth()
const router = useRouter()

function signOut() {
  logout()
  router.push('/auth/login')
}
</script>

<template>
  <div class="pb-8 bg-cream-soft">
    <!-- Header -->
    <header class="flex items-center gap-3 px-5 pb-4 pt-6 bg-cream">
      <div class="flex items-center gap-2">
        <svg class="h-6 w-6 text-primary-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="6" cy="12" r="2" />
          <line x1="8" y1="12" x2="16" y2="12" />
          <circle cx="18" cy="12" r="2" />
        </svg>
        <h1 class="font-display text-[17px] font-bold text-ink">Profil</h1>
      </div>
      <div class="ml-auto flex items-center gap-4">
        <button type="button" class="relative text-ink">
          <Bell :size="20" />
        </button>
        <div class="h-8 w-8 rounded-full overflow-hidden bg-primary-600 border border-line shadow-sm">
          <img src="https://i.pravatar.cc/150?img=11" alt="Avatar" class="h-full w-full object-cover" />
        </div>
      </div>
    </header>

    <div class="px-5 pt-2">
      <!-- Profile Card -->
      <div class="rounded-[1.25rem] bg-white p-4 shadow-soft">
        <div class="flex items-start gap-4">
          <div class="relative shrink-0">
            <div class="h-16 w-16 overflow-hidden rounded-full bg-cream-soft border-2 border-white shadow-sm">
              <img src="https://i.pravatar.cc/150?img=11" alt="Avatar" class="h-full w-full object-cover" />
            </div>
            <div class="absolute -bottom-1 -right-1 flex h-6 w-6 items-center justify-center rounded-full bg-primary-600 border-2 border-white text-white">
              <Settings :size="12" />
            </div>
          </div>
          
          <div class="flex-1 min-w-0 pt-1">
            <h2 class="font-display text-[15px] font-bold text-ink truncate">{{ user.name }}</h2>
            <p class="mt-0.5 text-[13px] text-ink-soft truncate">{{ user.email }}</p>
            <p class="mt-0.5 text-[13px] text-ink-soft">{{ user.phone }}</p>
          </div>
          
          <button class="flex items-center gap-1 rounded-full bg-primary-50 px-3 py-1.5 text-[12px] font-semibold text-primary-600">
            <PenLine :size="12" />
            Ubah
          </button>
        </div>

        <!-- Membership & Points -->
        <div class="mt-4 flex items-center justify-between rounded-xl bg-primary-50 px-4 py-3">
          <div class="flex items-start gap-3">
            <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-orange-400 text-white">
              <Award :size="20" />
            </div>
            <div>
              <p class="flex items-center gap-1 font-display text-[13px] font-bold text-ink">
                CareMember <Star :size="12" class="fill-orange-400 text-orange-400" />
              </p>
              <p class="text-[12px] text-ink-soft">Prioritas Res...</p>
            </div>
          </div>
          <div class="text-right">
            <p class="font-display text-[14px] font-bold text-primary-700">450 Poin</p>
            <p class="text-[12px] text-ink-soft">12 Terapi Selesai</p>
          </div>
        </div>
      </div>

      <!-- Health Info Cards -->
      <div class="mt-4 flex gap-3">
        <div class="flex-1 rounded-[1.25rem] bg-white p-4 shadow-soft">
          <div class="flex items-center justify-between mb-2">
            <p class="text-[13px] text-ink-soft">Kebugaran</p>
            <HeartPulse :size="16" class="text-primary-600" />
          </div>
          <p class="font-display text-[15px] font-bold text-primary-600">Optimal</p>
          <p class="mt-1 text-[12px] text-ink-soft">Tekanan Darah:<br>120/80</p>
        </div>
        <div class="flex-1 rounded-[1.25rem] bg-white p-4 shadow-soft">
          <div class="flex items-center justify-between mb-2">
            <p class="text-[13px] text-ink-soft">Terapis Tetap</p>
            <Heart :size="16" class="text-orange-400" />
          </div>
          <p class="font-display text-[15px] font-bold text-ink">3 Terapis</p>
          <p class="mt-1 text-[12px] text-ink-soft">Fisioterapi &<br>Akupresur</p>
        </div>
      </div>
    </div>

    <!-- Section 1 -->
    <div class="mt-6 px-5">
      <div class="mb-3 flex items-center justify-between">
        <h3 class="font-display text-[12px] font-bold tracking-wider text-ink-soft uppercase">Layanan & Rekam Medis</h3>
        <span class="text-[12px] font-medium text-primary-600">Data Terproteksi</span>
      </div>
      <div class="flex flex-col rounded-[1.25rem] bg-white shadow-soft">
        <NuxtLink to="/customer/profile/addresses" class="flex items-center gap-3 p-4 text-left border-b border-line last:border-0 hover:bg-surface transition-colors">
          <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary-50 text-primary-600">
            <MapPin :size="20" />
          </div>
          <div class="flex-1 min-w-0">
            <p class="font-display text-[14px] font-bold text-ink">Daftar Alamat Saya</p>
            <p class="truncate text-[12px] text-ink-soft">Jl. Sudirman No. 123, Jakarta...</p>
          </div>
          <ChevronRight :size="16" class="text-ink-soft" />
        </NuxtLink>

        <NuxtLink to="/customer/profile/medical-record" class="flex items-center gap-3 p-4 text-left border-b border-line last:border-0 hover:bg-surface transition-colors">
          <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary-50 text-primary-600">
            <ClipboardList :size="20" />
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2">
              <p class="font-display text-[14px] font-bold text-ink">Catatan & Riwayat Kesehatan</p>
              <span class="rounded bg-primary-50 px-1.5 py-0.5 text-[10px] font-bold text-primary-600">Penting</span>
            </div>
            <p class="truncate text-[12px] text-ink-soft">Alergi minyak kayu putih • T...</p>
          </div>
          <ChevronRight :size="16" class="text-ink-soft" />
        </NuxtLink>

        <NuxtLink to="/customer/payment" class="flex items-center gap-3 p-4 text-left border-b border-line last:border-0 hover:bg-surface transition-colors">
          <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary-50 text-primary-600">
            <Wallet :size="20" />
          </div>
          <div class="flex-1 min-w-0">
            <p class="font-display text-[14px] font-bold text-ink">Metode Pembayaran & Dompet</p>
            <p class="truncate text-[12px] text-ink-soft">GoPay, OVO, BCA Virtual Ac...</p>
          </div>
          <ChevronRight :size="16" class="text-ink-soft" />
        </NuxtLink>
        
        <NuxtLink to="/customer/therapists/favorites" class="flex items-center gap-3 p-4 text-left border-b border-line last:border-0 hover:bg-surface transition-colors">
          <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-orange-50 text-orange-600">
            <Star :size="20" />
          </div>
          <div class="flex-1 min-w-0">
            <p class="font-display text-[14px] font-bold text-ink">Terapis Langganan & Favorit</p>
            <p class="truncate text-[12px] text-ink-soft">Bdn. Siti Rohmah, Ns. Hendr...</p>
          </div>
          <ChevronRight :size="16" class="text-ink-soft" />
        </NuxtLink>
      </div>
    </div>

    <!-- Section 2 -->
    <div class="mt-6 px-5">
      <h3 class="mb-3 font-display text-[12px] font-bold tracking-wider text-ink-soft uppercase">Pengaturan & Dukungan</h3>
      <div class="flex flex-col rounded-[1.25rem] bg-white shadow-soft">
        <NuxtLink to="/customer/profile/help-center" class="flex items-center gap-3 p-4 text-left border-b border-line last:border-0 hover:bg-surface transition-colors">
          <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary-50 text-primary-600">
            <Headphones :size="20" />
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2">
              <p class="font-display text-[14px] font-bold text-ink">Pusat Bantuan & WhatsApp 24 Jam</p>
              <span class="rounded bg-primary-50 px-1.5 py-0.5 text-[10px] font-bold text-primary-600">Siaga</span>
            </div>
            <p class="truncate text-[12px] text-ink-soft">Respon cepat darurat & jad...</p>
          </div>
          <ChevronRight :size="16" class="text-ink-soft" />
        </NuxtLink>

        <button class="flex items-center gap-3 p-4 text-left border-b border-line last:border-0">
          <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary-50 text-primary-600">
            <ShieldCheck :size="20" />
          </div>
          <div class="flex-1 min-w-0">
            <p class="font-display text-[14px] font-bold text-ink">Keamanan & Notifikasi</p>
            <p class="truncate text-[12px] text-ink-soft">PIN transaksi, verifikasi bio...</p>
          </div>
          <ChevronRight :size="16" class="text-ink-soft" />
        </button>
        
        <NuxtLink to="/customer/profile/privacy" class="flex items-center gap-3 p-4 text-left border-b border-line last:border-0 hover:bg-surface transition-colors">
          <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary-50 text-primary-600">
            <Shield :size="20" />
          </div>
          <div class="flex-1 min-w-0">
            <p class="font-display text-[14px] font-bold text-ink">Kebijakan Privasi Medis (HIPAA Compliant)</p>
            <p class="truncate text-[12px] text-ink-soft">Kerahasiaan rekam medis & ...</p>
          </div>
          <ChevronRight :size="16" class="text-ink-soft" />
        </NuxtLink>
      </div>
    </div>

    <div class="px-5 mt-6 mb-8">
      <button
        @click="signOut"
        class="flex w-full items-center justify-center gap-2 rounded-xl bg-red-100 py-3.5 text-[14px] font-bold text-red-600 transition-colors hover:bg-red-200"
      >
        <LogOut :size="18" />
        Keluar dari Akun
      </button>

      <div class="mt-6 text-center">
        <p class="flex items-center justify-center gap-1 text-[12px] font-semibold text-ink">
          <span class="h-2 w-2 rounded-full bg-primary-600"></span>
          CareHome Mobile v1.4.2 (Build 2026)
        </p>
        <p class="mt-1 text-[11px] text-ink-soft max-w-[250px] mx-auto leading-relaxed">
          Platform Layanan Medis & Fisioterapi Rumah Tersertifikasi Kemenkes RI
        </p>
      </div>
    </div>
  </div>
</template>
