<script setup lang="ts">
import { Bell } from '@lucide/vue'

const { user, available } = useAuth()
const { incoming } = useBookings()
</script>

<template>
  <!-- Negative margins cancel the page's px-5 / pt-[18px] so the bar spans full width -->
  <div class="sticky top-0 z-20 -mx-5 -mt-[18px] flex items-center justify-between border-b border-outline-variant/40 bg-surface-container-lowest px-5 py-3 shadow-[0_4px_16px_rgba(0,104,93,0.08)]">
    <div class="flex items-center gap-2">
      <!-- <div class="flex h-[34px] w-[34px] items-center justify-center rounded-[10px] bg-primary text-[14px] font-bold text-on-primary">CH</div> -->
      <div class="flex items-center gap-1.5">
        <span class="text-[17px] font-bold">EzyHomecare</span>
        <span class="rounded-lg bg-primary-container px-[7px] py-[3px] text-[10px] font-bold tracking-wide text-on-primary-container">MITRA</span>
      </div>
    </div>
    <div class="flex items-center gap-3.5">
      <div class="flex items-center gap-1.5">
        <span class="text-xs font-semibold text-on-surface-variant">Siaga</span>
        <ToggleSwitch v-model="available" />
      </div>
      <div class="relative text-on-surface-variant">
        <Bell :size="21" :stroke-width="1.8" />
        <div
          v-if="incoming.length"
          class="absolute -right-px -top-px h-[7px] w-[7px] rounded-full border-[1.5px] border-surface bg-secondary-container"
        />
      </div>
      <div class="flex h-[34px] w-[34px] items-center justify-center rounded-full bg-primary-container text-xs font-bold text-on-primary-container">
        {{ user.initials }}
      </div>
    </div>
  </div>
</template>
