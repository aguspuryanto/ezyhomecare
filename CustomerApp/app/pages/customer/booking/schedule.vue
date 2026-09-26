<script setup lang="ts">
definePageMeta({ showBottomNav: false })

const router = useRouter()
const { flow } = useBookingFlow()

if (!flow.value.service) {
  navigateTo('/customer')
} else if (!flow.value.therapist) {
  navigateTo('/customer/booking/therapist')
}

const days = Array.from({ length: 7 }, (_, i) => {
  const d = new Date(2026, 8, 1 + i) // 1 Sep 2026 onward
  return {
    iso: d.toISOString().slice(0, 10),
    weekday: d.toLocaleDateString('id-ID', { weekday: 'short' }),
    day: d.getDate(),
    label: d.toLocaleDateString('id-ID', { day: '2-digit', month: 'long', year: 'numeric' })
  }
})

const timeSlots = [
  { time: '08:00', period: 'Pagi', disabled: false },
  { time: '09:30', period: 'Pagi', disabled: false },
  { time: '11:00', period: 'Pagi', disabled: true },
  { time: '13:00', period: 'Siang', disabled: false },
  { time: '14:30', period: 'Siang', disabled: true },
  { time: '16:00', period: 'Siang', disabled: false },
  { time: '17:30', period: 'Malam', disabled: false },
  { time: '19:00', period: 'Malam', disabled: false }
]

const selectedDate = ref(flow.value.date ?? days[0].iso)
const selectedTime = ref(flow.value.time)
const notes = ref(flow.value.notes)

function continueToAddress() {
  if (!selectedTime.value) return
  const day = days.find((d) => d.iso === selectedDate.value)!
  flow.value.date = selectedDate.value
  flow.value.dateLabel = day.label
  flow.value.time = selectedTime.value
  flow.value.notes = notes.value
  router.push('/customer/booking/address')
}
</script>

<template>
  <div v-if="flow.service && flow.therapist" class="pb-28">
    <TopBar title="Pilih Jadwal" />
    <StepDots :step="2" />

    <div class="px-5">
      <h2 class="font-display text-[13px] font-bold text-ink">Pilih Tanggal</h2>
      <div class="mt-3 flex gap-2.5 overflow-x-auto pb-1">
        <button
          v-for="day in days"
          :key="day.iso"
          type="button"
          class="flex w-14 shrink-0 flex-col items-center gap-1 rounded-2xl py-2.5 transition-colors"
          :class="selectedDate === day.iso ? 'bg-primary-600 text-white' : 'bg-surface text-ink shadow-soft'"
          @click="selectedDate = day.iso"
        >
          <span class="text-[11px] font-medium capitalize" :class="selectedDate === day.iso ? 'text-primary-100' : 'text-ink-soft'">
            {{ day.weekday }}
          </span>
          <span class="font-display text-[15px] font-bold">{{ day.day }}</span>
        </button>
      </div>
    </div>

    <div class="mt-5 px-5">
      <h2 class="font-display text-[13px] font-bold text-ink">Pilih Waktu</h2>
      <div class="mt-3 grid grid-cols-3 gap-2.5">
        <button
          v-for="slot in timeSlots"
          :key="slot.time"
          type="button"
          :disabled="slot.disabled"
          class="rounded-2xl py-2.5 text-[13px] font-semibold transition-colors disabled:cursor-not-allowed disabled:bg-cream-soft disabled:text-ink-soft/50"
          :class="!slot.disabled && (selectedTime === slot.time ? 'bg-primary-600 text-white' : 'bg-surface text-ink shadow-soft')"
          @click="selectedTime = slot.time"
        >
          {{ slot.time }}
        </button>
      </div>
      <p class="mt-2 text-[11px] text-ink-soft">Slot berwarna abu menandakan sudah penuh dipesan.</p>
    </div>

    <div class="mt-5 px-5">
      <h2 class="font-display text-[13px] font-bold text-ink">Catatan untuk Terapis (opsional)</h2>
      <textarea
        v-model="notes"
        rows="3"
        placeholder="Contoh: fokus pada area punggung dan leher"
        class="mt-3 w-full rounded-2xl border border-line bg-surface p-3.5 text-[13.5px] text-ink outline-none placeholder:text-ink-soft/70"
      />
    </div>

    <div class="fixed inset-x-0 bottom-0 z-20 mx-auto w-full max-w-[440px] border-t border-line bg-surface px-5 py-4">
      <button
        type="button"
        class="w-full rounded-2xl py-3.5 text-[14px] font-bold text-white shadow-lift transition-transform active:scale-[0.98] disabled:opacity-40"
        :class="selectedTime ? 'bg-accent-500' : 'bg-ink-soft'"
        :disabled="!selectedTime"
        @click="continueToAddress"
      >
        Lanjutkan
      </button>
    </div>
  </div>
</template>
