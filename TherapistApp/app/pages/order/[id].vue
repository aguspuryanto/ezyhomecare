<script setup lang="ts">
import { ArrowLeft, CheckCircle2, ChevronLeft, Clock, MapPin, Navigation, Phone, Star, XCircle } from '@lucide/vue'
import { formatIDR } from '~/data/dummy'

definePageMeta({ layout: 'blank' })

const route = useRoute()
const id = route.params.id as string

const { getById, advanceStatus, nextStatusLabel, completeWithNotes } = useBookings()
const booking = getById(id)

const notes = ref('')
const isFinalStep = computed(() => booking.value?.status === 'berlangsung')

function mapsUrl(address: string) {
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(address)}`
}

function handlePrimaryAction() {
  if (!booking.value) return
  if (isFinalStep.value) {
    completeWithNotes(booking.value.id, notes.value)
  } else {
    advanceStatus(booking.value.id)
  }
}

const statusLabel: Record<string, string> = {
  terkonfirmasi: 'Terkonfirmasi',
  menuju_lokasi: 'Menuju Lokasi',
  tiba_lokasi: 'Tiba di Lokasi',
  berlangsung: 'Sedang Berlangsung',
  selesai: 'Selesai',
  dibatalkan: 'Dibatalkan'
}
</script>

<template>
  <div v-if="booking" class="flex flex-1 flex-col">
    <div class="flex items-center gap-3 px-5 pb-3 pt-[18px]">
      <button type="button" class="flex h-9 w-9 items-center justify-center rounded-full border border-outline-variant/60" @click="$router.back()">
        <ChevronLeft :size="18" />
      </button>
      <div class="flex flex-col">
        <span class="text-[17px] font-bold">Detail Booking</span>
        <span class="text-xs text-outline">#{{ booking.id }}</span>
      </div>
    </div>

    <div class="flex flex-1 flex-col gap-4 overflow-y-auto px-5 pb-8">
      <span
        class="w-fit rounded-lg px-2.5 py-1 text-xs font-bold"
        :class="{
          'bg-primary-container/15 text-primary': ['terkonfirmasi', 'selesai'].includes(booking.status),
          'bg-secondary-container/20 text-secondary': ['menuju_lokasi', 'tiba_lokasi', 'berlangsung'].includes(booking.status),
          'bg-error-container text-on-error-container': booking.status === 'dibatalkan'
        }"
      >
        {{ statusLabel[booking.status] }}
      </span>

      <!-- Customer detail -->
      <div class="flex flex-col gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <span class="text-[13px] font-bold text-on-surface-variant">Detail Pasien</span>
        <div class="flex items-center gap-3">
          <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-full bg-primary-container text-sm font-bold text-on-primary-container">
            {{ booking.customerName.split(' ').map(w => w[0]).slice(0, 2).join('') }}
          </div>
          <div class="flex flex-1 flex-col gap-0.5">
            <span class="text-[15px] font-bold">{{ booking.customerName }}</span>
            <span class="text-xs text-outline">
              {{ booking.isRegular ? `Pasien Reguler (Order ke-${booking.orderCount})` : 'Pasien Baru' }}
            </span>
          </div>
          <a v-if="booking.status !== 'selesai' && booking.status !== 'dibatalkan'" :href="`tel:${booking.customerPhone}`" class="flex h-9 w-9 items-center justify-center rounded-full bg-primary text-on-primary">
            <Phone :size="16" />
          </a>
        </div>
        <div class="flex items-center justify-between gap-2 rounded-xl bg-surface-container-low px-3 py-2.5">
          <div class="flex items-center gap-1.5 text-on-surface-variant">
            <MapPin :size="14" :stroke-width="1.8" />
            <span class="text-[12.5px]">{{ booking.address }}</span>
          </div>
          <a
            v-if="booking.status !== 'selesai' && booking.status !== 'dibatalkan'"
            :href="mapsUrl(booking.address)"
            target="_blank"
            rel="noopener"
            class="flex shrink-0 items-center gap-1 text-xs font-semibold text-primary"
          >
            <Navigation :size="13" />
            Navigasi
          </a>
        </div>
        <div v-if="booking.customerNote" class="rounded-lg bg-surface-container-low px-3 py-2 text-xs text-on-surface-variant">
          {{ booking.customerNote }}
        </div>
      </div>

      <!-- Service detail -->
      <div class="flex flex-col gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <span class="text-[13px] font-bold text-on-surface-variant">Detail Layanan</span>
        <div class="flex items-center justify-between">
          <span class="text-[15px] font-bold">{{ booking.serviceName }}</span>
          <span class="flex items-center gap-1 text-xs font-semibold text-on-surface-variant">
            <Clock :size="13" :stroke-width="1.8" />
            {{ booking.duration }} mnt &bull; {{ booking.timeLabel }}
          </span>
        </div>
        <div class="flex items-center justify-between rounded-xl bg-surface-container-low px-3 py-2.5">
          <div class="flex flex-col">
            <span class="text-[10.5px] text-outline">Tarif Pasien</span>
            <span class="text-[13.5px] font-bold">{{ formatIDR(booking.price) }}</span>
          </div>
          <div class="flex flex-col items-end">
            <span class="text-[10.5px] text-outline">Porsi Mitra ({{ booking.partnerSharePct * 100 }}%)</span>
            <span class="text-[13.5px] font-bold text-primary">{{ formatIDR(booking.price * booking.partnerSharePct) }}</span>
          </div>
        </div>
      </div>

      <!-- Active flow -->
      <div v-if="!['selesai', 'dibatalkan'].includes(booking.status)" class="flex flex-col gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <span class="text-[13px] font-bold text-on-surface-variant">Catatan Layanan</span>
        <textarea
          v-model="notes"
          rows="4"
          placeholder="Tulis catatan klinis setelah sesi selesai (kondisi pasien, tindakan, catatan khusus)..."
          class="w-full resize-none rounded-xl border border-outline-variant bg-transparent p-3 text-sm text-on-surface outline-none placeholder:text-outline focus:border-primary"
        />
      </div>

      <!-- Completed / cancelled read-only -->
      <div v-else class="flex flex-col gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <template v-if="booking.status === 'selesai'">
          <span class="text-[13px] font-bold text-on-surface-variant">Catatan Layanan</span>
          <p class="text-sm leading-relaxed text-on-surface">{{ booking.serviceNotes || 'Tidak ada catatan.' }}</p>
          <template v-if="booking.ratingGiven">
            <div class="h-px bg-outline-variant/40" />
            <div class="flex items-center gap-1">
              <Star v-for="n in 5" :key="n" :size="14" :fill="n <= booking.ratingGiven ? '#fdad61' : 'none'" :stroke="n <= booking.ratingGiven ? '#fdad61' : '#bdc9c6'" />
            </div>
            <p v-if="booking.reviewText" class="text-sm italic text-on-surface-variant">&ldquo;{{ booking.reviewText }}&rdquo;</p>
          </template>
        </template>
        <template v-else>
          <div class="flex items-center gap-2 text-error">
            <XCircle :size="18" />
            <span class="text-sm font-bold">Booking Dibatalkan</span>
          </div>
          <p v-if="booking.cancelCompensation" class="text-sm text-on-surface-variant">
            Kompensasi waktu perjalanan diterima: <span class="font-bold text-primary">{{ formatIDR(booking.cancelCompensation) }}</span>
          </p>
        </template>
      </div>
    </div>

    <div v-if="!['selesai', 'dibatalkan'].includes(booking.status)" class="border-t border-outline-variant/40 bg-surface-container-lowest px-5 py-4">
      <button
        type="button"
        class="flex h-12 w-full items-center justify-center gap-2 rounded-2xl bg-primary text-sm font-bold text-on-primary"
        @click="handlePrimaryAction"
      >
        <CheckCircle2 :size="17" />
        {{ nextStatusLabel(booking.status) }}
      </button>
    </div>
  </div>

  <div v-else class="flex flex-1 flex-col items-center justify-center gap-3 px-6 text-center">
    <span class="text-sm text-outline">Booking tidak ditemukan.</span>
    <NuxtLink to="/order" class="flex items-center gap-1 text-sm font-semibold text-primary">
      <ArrowLeft :size="15" />
      Kembali ke Order
    </NuxtLink>
  </div>
</template>
