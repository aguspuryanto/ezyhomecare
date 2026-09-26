<script setup lang="ts">
import { ChevronRight, Clock, LogOut, MapPinned, PhoneCall, ShieldAlert, ShieldCheck, Star, UserRound } from '@lucide/vue'

const { user, logout } = useAuth()
const { schedule } = useSchedule()

const activeDays = computed(() => schedule.value.filter((d) => d.active))
const hoursSummary = computed(() => {
  const first = activeDays.value[0]
  return first ? `${first.start} - ${first.end}` : '-'
})

async function handleLogout() {
  await logout()
  await navigateTo('/login')
}
</script>

<template>
  <div class="flex flex-col gap-[18px] px-5 pt-[18px] pb-6">
    <TopBar />

    <!-- Identity -->
    <div class="flex flex-col items-center gap-2.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-[18px] shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
      <div class="relative">
        <div class="flex h-21 w-21 items-center justify-center rounded-full border-[3px] border-white bg-gradient-to-br from-primary-container to-[#00423b] shadow-[0_6px_16px_rgba(0,104,93,0.2)]">
          <UserRound :size="42" class="text-primary-fixed-dim" :stroke-width="1.5" />
        </div>
        <div class="absolute -right-0.5 bottom-0 flex h-6 w-6 items-center justify-center rounded-full border-2 border-white bg-primary">
          <ShieldCheck :size="12" class="text-on-primary" :stroke-width="2.3" />
        </div>
      </div>
      <div class="flex flex-col items-center gap-0.5">
        <span class="text-lg font-bold">Terapis {{ user.name }}</span>
        <span class="text-[12.5px] text-outline">{{ user.licenseNo }}</span>
      </div>
      <div class="flex flex-wrap justify-center gap-2">
        <span class="rounded-lg bg-primary-container/15 px-2.5 py-1 text-[11px] font-semibold text-primary">Terverifikasi</span>
        <span v-if="user.specialties.length" class="rounded-lg bg-surface-container-low px-2.5 py-1 text-[11px] font-semibold text-on-surface-variant">{{ user.specialties.join(' & ') }}</span>
      </div>
    </div>

    <!-- Metrics -->
    <div class="flex gap-2.5">
      <div class="flex flex-1 flex-col items-start gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <MapPinned :size="17" class="text-primary" :stroke-width="1.8" />
        <span class="text-[17px] font-bold">{{ user.completedSessions }}+</span>
        <span class="text-[10.5px] leading-tight text-outline">Terapi Selesai</span>
      </div>
      <div class="flex flex-1 flex-col items-start gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <Clock :size="17" class="text-primary" :stroke-width="1.8" />
        <span class="text-[17px] font-bold">{{ user.onTimePct != null ? `${user.onTimePct}%` : '-' }}</span>
        <span class="text-[10.5px] leading-tight text-outline">Tepat Waktu</span>
      </div>
      <div class="flex flex-1 flex-col items-start gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <ShieldAlert :size="17" class="text-primary" :stroke-width="1.8" />
        <span class="text-[17px] font-bold">{{ user.sopViolations }}</span>
        <span class="text-[10.5px] leading-tight text-outline">Pelanggaran SOP</span>
      </div>
    </div>

    <!-- Operational rows -->
    <div class="flex flex-col rounded-2xl border border-outline-variant/60 bg-surface-container-lowest px-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
      <div class="flex items-center justify-between border-b border-outline-variant/30 py-3">
        <div class="flex items-center gap-2.5">
          <MapPinned :size="18" class="text-primary" :stroke-width="1.8" />
          <div class="flex flex-col">
            <span class="text-[13.5px] font-bold">Radius Layanan Home Service</span>
            <span class="text-[11.5px] text-outline">Jangkauan pencarian pasien otomatis</span>
          </div>
        </div>
        <div class="flex items-center gap-1">
          <span class="text-[13px] font-bold text-primary">{{ user.radiusKm }} km</span>
          <ChevronRight :size="15" class="text-outline" />
        </div>
      </div>

      <NuxtLink to="/profil/jadwal" class="flex items-center justify-between border-b border-outline-variant/30 py-3">
        <div class="flex items-center gap-2.5">
          <Clock :size="18" class="text-primary" :stroke-width="1.8" />
          <div class="flex flex-col">
            <span class="text-[13.5px] font-bold">Jam Praktik Kerja</span>
            <span class="text-[11.5px] text-outline">{{ activeDays.length }} hari aktif per minggu</span>
          </div>
        </div>
        <div class="flex items-center gap-1">
          <span class="text-[13px] font-bold text-primary">{{ hoursSummary }}</span>
          <ChevronRight :size="15" class="text-outline" />
        </div>
      </NuxtLink>

      <div class="flex items-center justify-between py-3">
        <div class="flex items-center gap-2.5">
          <Star :size="18" class="text-secondary" fill="currentColor" stroke="none" />
          <div class="flex flex-col">
            <span class="text-[13.5px] font-bold">Ulasan Pasien</span>
            <span class="text-[11.5px] text-outline">{{ user.rating }} dari {{ user.reviewCount }} ulasan</span>
          </div>
        </div>
        <ChevronRight :size="15" class="text-outline" />
      </div>
    </div>

    <!-- Emergency -->
    <a href="tel:+622129876543" class="flex items-center gap-3 rounded-2xl bg-error-container p-4">
      <div class="flex h-[38px] w-[38px] shrink-0 items-center justify-center rounded-full bg-error">
        <PhoneCall :size="18" class="text-on-error" :stroke-width="2" />
      </div>
      <div class="flex flex-1 flex-col">
        <span class="text-[13.5px] font-bold text-on-error-container">Bantuan Darurat Siaga 24 Jam</span>
        <span class="text-[11.5px] text-on-error-container">Hubungi tim keselamatan CareHome kapan saja</span>
      </div>
      <span class="whitespace-nowrap rounded-lg bg-error px-3.5 py-2 text-xs font-bold text-on-error">Hubungi</span>
    </a>

    <button
      type="button"
      class="flex h-12 items-center justify-center gap-2 rounded-2xl border border-outline-variant text-sm font-semibold text-on-surface-variant"
      @click="handleLogout"
    >
      <LogOut :size="17" :stroke-width="1.8" />
      Keluar
    </button>
  </div>
</template>
