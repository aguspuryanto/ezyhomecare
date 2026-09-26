<script setup lang="ts">
import { Star } from '@lucide/vue'

withDefaults(
  defineProps<{
    rating: number
    reviewCount?: number
    size?: number
  }>(),
  { reviewCount: undefined, size: 14 }
)
</script>

<template>
  <span class="inline-flex items-center gap-1 text-[13px] font-semibold text-ink">
    <Star :size="size" class="fill-accent-500 text-accent-500" />
    {{ rating.toFixed(1) }}
    <span v-if="reviewCount !== undefined" class="font-normal text-ink-soft">({{ reviewCount }})</span>
  </span>
</template>
