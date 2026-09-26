<script setup lang="ts">
import { Clock } from '@lucide/vue'
import type { Service } from '~/data/dummy'
import { formatIDR } from '~/data/dummy'

defineProps<{ service: Service }>()
</script>

<template>
  <NuxtLink
    :to="`/customer/services/${service.id}`"
    class="flex gap-3 rounded-card bg-surface p-3 shadow-soft transition-transform active:scale-[0.98]"
  >
    <ServiceVisual :category-id="service.categoryId" :size="26" class="h-20 w-20 shrink-0 rounded-2xl" />
    <div class="flex min-w-0 flex-1 flex-col justify-between py-0.5">
      <div>
        <h3 class="truncate font-display text-[14px] font-bold text-ink">{{ service.name }}</h3>
        <p class="mt-0.5 line-clamp-1 text-[12px] text-ink-soft">{{ service.shortDesc }}</p>
      </div>
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-2 text-[11px] text-ink-soft">
          <StarRating :rating="service.rating" :size="12" />
          <span class="inline-flex items-center gap-0.5"><Clock :size="12" />{{ service.duration }}m</span>
        </div>
        <span class="font-display text-[13px] font-bold text-primary-600">{{ formatIDR(service.price) }}</span>
      </div>
    </div>
  </NuxtLink>
</template>
