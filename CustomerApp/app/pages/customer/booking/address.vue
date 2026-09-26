<script setup lang="ts">
import { Briefcase, Home, MapPin, Plus } from '@lucide/vue'
import type { Address } from '~/data/dummy'

definePageMeta({ showBottomNav: false })

const router = useRouter()
const { flow, addresses, addAddress } = useBookingFlow()

if (!flow.value.service) {
  navigateTo('/customer')
} else if (!flow.value.therapist) {
  navigateTo('/customer/booking/therapist')
} else if (!flow.value.time) {
  navigateTo('/customer/booking/schedule')
}

const labelIcon: Record<Address['label'], any> = {
  Rumah: Home,
  Kantor: Briefcase,
  Lainnya: MapPin
}

const selectedId = ref(flow.value.address?.id ?? addresses.value.find((a) => a.isDefault)?.id ?? addresses.value[0]?.id)
const showForm = ref(false)

const newAddress = reactive({
  recipient: '',
  phone: '',
  fullAddress: '',
  detail: ''
})

function saveNewAddress() {
  if (!newAddress.recipient || !newAddress.phone || !newAddress.fullAddress) return
  const address: Address = {
    id: `addr-${Date.now()}`,
    label: 'Lainnya',
    recipient: newAddress.recipient,
    phone: newAddress.phone,
    fullAddress: newAddress.fullAddress,
    detail: newAddress.detail,
    isDefault: false
  }
  addAddress(address)
  selectedId.value = address.id
  showForm.value = false
  newAddress.recipient = ''
  newAddress.phone = ''
  newAddress.fullAddress = ''
  newAddress.detail = ''
}

function continueToCheckout() {
  const address = addresses.value.find((a) => a.id === selectedId.value)
  if (!address) return
  flow.value.address = address
  router.push('/customer/booking/checkout')
}
</script>

<template>
  <div v-if="flow.service && flow.therapist && flow.time" class="pb-28">
    <TopBar title="Alamat Layanan" />
    <StepDots :step="3" />

    <div class="flex flex-col gap-3 px-5">
      <button
        v-for="address in addresses"
        :key="address.id"
        type="button"
        class="flex items-start gap-3 rounded-card border-2 bg-surface p-3.5 text-left transition-colors"
        :class="selectedId === address.id ? 'border-primary-500' : 'border-transparent shadow-soft'"
        @click="selectedId = address.id"
      >
        <span class="mt-0.5 flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-primary-50 text-primary-600">
          <component :is="labelIcon[address.label]" :size="17" :stroke-width="1.75" />
        </span>
        <div class="min-w-0 flex-1">
          <div class="flex items-center gap-2">
            <p class="text-[13px] font-bold text-ink">{{ address.label }}</p>
            <span v-if="address.isDefault" class="rounded-pill bg-primary-50 px-2 py-0.5 text-[10px] font-semibold text-primary-700">Utama</span>
          </div>
          <p class="mt-0.5 text-[12.5px] font-medium text-ink">{{ address.recipient }} &middot; {{ address.phone }}</p>
          <p class="mt-0.5 text-[12.5px] leading-snug text-ink-soft">{{ address.fullAddress }}</p>
        </div>
      </button>

      <button
        type="button"
        class="flex items-center justify-center gap-2 rounded-card border-2 border-dashed border-line py-3.5 text-[13px] font-semibold text-primary-600"
        @click="showForm = !showForm"
      >
        <Plus :size="16" :stroke-width="2" />
        Tambah Alamat Baru
      </button>

      <div v-if="showForm" class="flex flex-col gap-2.5 rounded-card bg-surface p-4 shadow-soft">
        <input v-model="newAddress.recipient" type="text" placeholder="Nama penerima" class="rounded-xl border border-line px-3.5 py-2.5 text-[13.5px] outline-none placeholder:text-ink-soft/70">
        <input v-model="newAddress.phone" type="text" placeholder="Nomor HP" class="rounded-xl border border-line px-3.5 py-2.5 text-[13.5px] outline-none placeholder:text-ink-soft/70">
        <textarea v-model="newAddress.fullAddress" rows="2" placeholder="Alamat lengkap" class="rounded-xl border border-line px-3.5 py-2.5 text-[13.5px] outline-none placeholder:text-ink-soft/70" />
        <input v-model="newAddress.detail" type="text" placeholder="Detail (patokan, warna pagar, dll)" class="rounded-xl border border-line px-3.5 py-2.5 text-[13.5px] outline-none placeholder:text-ink-soft/70">
        <button type="button" class="mt-1 rounded-xl bg-primary-600 py-2.5 text-[13px] font-bold text-white" @click="saveNewAddress">
          Simpan Alamat
        </button>
      </div>
    </div>

    <div class="fixed inset-x-0 bottom-0 z-20 mx-auto w-full max-w-[440px] border-t border-line bg-surface px-5 py-4">
      <button
        type="button"
        class="w-full rounded-2xl py-3.5 text-[14px] font-bold text-white shadow-lift transition-transform active:scale-[0.98] disabled:opacity-40"
        :class="selectedId ? 'bg-accent-500' : 'bg-ink-soft'"
        :disabled="!selectedId"
        @click="continueToCheckout"
      >
        Lanjutkan
      </button>
    </div>
  </div>
</template>
