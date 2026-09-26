<script setup lang="ts">
import { ChevronLeft } from '@lucide/vue'

definePageMeta({ layout: 'blank' })

const { schedule, toggleDay } = useSchedule()
</script>

<template>
  <div class="flex flex-1 flex-col">
    <div class="flex items-center gap-3 px-5 pb-3 pt-[18px]">
      <button type="button" class="flex h-9 w-9 items-center justify-center rounded-full border border-outline-variant/60" @click="$router.back()">
        <ChevronLeft :size="18" />
      </button>
      <div class="flex flex-col">
        <span class="text-[17px] font-bold">Jadwal Kerja</span>
        <span class="text-xs text-outline">Atur hari &amp; jam praktik home service</span>
      </div>
    </div>

    <div class="flex flex-1 flex-col gap-3 overflow-y-auto px-5 pb-8">
      <div
        v-for="entry in schedule"
        :key="entry.day"
        class="flex flex-col gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]"
        :class="{ 'opacity-60': !entry.active }"
      >
        <div class="flex items-center justify-between">
          <span class="text-[14.5px] font-bold">{{ entry.day }}</span>
          <ToggleSwitch :model-value="entry.active" @update:model-value="toggleDay(entry.day)" />
        </div>
        <div v-if="entry.active" class="flex items-center gap-2.5">
          <label class="flex flex-1 flex-col gap-1">
            <span class="text-[10.5px] text-outline">Mulai</span>
            <input v-model="entry.start" type="time" class="rounded-lg border border-outline-variant bg-transparent px-3 py-2 text-sm text-on-surface outline-none focus:border-primary">
          </label>
          <span class="mt-4 text-outline">-</span>
          <label class="flex flex-1 flex-col gap-1">
            <span class="text-[10.5px] text-outline">Selesai</span>
            <input v-model="entry.end" type="time" class="rounded-lg border border-outline-variant bg-transparent px-3 py-2 text-sm text-on-surface outline-none focus:border-primary">
          </label>
        </div>
        <span v-else class="text-xs text-outline">Libur &bull; tidak menerima booking</span>
      </div>
    </div>
  </div>
</template>
