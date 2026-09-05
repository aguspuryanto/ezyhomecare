<script setup lang="ts">
import { Star } from '@lucide/vue'
import { formatIDR, services } from '~/data/dummy'
import type { BookingHistoryItem } from '~/data/dummy'

definePageMeta({ showBottomNav: true })

const { history } = useBookingFlow()
const router = useRouter()

const filters = [
  { id: 'semua', label: 'Semua' },
  { id: 'berlangsung', label: 'Berlangsung' },
  { id: 'selesai', label: 'Selesai' },
  { id: 'dibatalkan', label: 'Dibatalkan' }
] as const

const activeFilter = ref<(typeof filters)[number]['id']>('semua')

const filtered = computed(() =>
  activeFilter.value === 'semua' ? history.value : history.value.filter((h) => h.status === activeFilter.value)
)

const statusStyle: Record<BookingHistoryItem['status'], string> = {
  selesai: 'bg-primary-50 text-primary-700',
  dibatalkan: 'bg-danger-100 text-danger-600',
  berlangsung: 'bg-accent-100 text-accent-600'
}

const statusLabel: Record<BookingHistoryItem['status'], string> = {
  selesai: 'Selesai',
  dibatalkan: 'Dibatalkan',
  berlangsung: 'Berlangsung'
}

function bookAgain(item: BookingHistoryItem) {
  const service = services.find((s) => s.name === item.serviceName)
  router.push(service ? `/layanan/${service.id}` : '/')
}
</script>

<template>
  <div class="pb-8">
    <TopBar title="Riwayat Pesanan" :back="false" />

    <div class="flex gap-2 overflow-x-auto px-5 pb-1">
      <button
        v-for="filter in filters"
        :key="filter.id"
        type="button"
        class="shrink-0 rounded-pill px-3.5 py-1.5 text-[12.5px] font-semibold transition-colors"
        :class="activeFilter === filter.id ? 'bg-primary-600 text-white' : 'bg-surface text-ink-soft shadow-soft'"
        @click="activeFilter = filter.id"
      >
        {{ filter.label }}
      </button>
    </div>

    <div class="mt-4 flex flex-col gap-3 px-5">
      <div v-if="filtered.length === 0" class="rounded-card bg-surface p-6 text-center text-[13px] text-ink-soft shadow-soft">
        Belum ada riwayat pesanan pada kategori ini.
      </div>

      <div v-for="item in filtered" :key="item.id" class="rounded-card bg-surface p-4 shadow-soft">
        <div class="flex items-start justify-between gap-2">
          <div class="min-w-0">
            <p class="truncate text-[14px] font-bold text-ink">{{ item.serviceName }}</p>
            <p class="text-[12px] text-ink-soft">{{ item.therapistName }} &middot; {{ item.date }}, {{ item.time }}</p>
          </div>
          <span class="shrink-0 rounded-pill px-2.5 py-1 text-[11px] font-semibold" :class="statusStyle[item.status]">
            {{ statusLabel[item.status] }}
          </span>
        </div>

        <div class="mt-3 flex items-center justify-between border-t border-line pt-3">
          <div>
            <p class="font-display text-[13.5px] font-bold text-primary-700">{{ formatIDR(item.price) }}</p>
            <p v-if="item.ratingGiven" class="mt-0.5 flex items-center gap-1 text-[11.5px] text-ink-soft">
              <Star :size="12" class="fill-accent-500 text-accent-500" />
              Anda memberi {{ item.ratingGiven }}.0
            </p>
          </div>
          <button
            v-if="item.status === 'berlangsung'"
            type="button"
            class="rounded-xl bg-accent-500 px-4 py-2 text-[12.5px] font-bold text-white"
            @click="router.push(`/booking/lacak/${item.id}`)"
          >
            Lacak
          </button>
          <button
            v-else-if="item.status === 'selesai'"
            type="button"
            class="rounded-xl border border-primary-500 px-4 py-2 text-[12.5px] font-bold text-primary-600"
            @click="bookAgain(item)"
          >
            Pesan Lagi
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
