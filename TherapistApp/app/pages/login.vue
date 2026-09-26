<script setup lang="ts">
import { Eye, EyeOff, Lock, Mail, ShieldCheck } from '@lucide/vue'

definePageMeta({ layout: 'blank' })

const { login } = useAuth()
const showPassword = ref(false)
const loading = ref(false)
const errorMessage = ref('')

const form = reactive({
  email: '',
  password: ''
})

async function submit() {
  if (loading.value) return
  errorMessage.value = ''
  loading.value = true
  try {
    const status = await login(form.email.trim(), form.password)
    await navigateTo(status === 'approved' ? '/order' : '/verifikasi')
  } catch (error) {
    errorMessage.value = error instanceof Error ? error.message : 'Gagal masuk'
  } finally {
    loading.value = false
  }
}

// Dev-only test accounts, seeded by docs/seed-test-users.sql (stripped from production builds)
const isDev = import.meta.dev
const testAccounts = import.meta.dev
  ? [
      { label: 'Approved', email: 'mitra.approved@ezyhomecare.test' },
      { label: 'Pending', email: 'mitra.pending@ezyhomecare.test' },
      { label: 'Rejected', email: 'mitra.rejected@ezyhomecare.test' },
      { label: 'Customer', email: 'customer@ezyhomecare.test' }
    ]
  : []

function loginAsTestAccount(email: string) {
  form.email = email
  form.password = import.meta.dev ? 'Test1234!' : ''
  submit()
}
</script>

<template>
  <div class="flex min-h-full flex-col">
    <div class="relative overflow-hidden bg-primary px-6 pb-10 pt-14">
      <div class="pointer-events-none absolute -right-10 -top-16 h-48 w-48 rounded-full bg-primary-container/40 blur-2xl" />
      <div class="pointer-events-none absolute -left-14 top-10 h-40 w-40 rounded-full bg-secondary-container/30 blur-2xl" />
      <div class="relative">
        <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/15">
          <ShieldCheck :size="22" class="text-on-primary" :stroke-width="2" />
        </div>
        <div class="mt-5 flex items-center gap-2">
          <h1 class="text-[26px] font-extrabold leading-tight text-on-primary">CareHome</h1>
          <span class="rounded-lg bg-on-primary/15 px-2 py-1 text-[11px] font-bold tracking-wide text-on-primary">MITRA</span>
        </div>
        <p class="mt-1 text-[14px] text-on-primary/80">Masuk sebagai mitra terapis untuk mengelola booking &amp; kunjungan.</p>
      </div>
    </div>

    <div class="relative -mt-5 flex-1 rounded-t-[2rem] bg-surface-container-lowest px-6 pb-10 pt-6">
      <form class="space-y-3.5" @submit.prevent="submit">
        <label class="flex items-center gap-3 rounded-2xl border border-outline-variant px-4 py-3.5">
          <Mail :size="18" class="text-outline" :stroke-width="1.75" />
          <input
            v-model="form.email"
            type="email"
            autocomplete="email"
            required
            placeholder="Email terdaftar"
            class="w-full bg-transparent text-[15px] text-on-surface outline-none placeholder:text-outline"
          >
        </label>

        <label class="flex items-center gap-3 rounded-2xl border border-outline-variant px-4 py-3.5">
          <Lock :size="18" class="text-outline" :stroke-width="1.75" />
          <input
            v-model="form.password"
            :type="showPassword ? 'text' : 'password'"
            autocomplete="current-password"
            required
            placeholder="Kata sandi"
            class="w-full bg-transparent text-[15px] text-on-surface outline-none placeholder:text-outline"
          >
          <button type="button" @click="showPassword = !showPassword">
            <component :is="showPassword ? EyeOff : Eye" :size="18" class="text-outline" :stroke-width="1.75" />
          </button>
        </label>

        <div class="text-right">
          <button type="button" class="text-[13px] font-semibold text-primary">Lupa kata sandi?</button>
        </div>

        <p v-if="errorMessage" class="rounded-xl bg-error-container px-4 py-3 text-[13px] font-medium text-on-error-container">
          {{ errorMessage }}
        </p>

        <button
          type="submit"
          :disabled="loading"
          class="mt-2 w-full rounded-2xl bg-primary py-3.5 text-[15px] font-bold text-on-primary shadow-[0_8px_20px_rgba(0,104,93,0.25)] transition-transform active:scale-[0.98] disabled:opacity-60"
        >
          {{ loading ? 'Memproses...' : 'Masuk' }}
        </button>
      </form>

      <p class="mt-6 text-center text-[13px] text-outline">
        Belum menjadi mitra?
        <NuxtLink to="/daftar" class="font-semibold text-primary">Daftar jadi mitra</NuxtLink>
      </p>

      <!-- <div v-if="isDev" class="mt-8 rounded-2xl border border-dashed border-outline-variant p-4">
        <p class="text-[11px] font-bold uppercase tracking-wide text-outline">Akun uji (dev only)</p>
        <div class="mt-3 grid grid-cols-2 gap-2">
          <button
            v-for="account in testAccounts"
            :key="account.email"
            type="button"
            :disabled="loading"
            class="rounded-xl bg-surface-container-low px-3 py-2 text-[12.5px] font-semibold text-on-surface-variant disabled:opacity-60"
            @click="loginAsTestAccount(account.email)"
          >
            {{ account.label }}
          </button>
        </div>
      </div> -->
    </div>
  </div>
</template>
