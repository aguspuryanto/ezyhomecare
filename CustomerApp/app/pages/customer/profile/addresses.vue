<script setup lang="ts">
import { ref } from 'vue'
import { initialAddresses } from '~/data/dummy'
import { Plus, Edit2, MapPin } from '@lucide/vue'

definePageMeta({ showBottomNav: false })

const addresses = ref(initialAddresses)
</script>

<template>
  <div class="flex min-h-full flex-col pb-6">
    <TopBar title="Daftar Alamat Saya" :back="true" />

    <div class="flex-1 flex flex-col gap-4 px-5 pt-2">
      <div v-for="address in addresses" :key="address.id" class="rounded-[1.25rem] bg-white p-4 shadow-soft">
        <div class="flex items-start justify-between">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary-50 text-primary-600">
              <MapPin :size="20" />
            </div>
            <div>
              <p class="font-display text-[14px] font-bold text-ink flex items-center gap-2">
                {{ address.label }}
                <span v-if="address.isDefault" class="rounded bg-primary-100 px-1.5 py-0.5 text-[10px] font-bold text-primary-700">Utama</span>
              </p>
              <p class="text-[12px] text-ink-soft">{{ address.recipient }} &middot; {{ address.phone }}</p>
            </div>
          </div>
          <button class="flex h-8 w-8 items-center justify-center rounded-full bg-surface text-ink-soft hover:text-primary-600 transition-colors">
            <Edit2 :size="16" />
          </button>
        </div>
        
        <div class="mt-4 border-t border-line pt-3">
          <p class="text-[13px] text-ink">{{ address.fullAddress }}</p>
          <p v-if="address.detail" class="mt-1 text-[12px] text-ink-soft italic">{{ address.detail }}</p>
        </div>
      </div>
    </div>

    <!-- Sticky Add Button at Bottom -->
    <div class="sticky bottom-0 left-0 right-0 bg-cream/90 backdrop-blur-md border-t border-line p-5 mt-6">
      <button class="flex w-full items-center justify-center gap-2 rounded-xl bg-primary-600 py-3.5 text-[14px] font-bold text-white shadow-soft transition-colors hover:bg-primary-700">
        <Plus :size="18" />
        Tambah Alamat Baru
      </button>
    </div>
  </div>
</template>
