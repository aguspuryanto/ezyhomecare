<script setup lang="ts">
import { Eye, EyeOff, Lock, Mail, Phone, ShieldCheck, User } from '@lucide/vue'

definePageMeta({ showBottomNav: false })

const { login } = useAuth()
const router = useRouter()

const mode = ref<'masuk' | 'daftar'>('masuk')
const showPassword = ref(false)

const form = reactive({
  name: '',
  contact: '',
  password: ''
})

function submit() {
  login()
  router.push('/')
}
</script>

<template>
  <div class="flex min-h-full flex-col">
    <div class="relative overflow-hidden bg-primary-700 px-6 pb-10 pt-14">
      <div class="pointer-events-none absolute -right-10 -top-16 h-48 w-48 rounded-full bg-primary-500/40 blur-2xl" />
      <div class="pointer-events-none absolute -left-14 top-10 h-40 w-40 rounded-full bg-accent-500/30 blur-2xl" />
      <div class="relative">
        <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/15">
          <ShieldCheck :size="22" class="text-white" :stroke-width="2" />
        </div>
        <h1 class="mt-5 font-display text-[26px] font-extrabold leading-tight text-white">EzyHomeCare</h1>
        <p class="mt-1 text-[14px] text-primary-100">Perawatan &amp; terapi rumah tepercaya, datang ke pintu Anda.</p>
      </div>
    </div>

    <div class="flex-1 rounded-t-[2rem] bg-cream px-6 pb-10 pt-6 -mt-5 relative">
      <div class="mx-auto mb-6 flex max-w-[280px] rounded-pill bg-surface p-1 shadow-soft">
        <button
          type="button"
          class="flex-1 rounded-pill py-2 text-[13px] font-semibold transition-colors"
          :class="mode === 'masuk' ? 'bg-primary-600 text-white' : 'text-ink-soft'"
          @click="mode = 'masuk'"
        >
          Masuk
        </button>
        <button
          type="button"
          class="flex-1 rounded-pill py-2 text-[13px] font-semibold transition-colors"
          :class="mode === 'daftar' ? 'bg-primary-600 text-white' : 'text-ink-soft'"
          @click="mode = 'daftar'"
        >
          Daftar
        </button>
      </div>

      <form class="space-y-3.5" @submit.prevent="submit">
        <label v-if="mode === 'daftar'" class="flex items-center gap-3 rounded-2xl border border-line bg-surface px-4 py-3.5">
          <User :size="18" class="text-ink-soft" :stroke-width="1.75" />
          <input
            v-model="form.name"
            type="text"
            placeholder="Nama lengkap"
            class="w-full bg-transparent text-[15px] text-ink outline-none placeholder:text-ink-soft/70"
          >
        </label>

        <label class="flex items-center gap-3 rounded-2xl border border-line bg-surface px-4 py-3.5">
          <Mail v-if="mode === 'masuk'" :size="18" class="text-ink-soft" :stroke-width="1.75" />
          <Phone v-else :size="18" class="text-ink-soft" :stroke-width="1.75" />
          <input
            v-model="form.contact"
            type="text"
            :placeholder="mode === 'masuk' ? 'Email atau nomor HP' : 'Nomor HP aktif'"
            class="w-full bg-transparent text-[15px] text-ink outline-none placeholder:text-ink-soft/70"
          >
        </label>

        <label class="flex items-center gap-3 rounded-2xl border border-line bg-surface px-4 py-3.5">
          <Lock :size="18" class="text-ink-soft" :stroke-width="1.75" />
          <input
            v-model="form.password"
            :type="showPassword ? 'text' : 'password'"
            placeholder="Kata sandi"
            class="w-full bg-transparent text-[15px] text-ink outline-none placeholder:text-ink-soft/70"
          >
          <button type="button" @click="showPassword = !showPassword">
            <component :is="showPassword ? EyeOff : Eye" :size="18" class="text-ink-soft" :stroke-width="1.75" />
          </button>
        </label>

        <div v-if="mode === 'masuk'" class="text-right">
          <button type="button" class="text-[13px] font-semibold text-primary-600">Lupa kata sandi?</button>
        </div>

        <button
          type="submit"
          class="mt-2 w-full rounded-2xl bg-accent-500 py-3.5 text-[15px] font-bold text-white shadow-lift transition-transform active:scale-[0.98]"
        >
          {{ mode === 'masuk' ? 'Masuk' : 'Buat Akun' }}
        </button>
      </form>

      <div class="my-6 flex items-center gap-3">
        <div class="h-px flex-1 bg-line" />
        <span class="text-[12px] text-ink-soft">atau lanjutkan dengan</span>
        <div class="h-px flex-1 bg-line" />
      </div>

      <button
        type="button"
        class="flex w-full items-center justify-center gap-2 rounded-2xl border border-line bg-surface py-3 text-[14px] font-semibold text-ink"
        @click="submit"
      >
        Google
      </button>

      <p class="mt-6 text-center text-[13px] text-ink-soft">
        {{ mode === 'masuk' ? 'Belum punya akun?' : 'Sudah punya akun?' }}
        <button
          type="button"
          class="font-semibold text-primary-600"
          @click="mode = mode === 'masuk' ? 'daftar' : 'masuk'"
        >
          {{ mode === 'masuk' ? 'Daftar' : 'Masuk' }}
        </button>
      </p>
    </div>
  </div>
</template>
