<script setup lang="ts">
import { Ban, Hourglass, LogOut, RefreshCw, ShieldX } from '@lucide/vue'

definePageMeta({ layout: 'blank' })

const { user, verificationStatus, loadProfile, logout } = useAuth()
const checking = ref(false)
const errorMessage = ref('')

const content = computed(() => {
  switch (verificationStatus.value) {
    case 'rejected':
      return {
        icon: ShieldX,
        title: 'Pendaftaran ditolak',
        body: user.value.rejectionReason || 'Data pendaftaran belum memenuhi syarat. Hubungi Tim Kemitraan untuk informasi lebih lanjut.'
      }
    case 'suspended':
      return {
        icon: Ban,
        title: 'Akun ditangguhkan',
        body: 'Akun mitra Anda sedang ditangguhkan. Hubungi Tim Kemitraan untuk mengaktifkan kembali.'
      }
    default:
      return {
        icon: Hourglass,
        title: 'Akun sedang ditinjau',
        body: 'Terima kasih sudah mendaftar. Tim kami sedang memverifikasi data Anda. Anda akan bisa menerima booking setelah akun disetujui.'
      }
  }
})

async function checkAgain() {
  if (checking.value) return
  errorMessage.value = ''
  checking.value = true
  try {
    await loadProfile()
    if (verificationStatus.value === 'approved') await navigateTo('/order')
  } catch (error) {
    errorMessage.value = error instanceof Error ? error.message : 'Gagal memuat status'
  } finally {
    checking.value = false
  }
}

async function handleLogout() {
  await logout()
  await navigateTo('/login')
}
</script>

<template>
  <div class="flex min-h-full flex-col items-center justify-center gap-5 px-6 py-10 text-center">
    <div class="flex h-16 w-16 items-center justify-center rounded-full bg-primary-container/20">
      <component :is="content.icon" :size="30" class="text-primary" :stroke-width="1.8" />
    </div>

    <div class="space-y-2">
      <p v-if="user.name" class="text-[13px] font-semibold text-outline">Halo, {{ user.name }}</p>
      <h1 class="text-[22px] font-extrabold">{{ content.title }}</h1>
      <p class="text-[14px] text-on-surface-variant">{{ content.body }}</p>
    </div>

    <p v-if="errorMessage" class="w-full rounded-xl bg-error-container px-4 py-3 text-[13px] font-medium text-on-error-container">
      {{ errorMessage }}
    </p>

    <div class="flex w-full flex-col gap-3">
      <button
        type="button"
        :disabled="checking"
        class="flex w-full items-center justify-center gap-2 rounded-2xl bg-primary py-3.5 text-[15px] font-bold text-on-primary disabled:opacity-60"
        @click="checkAgain"
      >
        <RefreshCw :size="17" :stroke-width="2" :class="{ 'animate-spin': checking }" />
        Cek status lagi
      </button>
      <button
        type="button"
        class="flex h-12 items-center justify-center gap-2 rounded-2xl border border-outline-variant text-sm font-semibold text-on-surface-variant"
        @click="handleLogout"
      >
        <LogOut :size="17" :stroke-width="1.8" />
        Keluar
      </button>
    </div>
  </div>
</template>
