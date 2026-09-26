<script setup lang="ts">
import { BadgeCheck, Eye, EyeOff, Lock, Mail, MapPin, Phone, UserRound, UserPlus } from '@lucide/vue'

definePageMeta({ layout: 'blank' })

const { register } = useAuth()
const showPassword = ref(false)
const loading = ref(false)
const errorMessage = ref('')
const confirmEmailSent = ref(false)

const form = reactive({
  fullName: '',
  phone: '',
  email: '',
  password: '',
  licenseNo: '',
  area: ''
})

function validate(): string | null {
  if (form.fullName.trim().length < 3) return 'Nama lengkap minimal 3 karakter'
  if (!/^(\+62|62|0)8\d{7,12}$/.test(form.phone.replace(/[\s-]/g, ''))) return 'Nomor HP tidak valid (contoh: 081234567890)'
  if (!/^\S+@\S+\.\S+$/.test(form.email.trim())) return 'Email tidak valid'
  if (form.password.length < 8) return 'Kata sandi minimal 8 karakter'
  if (!form.licenseNo.trim()) return 'Nomor SIP wajib diisi'
  if (!form.area.trim()) return 'Area layanan wajib diisi'
  return null
}

async function submit() {
  if (loading.value) return
  errorMessage.value = validate() ?? ''
  if (errorMessage.value) return

  loading.value = true
  try {
    const { needsEmailConfirm } = await register({
      fullName: form.fullName.trim(),
      phone: form.phone.replace(/[\s-]/g, ''),
      email: form.email.trim(),
      password: form.password,
      licenseNo: form.licenseNo.trim(),
      area: form.area.trim()
    })
    if (needsEmailConfirm) {
      confirmEmailSent.value = true
    } else {
      await navigateTo('/verifikasi')
    }
  } catch (error) {
    errorMessage.value = error instanceof Error ? error.message : 'Gagal mendaftar'
  } finally {
    loading.value = false
  }
}

const fields = [
  { key: 'fullName', icon: UserRound, type: 'text', placeholder: 'Nama lengkap sesuai KTP', autocomplete: 'name' },
  { key: 'phone', icon: Phone, type: 'tel', placeholder: 'Nomor HP aktif', autocomplete: 'tel' },
  { key: 'email', icon: Mail, type: 'email', placeholder: 'Email', autocomplete: 'email' },
  { key: 'licenseNo', icon: BadgeCheck, type: 'text', placeholder: 'Nomor SIP / STR', autocomplete: 'off' },
  { key: 'area', icon: MapPin, type: 'text', placeholder: 'Area layanan (mis. Surabaya Timur)', autocomplete: 'address-level2' }
] as const
</script>

<template>
  <div class="flex min-h-full flex-col">
    <div class="relative overflow-hidden bg-primary px-6 pb-10 pt-14">
      <div class="pointer-events-none absolute -right-10 -top-16 h-48 w-48 rounded-full bg-primary-container/40 blur-2xl" />
      <div class="pointer-events-none absolute -left-14 top-10 h-40 w-40 rounded-full bg-secondary-container/30 blur-2xl" />
      <div class="relative">
        <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/15">
          <UserPlus :size="22" class="text-on-primary" :stroke-width="2" />
        </div>
        <div class="mt-5 flex items-center gap-2">
          <h1 class="text-[26px] font-extrabold leading-tight text-on-primary">Daftar Mitra</h1>
          <span class="rounded-lg bg-on-primary/15 px-2 py-1 text-[11px] font-bold tracking-wide text-on-primary">MITRA</span>
        </div>
        <p class="mt-1 text-[14px] text-on-primary/80">Isi data diri Anda. Tim kami akan memverifikasi akun sebelum Anda bisa menerima booking.</p>
      </div>
    </div>

    <div class="relative -mt-5 flex-1 rounded-t-[2rem] bg-surface-container-lowest px-6 pb-10 pt-6">
      <div v-if="confirmEmailSent" class="space-y-4 text-center">
        <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-primary-container/20">
          <Mail :size="26" class="text-primary" :stroke-width="1.8" />
        </div>
        <h2 class="text-lg font-bold">Cek email Anda</h2>
        <p class="text-[14px] text-on-surface-variant">
          Kami mengirim link konfirmasi ke <span class="font-semibold">{{ form.email }}</span>. Setelah dikonfirmasi, silakan masuk.
        </p>
        <NuxtLink
          to="/login"
          class="block w-full rounded-2xl bg-primary py-3.5 text-[15px] font-bold text-on-primary"
        >
          Ke Halaman Masuk
        </NuxtLink>
      </div>

      <form v-else class="space-y-3.5" novalidate @submit.prevent="submit">
        <label
          v-for="field in fields"
          :key="field.key"
          class="flex items-center gap-3 rounded-2xl border border-outline-variant px-4 py-3.5"
        >
          <component :is="field.icon" :size="18" class="text-outline" :stroke-width="1.75" />
          <input
            v-model="form[field.key]"
            :type="field.type"
            :autocomplete="field.autocomplete"
            :placeholder="field.placeholder"
            class="w-full bg-transparent text-[15px] text-on-surface outline-none placeholder:text-outline"
          >
        </label>

        <label class="flex items-center gap-3 rounded-2xl border border-outline-variant px-4 py-3.5">
          <Lock :size="18" class="text-outline" :stroke-width="1.75" />
          <input
            v-model="form.password"
            :type="showPassword ? 'text' : 'password'"
            autocomplete="new-password"
            placeholder="Kata sandi (min. 8 karakter)"
            class="w-full bg-transparent text-[15px] text-on-surface outline-none placeholder:text-outline"
          >
          <button type="button" @click="showPassword = !showPassword">
            <component :is="showPassword ? EyeOff : Eye" :size="18" class="text-outline" :stroke-width="1.75" />
          </button>
        </label>

        <p v-if="errorMessage" class="rounded-xl bg-error-container px-4 py-3 text-[13px] font-medium text-on-error-container">
          {{ errorMessage }}
        </p>

        <button
          type="submit"
          :disabled="loading"
          class="mt-2 w-full rounded-2xl bg-primary py-3.5 text-[15px] font-bold text-on-primary shadow-[0_8px_20px_rgba(0,104,93,0.25)] transition-transform active:scale-[0.98] disabled:opacity-60"
        >
          {{ loading ? 'Memproses...' : 'Daftar' }}
        </button>
      </form>

      <p v-if="!confirmEmailSent" class="mt-6 text-center text-[13px] text-outline">
        Sudah punya akun?
        <NuxtLink to="/login" class="font-semibold text-primary">Masuk</NuxtLink>
      </p>
    </div>
  </div>
</template>
