<script setup lang="ts">
import { Calendar, Briefcase, History, Wallet, User } from '@lucide/vue'

const tabs = [
  { to: '/order', label: 'Order', icon: Calendar },
  { to: '/layanan', label: 'Layanan', icon: Briefcase },
  { to: '/riwayat', label: 'Riwayat', icon: History },
  { to: '/pendapatan', label: 'Pendapatan', icon: Wallet },
  { to: '/profil', label: 'Profil', icon: User },
]

const { incoming } = useBookings()
</script>

<template>
  <div class="mx-auto flex h-dvh max-w-md flex-col bg-surface">
    <main class="flex-1 overflow-y-auto pb-[84px]">
      <slot />
    </main>

    <nav
      class="fixed inset-x-0 bottom-0 mx-auto flex max-w-md items-start gap-1 border-t border-outline-variant/40 bg-surface-container-lowest px-2 pt-2.5 shadow-[0_-4px_16px_rgba(0,104,93,0.06)]"
      style="height: 80px"
    >
      <NuxtLink
        v-for="tab in tabs"
        :key="tab.to"
        :to="tab.to"
        class="relative flex flex-1 flex-col items-center gap-1 text-outline"
        active-class="!text-primary"
      >
        <span class="relative">
          <component :is="tab.icon" :size="21" :stroke-width="2" />
          <span
            v-if="tab.to === '/order' && incoming.length"
            class="absolute -right-1 -top-1 h-[7px] w-[7px] rounded-full border border-surface-container-lowest bg-secondary-container"
          />
        </span>
        <span class="text-[11px] font-semibold">{{ tab.label }}</span>
      </NuxtLink>
    </nav>
  </div>
</template>
