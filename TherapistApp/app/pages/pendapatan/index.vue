<script setup lang="ts">
import { ArrowDownToLine, ArrowUpDown, Building2, Calendar, Clock, Download, HandHeart } from '@lucide/vue'
import { transactions, formatIDR } from '~/data/dummy'

const { user } = useAuth()

const balance = 2450000
</script>

<template>
  <div class="flex flex-col gap-[18px] px-5 pt-[18px] pb-6">
    <TopBar />

    <div class="flex flex-col gap-0.5">
      <span class="text-xl font-bold text-on-surface">Laporan Pendapatan</span>
      <p class="text-sm text-on-surface-variant">Dompet mitra &amp; ringkasan performa finansial.</p>
    </div>

    <!-- Wallet card -->
    <div class="flex flex-col gap-3.5 rounded-2xl bg-gradient-to-br from-primary-container to-[#00423b] p-[18px] shadow-[0_8px_22px_rgba(0,66,59,0.28)]">
      <div class="flex items-center justify-between">
        <span class="text-[12.5px] font-semibold text-tertiary-fixed">Saldo Siap Tarik</span>
        <span class="flex items-center gap-1 rounded-lg bg-white/15 px-2.5 py-0.5 text-[11px] font-bold text-primary-fixed">
          <ArrowUpDown :size="10" />
          18% bulan ini
        </span>
      </div>
      <span class="text-[30px] font-bold text-white">{{ formatIDR(balance) }}</span>
      <div class="flex gap-2.5">
        <button type="button" class="h-11 flex-1 rounded-xl bg-white text-sm font-bold text-primary">Tarik Saldo</button>
        <button type="button" class="flex h-11 w-11 items-center justify-center rounded-xl bg-white/15">
          <ArrowDownToLine :size="18" class="text-white" :stroke-width="1.9" />
        </button>
      </div>
      <div class="h-px bg-white/20" />
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-2.5">
          <div class="flex h-[30px] w-[30px] items-center justify-center rounded-full bg-white/15">
            <Building2 :size="15" class="text-white" :stroke-width="1.8" />
          </div>
          <div class="flex flex-col">
            <span class="text-[12.5px] font-bold text-white">{{ user.bankAccount ?? 'Belum diatur' }}</span>
            <span class="text-[11px] text-tertiary-fixed">Rekening Terverifikasi</span>
          </div>
        </div>
        <span class="text-xs font-semibold text-tertiary-fixed">Ubah</span>
      </div>
    </div>

    <!-- Weekly stats -->
    <div class="flex flex-col gap-2.5">
      <span class="text-[15px] font-bold">Aktivitas Minggu Ini</span>
      <div class="flex gap-2.5">
        <div class="flex flex-1 flex-col gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
          <Calendar :size="16" class="text-primary" :stroke-width="1.8" />
          <span class="text-[18px] font-bold">18</span>
          <span class="text-[11px] text-outline">Sesi Terapi</span>
        </div>
        <div class="flex flex-1 flex-col gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
          <Clock :size="16" class="text-primary" :stroke-width="1.8" />
          <span class="text-[18px] font-bold">32j</span>
          <span class="text-[11px] text-outline">Jam Praktik</span>
        </div>
        <div class="flex flex-1 flex-col gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
          <HandHeart :size="16" class="text-secondary" :stroke-width="1.8" />
          <span class="text-[18px] font-bold">Rp180K</span>
          <span class="text-[11px] text-outline">Tip Pasien</span>
        </div>
      </div>
    </div>

    <!-- Transactions -->
    <div class="flex flex-col gap-2.5">
      <span class="text-[15px] font-bold">Rincian Mutasi Transaksi</span>
      <div class="flex flex-col rounded-2xl border border-outline-variant/60 bg-surface-container-lowest px-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <div
          v-for="(tx, idx) in transactions"
          :key="tx.id"
          class="flex items-center gap-3 py-2.75"
          :class="{ 'border-b border-outline-variant/30': idx < transactions.length - 1 }"
        >
          <div
            class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full"
            :class="tx.kind === 'withdrawal' ? 'bg-secondary-container/20' : 'bg-primary-container/15'"
          >
            <ArrowDownToLine v-if="tx.kind === 'withdrawal'" :size="17" class="rotate-180 text-secondary" :stroke-width="1.8" />
            <ArrowUpDown v-else :size="17" class="text-primary" :stroke-width="1.8" />
          </div>
          <div class="flex flex-1 flex-col">
            <span class="text-[13.5px] font-bold">{{ tx.label }}</span>
            <span class="text-[11.5px] text-outline">{{ tx.timestamp }}</span>
          </div>
          <span class="text-sm font-bold" :class="tx.amount < 0 ? 'text-secondary' : 'text-primary'">
            {{ tx.amount < 0 ? '-' : '+' }}{{ formatIDR(Math.abs(tx.amount)) }}
          </span>
        </div>
      </div>
    </div>

    <button type="button" class="flex h-12 items-center justify-center gap-2 rounded-xl border border-outline-variant text-sm font-semibold text-primary">
      <Download :size="17" :stroke-width="1.8" />
      Unduh Laporan PDF (PPh 21)
    </button>
  </div>
</template>
