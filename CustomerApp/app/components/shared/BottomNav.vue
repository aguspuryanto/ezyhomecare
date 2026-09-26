<script setup lang="ts">
import { Home, CalendarDays, Heart, User } from '@lucide/vue'

const route = useRoute()

const tabs = [
  { to: '/customer', label: 'Home', icon: Home },
  { to: '/customer/bookings', label: 'Riwayat', icon: CalendarDays },
  { to: '/customer/services/favorites', label: 'Favorit', icon: Heart },
  { to: '/customer/profile', label: 'Profil', icon: User }
]
</script>

<template>
  <nav
    class="absolute inset-x-0 bottom-0 z-20 flex items-stretch border-t border-line bg-surface/95 px-6 backdrop-blur"
    style="padding-bottom: env(safe-area-inset-bottom)"
  >
    <NuxtLink
      v-for="tab in tabs"
      :key="tab.to"
      :to="tab.to"
      class="flex flex-1 flex-col items-center gap-1 py-3 text-xs font-medium transition-colors"
      :class="route.path === tab.to ? 'text-primary-600' : 'text-ink-soft/70'"
    >
      <component :is="tab.icon" :size="22" :stroke-width="route.path === tab.to ? 2.25 : 1.75" />
      {{ tab.label }}
    </NuxtLink>
  </nav>
</template>
