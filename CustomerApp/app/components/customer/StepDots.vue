<script setup lang="ts">
const props = defineProps<{
  step: number // 1-based current step
}>()

const steps = ['Terapis', 'Jadwal', 'Alamat', 'Bayar']
</script>

<template>
  <div class="flex items-center gap-2 px-5 pb-4">
    <template v-for="(label, index) in steps" :key="label">
      <div class="flex items-center gap-1.5">
        <span
          class="flex h-5 w-5 items-center justify-center rounded-full text-[10px] font-bold"
          :class="
            index + 1 <= props.step
              ? 'bg-primary-500 text-white'
              : 'bg-line text-ink-soft'
          "
        >
          {{ index + 1 }}
        </span>
        <span
          class="text-[11px] font-medium"
          :class="index + 1 <= props.step ? 'text-ink' : 'text-ink-soft/70'"
        >
          {{ label }}
        </span>
      </div>
      <div
        v-if="index < steps.length - 1"
        class="h-px flex-1"
        :class="index + 1 < props.step ? 'bg-primary-500' : 'bg-line'"
      />
    </template>
  </div>
</template>
