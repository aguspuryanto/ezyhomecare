<script setup lang="ts">
import { Calendar, Check, MapPin, User } from '@lucide/vue'
import { formatIDR } from '~/data/dummy'

definePageMeta({ showBottomNav: false })

const router = useRouter()
const { flow, history, resetFlow } = useBookingFlow()

if (!flow.value.bookingId) {
  navigateTo('/customer')
}

const total = computed(() => history.value.find((h) => h.id === flow.value.bookingId)?.price)

function goHome() {
  resetFlow()
  router.push('/customer')
}

function trackBooking() {
  router.push(`/customer/booking/track/${flow.value.bookingId}`)
}
</script>

<template>
  <div v-if="flow.service && flow.bookingId" class="flex min-h-full flex-col px-6 pb-8 pt-16">
    <div class="flex flex-col items-center text-center">
      <div class="success-pop flex h-20 w-20 items-center justify-center rounded-full bg-primary-500 text-white">
        <Check :size="38" :stroke-width="3" />
      </div>
      <h1 class="mt-6 font-display text-[21px] font-extrabold text-ink">Pembayaran Berhasil!</h1>
      <p class="mt-1.5 text-[13.5px] text-ink-soft">Pesanan Anda telah dikonfirmasi</p>
      <p class="mt-3 rounded-pill bg-primary-50 px-4 py-1.5 text-[12.5px] font-semibold text-primary-700">{{ flow.bookingId }}</p>
    </div>

    <div class="mt-8 rounded-card bg-surface p-4 shadow-soft">
      <div class="flex gap-3">
        <ServiceVisual :category-id="flow.service.categoryId" :size="20" class="h-14 w-14 rounded-xl" />
        <div>
          <p class="text-[13.5px] font-bold text-ink">{{ flow.service.name }}</p>
          <p class="text-[12px] text-ink-soft">{{ flow.therapist?.name }}</p>
        </div>
      </div>
      <div class="mt-3 space-y-2 border-t border-line pt-3 text-[12.5px] text-ink-soft">
        <p class="flex items-center gap-2"><Calendar :size="14" />{{ flow.dateLabel }} &middot; {{ flow.time }}</p>
        <p class="flex items-center gap-2"><MapPin :size="14" />{{ flow.address?.fullAddress }}</p>
        <p class="flex items-center gap-2"><User :size="14" />Dibayar dengan {{ flow.payment?.name }}</p>
      </div>
      <div class="mt-3 flex justify-between border-t border-line pt-3 font-display text-[15px] font-extrabold text-ink">
        <span>Total Dibayar</span>
        <span>{{ formatIDR(total ?? 0) }}</span>
      </div>
    </div>

    <div class="mt-auto flex flex-col gap-3 pt-8">
      <button
        type="button"
        class="w-full rounded-2xl bg-accent-500 py-3.5 text-[14px] font-bold text-white shadow-lift transition-transform active:scale-[0.98]"
        @click="trackBooking"
      >
        Lacak Pesanan
      </button>
      <button type="button" class="w-full py-2 text-[13.5px] font-semibold text-ink-soft" @click="goHome">
        Kembali ke Beranda
      </button>
    </div>
  </div>
</template>

<style scoped>
.success-pop {
  animation: pop 420ms cubic-bezier(0.34, 1.56, 0.64, 1);
}
@keyframes pop {
  0% { transform: scale(0.4); opacity: 0; }
  100% { transform: scale(1); opacity: 1; }
}
@media (prefers-reduced-motion: reduce) {
  .success-pop { animation: none; }
}
</style>
