<script setup lang="ts">
import { ArrowLeft } from '@lucide/vue'

withDefaults(
  defineProps<{
    title?: string
    back?: boolean
    transparent?: boolean
  }>(),
  { title: '', back: true, transparent: false }
)

const router = useRouter()
</script>

<template>
  <header
    class="flex items-center gap-3 px-5 pb-3 pt-6"
    :class="transparent ? '' : 'bg-cream'"
  >
    <button
      v-if="back"
      type="button"
      aria-label="Kembali"
      class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-surface text-ink shadow-soft"
      @click="router.back()"
    >
      <ArrowLeft :size="19" :stroke-width="2" />
    </button>
    <h1 v-if="title" class="font-display text-[17px] font-bold text-ink">{{ title }}</h1>
    <div class="ml-auto flex items-center gap-2">
      <slot name="right" />
    </div>
  </header>
</template>
