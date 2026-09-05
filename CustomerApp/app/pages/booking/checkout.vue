<script setup lang="ts">
import { CreditCard, Loader2, Smartphone, Tag, Wallet } from '@lucide/vue'
import { formatIDR, paymentMethods, promoCodes } from '~/data/dummy'

definePageMeta({ showBottomNav: false })

const router = useRouter()
const { flow, addHistoryEntry } = useBookingFlow()

if (!flow.value.service) {
  navigateTo('/')
} else if (!flow.value.therapist) {
  navigateTo('/booking/terapis')
} else if (!flow.value.time) {
  navigateTo('/booking/jadwal')
} else if (!flow.value.address) {
  navigateTo('/booking/alamat')
}

const paymentIcons: Record<string, any> = {
  qris: Smartphone,
  ewallet: Wallet,
  card: CreditCard,
  cash: Tag
}

const selectedPaymentId = ref(flow.value.payment?.id ?? paymentMethods[0].id)
const promoInput = ref(flow.value.promoCode ?? '')
const promoError = ref('')
const isProcessing = ref(false)

const subtotal = computed(() => flow.value.service?.price ?? 0)
const serviceFee = 5000
const discount = computed(() => Math.round(subtotal.value * flow.value.promoDiscount))
const total = computed(() => subtotal.value + serviceFee - discount.value)

function applyPromo() {
  const code = promoInput.value.trim().toUpperCase()
  const found = promoCodes[code]
  if (!found) {
    promoError.value = 'Kode promo tidak ditemukan'
    flow.value.promoCode = null
    flow.value.promoDiscount = 0
    return
  }
  promoError.value = ''
  flow.value.promoCode = code
  flow.value.promoDiscount = found.discount
}

function pay() {
  const method = paymentMethods.find((p) => p.id === selectedPaymentId.value) ?? null
  flow.value.payment = method
  isProcessing.value = true
  setTimeout(() => {
    const bookingId = `EHC-${Date.now().toString().slice(-8)}`
    flow.value.bookingId = bookingId
    if (flow.value.service && flow.value.therapist) {
      addHistoryEntry({
        id: bookingId,
        serviceName: flow.value.service.name,
        therapistName: flow.value.therapist.name,
        date: flow.value.dateLabel ?? '',
        time: flow.value.time ?? '',
        status: 'berlangsung',
        price: total.value
      })
    }
    router.push('/booking/sukses')
  }, 1100)
}
</script>

