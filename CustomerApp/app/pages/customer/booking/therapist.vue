<script setup lang="ts">
import { BadgeCheck, MapPin } from '@lucide/vue'
import { formatIDR, services, therapists } from '~/data/dummy'

definePageMeta({ showBottomNav: false })

const route = useRoute()
const router = useRouter()
const { flow } = useBookingFlow()

if (!flow.value.service) {
  const fallback = services.find((s) => s.id === route.query.service) ?? null
  if (fallback) {
    flow.value.service = fallback
  } else {
    navigateTo('/customer')
  }
}

function selectTherapist(id: string) {
  flow.value.therapist = therapists.find((t) => t.id === id) ?? null
}

function continueToSchedule() {
  if (!flow.value.therapist) return
  router.push('/customer/booking/schedule')
}
</script>

<template>
  <div v-if="flow.service" class="pb-28">
    <TopBar title="Pilih Terapis" />
    <StepDots :step="1" />

    <div class="mx-5 flex items-center gap-3 rounded-2xl bg-surface p-3 shadow-soft">
      <ServiceVisual :category-id="flow.service.categoryId" :size="18" class="h-12 w-12 rounded-xl" />
      <div class="min-w-0">
        <p class="truncate text-[13px] font-bold text-ink">{{ flow.service.name }}</p>
        <p class="text-[12px] text-primary-600">{{ formatIDR(flow.service.price) }} &middot; {{ flow.service.duration }} menit</p>
      </div>
    </div>

    <div class="mt-4 flex flex-col gap-3 px-5">
      <button
        v-for="therapist in therapists"
        :key="therapist.id"
        type="button"
        class="flex items-start gap-3 rounded-card border-2 bg-surface p-3.5 text-left transition-colors"
        :class="flow.therapist?.id === therapist.id ? 'border-primary-500' : 'border-transparent shadow-soft'"
        @click="selectTherapist(therapist.id)"
      >
        <img :src="therapist.photo" :alt="therapist.name" class="h-14 w-14 rounded-2xl object-cover">
        <div class="min-w-0 flex-1">
          <div class="flex items-center gap-1">
            <p class="truncate font-display text-[14px] font-bold text-ink">{{ therapist.name }}</p>
            <BadgeCheck v-if="therapist.verified" :size="14" class="shrink-0 fill-primary-500 text-white" />
          </div>
          <div class="mt-1 flex flex-wrap gap-1.5">
            <span
              v-for="tag in therapist.specialties"
              :key="tag"
              class="rounded-pill bg-primary-50 px-2 py-0.5 text-[10.5px] font-medium text-primary-700"
            >
              {{ tag }}
            </span>
          </div>
          <div class="mt-1.5 flex items-center gap-3 text-[11.5px] text-ink-soft">
            <StarRating :rating="therapist.rating" :review-count="therapist.reviewCount" :size="12" />
            <span>{{ therapist.experienceYears }} thn pengalaman</span>
          </div>
          <div class="mt-1 flex items-center gap-3 text-[11.5px] text-ink-soft">
            <span class="inline-flex items-center gap-0.5"><MapPin :size="12" />{{ therapist.distanceKm }} km</span>
            <span v-if="therapist.availableToday" class="font-semibold text-primary-600">Tersedia hari ini</span>
            <span v-else class="text-ink-soft/70">Tidak tersedia hari ini</span>
          </div>
        </div>
      </button>
    </div>

    <div class="fixed inset-x-0 bottom-0 z-20 mx-auto w-full max-w-[440px] border-t border-line bg-surface px-5 py-4">
      <button
        type="button"
        class="w-full rounded-2xl py-3.5 text-[14px] font-bold text-white shadow-lift transition-transform active:scale-[0.98] disabled:opacity-40"
        :class="flow.therapist ? 'bg-accent-500' : 'bg-ink-soft'"
        :disabled="!flow.therapist"
        @click="continueToSchedule"
      >
        Lanjutkan
      </button>
    </div>
  </div>
</template>
