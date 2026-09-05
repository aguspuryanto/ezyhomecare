<script setup lang="ts">
const route = useRoute()
const showBottomNav = computed(() => Boolean(route.meta.showBottomNav))
</script>

<template>
  <div class="min-h-screen bg-cream-soft flex justify-center md:py-10">
    <div
      class="relative flex w-full max-w-[440px] flex-col overflow-hidden bg-cream md:min-h-[880px] md:rounded-[2.5rem] md:shadow-lift md:ring-8 md:ring-white"
    >
      <main class="flex-1 overflow-y-auto" :class="showBottomNav ? 'pb-24' : ''">
        <slot />
      </main>
      <BottomNav v-if="showBottomNav" />
    </div>
  </div>
</template>
