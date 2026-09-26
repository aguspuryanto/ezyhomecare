<script setup lang="ts">
import { Baby, Heart, Leaf, Sparkles, Stethoscope, User } from '@lucide/vue'
import { categories } from '~/data/dummy'

const props = withDefaults(defineProps<{ categoryId: string; size?: number }>(), { size: 26 })

const iconMap: Record<string, any> = { Leaf, Sparkles, Stethoscope, Heart, Baby, User }

const category = computed(() => categories.find((c) => c.id === props.categoryId) ?? categories[0])
</script>

<template>
  <div
    class="relative flex items-center justify-center overflow-hidden"
    :style="{ background: `linear-gradient(135deg, ${category.gradientFrom}, ${category.gradientTo})` }"
  >
    <div class="pointer-events-none absolute -right-3 -top-4 h-16 w-16 rounded-full bg-white/10" />
    <div class="pointer-events-none absolute -bottom-5 -left-3 h-14 w-14 rounded-full bg-black/10" />
    <component :is="iconMap[category.icon]" :size="size" :stroke-width="1.5" class="relative text-white" />
  </div>
</template>
