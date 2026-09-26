<script setup lang="ts">
import { Check, MessageCircle, Navigation, Phone } from '@lucide/vue'

definePageMeta({ showBottomNav: false })

const route = useRoute()
const router = useRouter()
const { flow, history } = useBookingFlow()

const entry = computed(() => history.value.find((h) => h.id === route.params.id))

if (!entry.value || entry.value.status !== 'berlangsung' || flow.value.bookingId !== route.params.id) {
  navigateTo('/customer/bookings')
}

const steps = [
  { label: 'Pesanan Dikonfirmasi', time: '13:58', done: true },
  { label: 'Terapis Menuju Lokasi', time: '14:05', done: true, active: true },
  { label: 'Layanan Dimulai', time: '-', done: false },
  { label: 'Layanan Selesai', time: '-', done: false }
]
</script>

<template>
  <div v-if="flow.service && flow.therapist && flow.address" class="pb-8">
    <TopBar title="Lacak Pesanan" />

    <div class="mx-5 overflow-hidden rounded-card bg-primary-700">
      <div class="relative flex h-36 items-center justify-between px-8">
        <div class="pointer-events-none absolute inset-6 border-t-2 border-dashed border-primary-300/50" />
        <span class="relative flex h-9 w-9 items-center justify-center rounded-full bg-white text-primary-700 shadow-lift">
          <Navigation :size="16" :stroke-width="2" />
        </span>
        <span class="relative flex h-9 w-9 items-center justify-center rounded-full bg-accent-500 text-white shadow-lift">
          <Check :size="16" :stroke-width="2" />
        </span>
      </div>
      <div class="bg-primary-900/40 px-4 py-2.5 text-center text-[12px] font-semibold text-white">
        Estimasi tiba 15 menit lagi
      </div>
    </div>

    <div class="mx-5 mt-4 flex items-center gap-3 rounded-card bg-surface p-3.5 shadow-soft">
      <img :src="flow.therapist.photo" :alt="flow.therapist.name" class="h-12 w-12 rounded-full object-cover">
      <div class="min-w-0 flex-1">
        <p class="truncate text-[13.5px] font-bold text-ink">{{ flow.therapist.name }}</p>
        <p class="text-[11.5px] text-ink-soft">Terapis Anda</p>
      </div>
      <button type="button" class="flex h-9 w-9 items-center justify-center rounded-full bg-primary-50 text-primary-600">
        <Phone :size="16" :stroke-width="1.75" />
      </button>
      <button type="button" class="flex h-9 w-9 items-center justify-center rounded-full bg-primary-50 text-primary-600">
        <MessageCircle :size="16" :stroke-width="1.75" />
      </button>
    </div>

    <div class="mx-5 mt-4 rounded-card bg-surface p-4 shadow-soft">
      <h3 class="font-display text-[13px] font-bold text-ink">Status Pesanan</h3>
      <ol class="mt-3">
        <li v-for="(step, index) in steps" :key="step.label" class="relative flex gap-3 pb-6 last:pb-0">
          <div class="flex flex-col items-center">
            <span
              class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full"
              :class="step.done ? 'bg-primary-500 text-white' : 'bg-line text-ink-soft'"
            >
              <Check v-if="step.done" :size="12" :stroke-width="3" />
            </span>
            <span v-if="index < steps.length - 1" class="mt-1 w-px flex-1" :class="step.done ? 'bg-primary-500' : 'bg-line'" />
          </div>
          <div class="pt-0.5">
            <p class="text-[13px] font-semibold" :class="step.active ? 'text-primary-600' : 'text-ink'">{{ step.label }}</p>
            <p class="text-[11.5px] text-ink-soft">{{ step.time }}</p>
          </div>
        </li>
      </ol>
    </div>

    <div class="mx-5 mt-4 rounded-card bg-surface p-4 shadow-soft">
      <h3 class="font-display text-[13px] font-bold text-ink">Detail Pesanan</h3>
      <div class="mt-2.5 space-y-1.5 text-[12.5px] text-ink-soft">
        <p>{{ flow.service.name }} &middot; {{ flow.dateLabel }} {{ flow.time }}</p>
        <p>{{ flow.address.fullAddress }}</p>
      </div>
      <button type="button" class="mt-3 text-[12.5px] font-semibold text-primary-600">Butuh Bantuan?</button>
    </div>
  </div>
</template>