<template>
  <div v-if="flow.service && flow.therapist && flow.time && flow.address" class="pb-32">
    <TopBar title="Checkout" />
    <StepDots :step="4" />

    <div class="flex flex-col gap-3 px-5">
      <div class="rounded-card bg-surface p-4 shadow-soft">
        <div class="flex items-center justify-between">
          <h3 class="font-display text-[13px] font-bold text-ink">Ringkasan Layanan</h3>
          <NuxtLink :to="`/layanan/${flow.service.id}`" class="text-[12px] font-semibold text-primary-600">Ubah</NuxtLink>
        </div>
        <div class="mt-3 flex gap-3">
          <ServiceVisual :category-id="flow.service.categoryId" :size="20" class="h-14 w-14 rounded-xl" />
          <div>
            <p class="text-[13px] font-bold text-ink">{{ flow.service.name }}</p>
            <p class="text-[12px] text-ink-soft">{{ flow.therapist.name }} &middot; {{ flow.service.duration }} menit</p>
          </div>
        </div>
      </div>

      <div class="rounded-card bg-surface p-4 shadow-soft">
        <div class="flex items-center justify-between">
          <h3 class="font-display text-[13px] font-bold text-ink">Jadwal</h3>
          <NuxtLink to="/booking/jadwal" class="text-[12px] font-semibold text-primary-600">Ubah</NuxtLink>
        </div>
        <p class="mt-2 text-[13px] text-ink">{{ flow.dateLabel }} &middot; {{ flow.time }}</p>
      </div>

      <div class="rounded-card bg-surface p-4 shadow-soft">
        <div class="flex items-center justify-between">
          <h3 class="font-display text-[13px] font-bold text-ink">Alamat</h3>
          <NuxtLink to="/booking/alamat" class="text-[12px] font-semibold text-primary-600">Ubah</NuxtLink>
        </div>
        <p class="mt-2 text-[13px] font-medium text-ink">{{ flow.address.label }} &middot; {{ flow.address.recipient }}</p>
        <p class="text-[12.5px] text-ink-soft">{{ flow.address.fullAddress }}</p>
      </div>

      <div class="rounded-card bg-surface p-4 shadow-soft">
        <h3 class="font-display text-[13px] font-bold text-ink">Metode Pembayaran</h3>
        <div class="mt-3 flex flex-col gap-2">
          <label
            v-for="method in paymentMethods"
            :key="method.id"
            class="flex cursor-pointer items-center gap-3 rounded-2xl border-2 px-3.5 py-3 transition-colors"
            :class="selectedPaymentId === method.id ? 'border-primary-500' : 'border-line'"
          >
            <input v-model="selectedPaymentId" type="radio" :value="method.id" class="hidden">
            <span class="flex h-9 w-9 items-center justify-center rounded-full bg-primary-50 text-primary-600">
              <component :is="paymentIcons[method.type]" :size="16" :stroke-width="1.75" />
            </span>
            <div>
              <p class="text-[13px] font-semibold text-ink">{{ method.name }}</p>
              <p class="text-[11.5px] text-ink-soft">{{ method.subtitle }}</p>
            </div>
          </label>
        </div>
      </div>

      <div class="rounded-card bg-surface p-4 shadow-soft">
        <h3 class="font-display text-[13px] font-bold text-ink">Kode Promo</h3>
        <div class="mt-3 flex gap-2">
          <input
            v-model="promoInput"
            type="text"
            placeholder="Masukkan kode promo"
            class="w-full rounded-xl border border-line px-3.5 py-2.5 text-[13px] uppercase outline-none placeholder:normal-case placeholder:text-ink-soft/70"
          >
          <button type="button" class="shrink-0 rounded-xl bg-primary-600 px-4 text-[13px] font-bold text-white" @click="applyPromo">
            Pakai
          </button>
        </div>
        <p v-if="promoError" class="mt-1.5 text-[11.5px] text-danger-600">{{ promoError }}</p>
        <p v-else-if="flow.promoCode" class="mt-1.5 text-[11.5px] font-semibold text-primary-600">
          Kode {{ flow.promoCode }} diterapkan
        </p>
      </div>

      <div class="rounded-card bg-surface p-4 shadow-soft">
        <h3 class="font-display text-[13px] font-bold text-ink">Rincian Biaya</h3>
        <div class="mt-3 space-y-2 text-[13px]">
          <div class="flex justify-between text-ink-soft"><span>Subtotal</span><span>{{ formatIDR(subtotal) }}</span></div>
          <div class="flex justify-between text-ink-soft"><span>Biaya Layanan</span><span>{{ formatIDR(serviceFee) }}</span></div>
          <div v-if="discount > 0" class="flex justify-between text-primary-600"><span>Diskon</span><span>-{{ formatIDR(discount) }}</span></div>
          <div class="my-1 h-px bg-line" />
          <div class="flex justify-between font-display text-[15px] font-extrabold text-ink"><span>Total</span><span>{{ formatIDR(total) }}</span></div>
        </div>
      </div>
    </div>

    <div class="fixed inset-x-0 bottom-0 z-20 mx-auto w-full max-w-[440px] border-t border-line bg-surface px-5 py-4">
      <button
        type="button"
        class="flex w-full items-center justify-center gap-2 rounded-2xl bg-accent-500 py-3.5 text-[14px] font-bold text-white shadow-lift transition-transform active:scale-[0.98] disabled:opacity-70"
        :disabled="isProcessing"
        @click="pay"
      >
        <Loader2 v-if="isProcessing" :size="17" class="animate-spin" />
        {{ isProcessing ? 'Memproses Pembayaran...' : `Bayar ${formatIDR(total)}` }}
      </button>
    </div>
  </div>
</template>
