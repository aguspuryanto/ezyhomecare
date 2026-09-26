<script setup lang="ts">
import { computed } from 'vue'
import { services } from '~/data/dummy'

definePageMeta({ showBottomNav: true })

// Simulasi layanan yang difavoritkan (mengambil 3 layanan pertama)
const favoriteServices = computed(() => services.slice(0, 3))
</script>

<template>
  <div class="pb-8">
    <TopBar title="Layanan Favorit" :back="false" />

    <div class="mt-2 flex flex-col gap-3 px-5">
      <div v-if="favoriteServices.length === 0" class="rounded-card bg-surface p-6 text-center text-[13px] text-ink-soft shadow-soft">
        Anda belum memiliki layanan favorit.
      </div>
      
      <ServiceCard v-for="service in favoriteServices" :key="service.id" :service="service" />
    </div>
  </div>
</template>
