<script setup lang="ts">
import { FileText, ShieldCheck, Star } from '@lucide/vue'
import { formatIDR } from '~/data/dummy'

const { history } = useBookings()

const filters = ['Semua', 'Selesai', 'Dibatalkan'] as const
const activeFilter = ref<(typeof filters)[number]>('Semua')

const filtered = computed(() => {
  if (activeFilter.value === 'Selesai') return history.value.filter((b) => b.status === 'selesai')
  if (activeFilter.value === 'Dibatalkan') return history.value.filter((b) => b.status === 'dibatalkan')
  return history.value
})
</script>

<template>
  <div class="flex flex-col gap-5 px-5 pt-[18px] pb-6">
    <TopBar />

    <div class="flex flex-col gap-0.5">
      <span class="text-xl font-bold text-on-surface">Riwayat Layanan</span>
      <p class="text-sm text-on-surface-variant">Rekam jejak kunjungan dan penilaian pasien.</p>
    </div>

    <!-- Filters -->
    <div class="flex gap-2">
      <button
        v-for="f in filters"
        :key="f"
        type="button"
        class="rounded-full px-4 py-2 text-[13px] font-semibold"
        :class="activeFilter === f ? 'bg-primary text-on-primary' : 'border border-outline-variant text-on-surface-variant'"
        @click="activeFilter = f"
      >
        {{ f }}
      </button>
    </div>

    <!-- History cards -->
    <div class="flex flex-col gap-3">
      <p v-if="!filtered.length" class="rounded-2xl border border-dashed border-outline-variant px-4 py-6 text-center text-sm text-outline">
        Tidak ada riwayat untuk filter ini.
      </p>

      <div
        v-for="item in filtered"
        :key="item.id"
        class="flex flex-col gap-2.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]"
      >
        <div class="flex items-center justify-between">
          <span class="text-xs font-bold text-outline">#{{ item.id }}</span>
          <span
            class="rounded-lg px-2.5 py-0.5 text-[11px] font-bold"
            :class="item.status === 'selesai' ? 'bg-primary-container/15 text-primary' : 'bg-error-container text-on-error-container'"
          >
            {{ item.status === 'selesai' ? 'Selesai' : 'Dibatalkan' }}
          </span>
        </div>
        <div class="flex items-center justify-between">
          <div class="flex flex-col gap-0.5">
            <span class="text-[14.5px] font-bold">{{ item.customerName }}</span>
            <span class="text-xs text-outline">{{ item.address }} &bull; {{ item.dateLabel }}</span>
          </div>
          <span class="whitespace-nowrap text-[15px] font-bold" :class="item.status === 'selesai' ? 'text-primary' : 'text-on-surface-variant'">
            {{ item.status === 'selesai' ? `+${formatIDR(item.price * item.partnerSharePct)}` : formatIDR(0) }}
          </span>
        </div>

        <template v-if="item.status === 'selesai'">
          <div v-if="item.ratingGiven" class="flex items-center gap-1">
            <Star v-for="n in 5" :key="n" :size="13" :fill="n <= item.ratingGiven ? '#fdad61' : 'none'" :stroke="n <= item.ratingGiven ? '#fdad61' : '#bdc9c6'" />
            <span v-if="item.reviewText" class="ml-1 text-xs text-on-surface-variant">&ldquo;{{ item.reviewText }}&rdquo;</span>
          </div>
          <NuxtLink
            :to="`/order/${item.id}`"
            class="flex w-fit items-center gap-1.5 rounded-lg bg-surface-container-low px-3 py-2 text-xs font-semibold text-primary"
          >
            <FileText :size="14" :stroke-width="1.8" />
            Lihat Catatan Klinis
          </NuxtLink>
        </template>
        <div v-else class="flex items-start gap-2 rounded-lg bg-surface-container-low px-3 py-2.5">
          <ShieldCheck :size="15" class="mt-px shrink-0 text-primary" :stroke-width="1.8" />
          <span class="text-xs leading-relaxed text-on-surface-variant">
            Dibatalkan sepihak oleh pasien setelah Anda menuju lokasi. Kompensasi waktu perjalanan diterima:
            <span class="font-bold text-primary">{{ formatIDR(item.cancelCompensation ?? 0) }}</span>
          </span>
        </div>
      </div>
    </div>

    <!-- Cancellation protection -->
    <div class="flex gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
      <div class="flex h-[34px] w-[34px] shrink-0 items-center justify-center rounded-[10px] bg-primary-container/15">
        <ShieldCheck :size="18" class="text-primary" :stroke-width="1.9" />
      </div>
      <div class="flex flex-col gap-1">
        <span class="text-sm font-bold">Proteksi Pembatalan Sepihak</span>
        <span class="text-[12.5px] leading-relaxed text-on-surface-variant">
          Jika pasien membatalkan setelah status Anda &ldquo;Menuju Lokasi&rdquo;, CareHome memberikan kompensasi waktu perjalanan sebesar 20% dari tarif layanan secara otomatis ke dompet mitra.
        </span>
      </div>
    </div>
  </div>
</template>
