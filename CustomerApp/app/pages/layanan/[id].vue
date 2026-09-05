<script setup lang="ts">
import { ArrowLeft, Check, Clock, Heart } from '@lucide/vue'
import { formatIDR, services } from '~/data/dummy'

definePageMeta({ showBottomNav: false })

const route = useRoute()
const router = useRouter()
const { flow } = useBookingFlow()

const service = computed(() => services.find((s) => s.id === route.params.id) ?? services[0])
const isFavorite = ref(false)

function chooseTherapist() {
  flow.value.service = service.value
  router.push('/booking/terapis')
}
</script>

<template>
  <div class="pb-28">
    <div class="relative">
      <ServiceVisual :category-id="service.categoryId" :size="64" class="h-64 w-full" />
      <button
        type="button"
        aria-label="Kembali"
        class="absolute left-5 top-6 flex h-10 w-10 items-center justify-center rounded-full bg-white/90 text-ink shadow-soft"
        @click="router.back()"
      >
        <ArrowLeft :size="19" :stroke-width="2" />
      </button>
      <button
        type="button"
        aria-label="Simpan"
        class="absolute right-5 top-6 flex h-10 w-10 items-center justify-center rounded-full bg-white/90 shadow-soft"
        @click="isFavorite = !isFavorite"
      >
        <Heart :size="19" :stroke-width="2" :class="isFavorite ? 'fill-accent-500 text-accent-500' : 'text-ink'" />
      </button>
    </div>

    <div class="rounded-t-[2rem] bg-cream px-5 pb-6 pt-5 -mt-5 relative">
      <h1 class="font-display text-[20px] font-extrabold leading-snug text-ink">{{ service.name }}</h1>
      <div class="mt-2 flex items-center gap-3 text-ink-soft">
        <StarRating :rating="service.rating" :review-count="service.reviewCount" />
        <span class="inline-flex items-center gap-1 text-[13px]"><Clock :size="14" />{{ service.duration }} menit</span>
      </div>

      <div class="mt-4 flex flex-wrap gap-2">
        <span
          v-for="benefit in service.benefits"
          :key="benefit"
          class="rounded-pill bg-primary-50 px-3 py-1.5 text-[12px] font-medium text-primary-700"
        >
          {{ benefit }}
        </span>
      </div>

      <div class="mt-5">
        <h2 class="font-display text-[14px] font-bold text-ink">Tentang Layanan</h2>
        <p class="mt-2 text-[13.5px] leading-relaxed text-ink-soft">{{ service.description }}</p>
      </div>

      <div class="mt-5">
        <h2 class="font-display text-[14px] font-bold text-ink">Yang Anda Dapatkan</h2>
        <ul class="mt-2 space-y-2">
          <li v-for="item in service.includes" :key="item" class="flex items-center gap-2 text-[13.5px] text-ink">
            <span class="flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-primary-50 text-primary-600">
              <Check :size="12" :stroke-width="3" />
            </span>
            {{ item }}
          </li>
        </ul>
      </div>
    </div>

    <div class="fixed inset-x-0 bottom-0 z-20 mx-auto flex w-full max-w-[440px] items-center gap-4 border-t border-line bg-surface px-5 py-4">
      <div>
        <p class="text-[11px] text-ink-soft">Mulai dari</p>
        <p class="font-display text-[17px] font-extrabold text-primary-700">{{ formatIDR(service.price) }}</p>
      </div>
      <button
        type="button"
        class="ml-auto flex-1 rounded-2xl bg-accent-500 py-3.5 text-[14px] font-bold text-white shadow-lift transition-transform active:scale-[0.98]"
        @click="chooseTherapist"
      >
        Pilih Terapis
      </button>
    </div>
  </div>
</template>
