<script setup lang="ts">
defineProps<{ modelValue: boolean }>()
defineEmits<{ 'update:modelValue': [value: boolean] }>()
</script>

<template>
  <button
    type="button"
    class="relative h-[22px] w-[38px] shrink-0 rounded-full p-0.5 transition-colors"
    :class="modelValue ? 'bg-primary' : 'bg-outline-variant'"
    @click="$emit('update:modelValue', !modelValue)"
  >
    <span
      class="block h-[18px] w-[18px] rounded-full bg-white transition-transform"
      :class="modelValue ? 'translate-x-4' : 'translate-x-0'"
    />
  </button>
</template>
