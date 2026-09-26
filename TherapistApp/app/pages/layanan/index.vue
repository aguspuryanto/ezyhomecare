<script setup lang="ts">
import { AlertTriangle, CheckCircle2, ChevronRight, ShieldCheck } from '@lucide/vue'
import { services as seedServices, formatIDR } from '~/data/dummy'

const services = useState('services', () => JSON.parse(JSON.stringify(seedServices)))

const equipment = [
  { name: 'Autoclave Sterilizer', detail: 'Kalibrasi terakhir: 2 Sep 2026', ok: true },
  { name: 'Sarung Tangan Nitril (Non-Powder)', detail: 'Stok: 34 pasang', ok: true },
  { name: 'Tensimeter Digital', detail: 'Perlu kalibrasi ulang sebelum kunjungan berikutnya', ok: false }
]
</script>

<template>
  <div class="flex flex-col gap-5 px-5 pt-[18px] pb-6">
    <TopBar />

    <div class="flex flex-col gap-0.5">
      <span class="text-xl font-bold text-on-surface">Kelola Layanan</span>
      <p class="text-sm text-on-surface-variant">Kredensial, keahlian &amp; kesiapan perlengkapan medis.</p>
    </div>

    <!-- Credentials -->
    <div class="flex flex-col gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
      <span class="text-[15px] font-bold">Kredensial &amp; Izin Praktik</span>
      <div class="flex gap-2.5">
        <div class="flex flex-1 flex-col gap-2 rounded-xl bg-primary-container/10 p-3">
          <div class="flex items-center justify-between">
            <ShieldCheck :size="20" class="text-primary" :stroke-width="1.8" />
            <CheckCircle2 :size="16" class="text-primary" fill="currentColor" stroke="white" />
          </div>
          <div class="flex flex-col">
            <span class="text-[13px] font-bold">Kemenkes RI</span>
            <span class="text-[11px] font-semibold text-primary">Terverifikasi &bull; STR Aktif</span>
          </div>
        </div>
        <div class="flex flex-1 flex-col gap-2 rounded-xl bg-primary-container/10 p-3">
          <div class="flex items-center justify-between">
            <ShieldCheck :size="20" class="text-primary" :stroke-width="1.8" />
            <CheckCircle2 :size="16" class="text-primary" fill="currentColor" stroke="white" />
          </div>
          <div class="flex flex-col">
            <span class="text-[13px] font-bold">BNSP</span>
            <span class="text-[11px] font-semibold text-primary">Terverifikasi &bull; Sertifikat Kompetensi</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Service list -->
    <div class="flex flex-col gap-3">
      <div class="flex items-center justify-between">
        <span class="text-[16px] font-bold">Daftar Layanan Keahlian</span>
        <span class="text-xs font-semibold text-primary">Bagi Hasil 80%</span>
      </div>

      <div
        v-for="service in services"
        :key="service.id"
        class="flex flex-col gap-2.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]"
        :class="{ 'opacity-70': !service.active }"
      >
        <div class="flex items-center justify-between">
          <span class="text-[14.5px] font-bold">{{ service.name }}</span>
          <ToggleSwitch v-model="service.active" />
        </div>
        <div class="flex items-center justify-between rounded-lg bg-surface-container-low px-3 py-2.5">
          <div class="flex flex-col">
            <span class="text-[10.5px] text-outline">Tarif Pasien</span>
            <span class="text-[13.5px] font-bold">{{ formatIDR(service.price) }}</span>
          </div>
          <ChevronRight :size="14" class="text-outline-variant" />
          <div class="flex flex-col items-end">
            <span class="text-[10.5px] text-outline">Porsi Mitra ({{ service.partnerSharePct * 100 }}%)</span>
            <span class="text-[13.5px] font-bold text-primary">{{ formatIDR(service.price * service.partnerSharePct) }}</span>
          </div>
        </div>
        <span v-if="!service.active" class="text-xs text-outline">Nonaktif &bull; tidak tampil ke pasien</span>
      </div>
    </div>

    <!-- Certificate alert -->
    <div class="flex gap-2.5 rounded-2xl border border-secondary-container/50 bg-secondary-container/10 p-4">
      <AlertTriangle :size="19" class="mt-px shrink-0 text-secondary" :stroke-width="1.9" />
      <div class="flex flex-1 flex-col gap-1.5">
        <span class="text-[13.5px] font-bold text-secondary">Sertifikat BNSP Bekam Terapis akan kedaluwarsa</span>
        <span class="text-xs text-secondary/90">Berlaku hingga 18 Sep 2026 &bull; 12 hari lagi. Perpanjang sekarang untuk menjaga status aktif layanan.</span>
        <button type="button" class="mt-1 w-fit rounded-lg bg-secondary px-3.5 py-2 text-xs font-semibold text-on-secondary">
          Perpanjang Sertifikat
        </button>
      </div>
    </div>

    <!-- Equipment audit -->
    <div class="flex flex-col gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
      <div class="flex items-center justify-between">
        <span class="text-[15px] font-bold">Audit Kesiapan Perlengkapan</span>
        <span class="rounded-lg bg-secondary-container/20 px-2 py-0.5 text-[11px] font-bold text-secondary">2/3 Siap</span>
      </div>
      <div v-for="item in equipment" :key="item.name" class="flex items-center gap-2.5">
        <CheckCircle2 v-if="item.ok" :size="20" class="shrink-0 text-primary" :stroke-width="2.1" />
        <AlertTriangle v-else :size="20" class="shrink-0 text-error" :stroke-width="1.9" />
        <div class="flex flex-1 flex-col">
          <span class="text-[13.5px] font-bold">{{ item.name }}</span>
          <span class="text-[11.5px]" :class="item.ok ? 'text-outline' : 'text-error'">{{ item.detail }}</span>
        </div>
      </div>
    </div>
  </div>
</template>
