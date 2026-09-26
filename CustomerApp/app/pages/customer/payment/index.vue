<script setup lang="ts">
import { Wallet, Plus, CreditCard, Smartphone, QrCode, Banknote, ChevronRight } from '@lucide/vue'
import { paymentMethods, formatIDR } from '~/data/dummy'

definePageMeta({ showBottomNav: false })

const walletBalance = 450000

function getIcon(type: string) {
  switch (type) {
    case 'qris': return QrCode
    case 'ewallet': return Smartphone
    case 'card': return CreditCard
    case 'cash': return Banknote
    default: return CreditCard
  }
}
</script>

<template>
  <div class="flex min-h-full flex-col pb-6 bg-cream-soft">
    <TopBar title="Pembayaran & Dompet" :back="true" />

    <div class="flex-1 px-5 pt-4">
      <!-- EzyPay Wallet Card -->
      <div class="relative overflow-hidden rounded-[1.25rem] bg-primary-600 p-5 shadow-soft">
        <div class="pointer-events-none absolute -right-6 -top-8 h-28 w-28 rounded-full bg-white/10" />
        <div class="pointer-events-none absolute -bottom-10 right-10 h-20 w-20 rounded-full bg-accent-500/30" />
        
        <div class="relative flex items-center justify-between mb-4">
          <p class="font-display text-[13px] font-bold tracking-wide text-primary-100 uppercase flex items-center gap-2">
            <Wallet :size="16" /> EzyPay Saldo
          </p>
          <button class="rounded-full bg-white/20 px-3 py-1 text-[11px] font-bold text-white backdrop-blur-sm">
            Riwayat Saldo
          </button>
        </div>
        
        <p class="relative font-display text-[28px] font-extrabold text-white tracking-tight">
          {{ formatIDR(walletBalance) }}
        </p>
        
        <div class="relative mt-5 flex gap-3">
          <button class="flex-1 rounded-xl bg-white text-primary-700 py-2.5 text-[13px] font-bold shadow-sm transition-transform active:scale-[0.98]">
            Isi Saldo
          </button>
          <button class="flex-1 rounded-xl bg-primary-700 text-white py-2.5 text-[13px] font-bold shadow-sm border border-primary-500 transition-transform active:scale-[0.98]">
            Tarik Tunai
          </button>
        </div>
      </div>

      <!-- Akun Terhubung -->
      <div class="mt-6">
        <h2 class="mb-3 font-display text-[15px] font-bold text-ink">Akun Terhubung</h2>
        <div class="flex flex-col rounded-[1.25rem] bg-white shadow-soft overflow-hidden">
          <div class="flex items-center gap-4 p-4 border-b border-line last:border-0">
            <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-[#00AA13]/10 text-[#00AA13]">
              <Smartphone :size="20" />
            </div>
            <div class="flex-1 min-w-0">
              <p class="font-display text-[14px] font-bold text-ink">GoPay</p>
              <p class="truncate text-[12px] text-ink-soft">0812-3456-****</p>
            </div>
            <div class="text-[12px] font-semibold text-ink-soft bg-surface border border-line px-2.5 py-1 rounded-md">
              Terhubung
            </div>
          </div>
        </div>
      </div>

      <!-- Metode Pembayaran Lainnya -->
      <div class="mt-6">
        <div class="flex items-center justify-between mb-3">
          <h2 class="font-display text-[15px] font-bold text-ink">Metode Pembayaran</h2>
          <button class="text-[12px] font-semibold text-primary-600 flex items-center gap-1">
            <Plus :size="14" /> Tambah
          </button>
        </div>

        <div class="flex flex-col rounded-[1.25rem] bg-white shadow-soft overflow-hidden">
          <button v-for="method in paymentMethods" :key="method.id" class="flex items-center gap-4 p-4 text-left border-b border-line last:border-0 hover:bg-surface transition-colors">
            <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary-50 text-primary-600">
              <component :is="getIcon(method.type)" :size="20" />
            </div>
            <div class="flex-1 min-w-0">
              <p class="font-display text-[14px] font-bold text-ink">{{ method.name }}</p>
              <p class="truncate text-[12px] text-ink-soft">{{ method.subtitle }}</p>
            </div>
            
            <div v-if="method.type === 'ewallet' && method.id !== 'ewallet'" class="text-[12px] font-semibold text-primary-600">
              Hubungkan
            </div>
            <div v-else-if="method.type === 'card'" class="text-[12px] font-semibold text-primary-600">
              Tambah
            </div>
            <ChevronRight v-else :size="16" class="text-ink-soft" />
          </button>
        </div>
      </div>

    </div>
  </div>
</template>
