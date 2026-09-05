<script setup lang="ts">
import { AlertCircle, FileText, Droplets, Activity, Pill, Edit2, Plus } from '@lucide/vue'

definePageMeta({ showBottomNav: false })

const healthData = {
  bloodType: 'O+',
  height: '172 cm',
  weight: '70 kg',
  allergies: ['Minyak kayu putih', 'Seafood (Udang & Kepiting)'],
  conditions: ['Asma ringan', 'Hipertensi terkontrol', 'Asam urat'],
  medications: ['Amlodipine 5mg (Harian)', 'Inhaler Salbutamol (Bila perlu)']
}
</script>

<template>
  <div class="flex min-h-full flex-col pb-6">
    <TopBar title="Rekam Medis" :back="true" />

    <div class="flex-1 px-5 pt-4">
      <!-- Info Banner -->
      <div class="mb-4 rounded-xl bg-primary-50 p-3 flex gap-3 shadow-sm border border-primary-100">
        <AlertCircle :size="20" class="text-primary-600 shrink-0 mt-0.5" />
        <p class="text-[12.5px] text-primary-800 leading-relaxed">
          Informasi ini digunakan oleh terapis untuk menyesuaikan perawatan dan memastikan keamanan tindakan selama sesi berjalan.
        </p>
      </div>

      <!-- Data Fisik Dasar -->
      <div class="rounded-[1.25rem] bg-white p-5 shadow-soft">
        <div class="flex items-center justify-between mb-4">
          <h2 class="font-display text-[15px] font-bold text-ink">Data Fisik Dasar</h2>
          <button class="text-primary-600"><Edit2 :size="16" /></button>
        </div>
        <div class="flex gap-3">
          <div class="flex-1 rounded-xl bg-surface p-3 flex flex-col items-center justify-center text-center">
            <Droplets :size="20" class="text-red-500 mb-1.5" />
            <span class="text-[11px] text-ink-soft">Gol. Darah</span>
            <span class="font-display text-[15px] font-bold text-ink">{{ healthData.bloodType }}</span>
          </div>
          <div class="flex-1 rounded-xl bg-surface p-3 flex flex-col items-center justify-center text-center">
            <Activity :size="20" class="text-blue-500 mb-1.5" />
            <span class="text-[11px] text-ink-soft">Tinggi</span>
            <span class="font-display text-[15px] font-bold text-ink">{{ healthData.height }}</span>
          </div>
          <div class="flex-1 rounded-xl bg-surface p-3 flex flex-col items-center justify-center text-center">
            <Activity :size="20" class="text-orange-500 mb-1.5" />
            <span class="text-[11px] text-ink-soft">Berat</span>
            <span class="font-display text-[15px] font-bold text-ink">{{ healthData.weight }}</span>
          </div>
        </div>
      </div>

      <!-- Riwayat Medis -->
      <div class="mt-4 rounded-[1.25rem] bg-white p-5 shadow-soft">
        <div class="flex items-center justify-between mb-4 border-b border-line pb-3">
          <h2 class="font-display text-[15px] font-bold text-ink flex items-center gap-2">
            <FileText :size="18" class="text-primary-600" />
            Riwayat Medis
          </h2>
          <button class="text-primary-600 text-[12px] font-semibold flex items-center gap-1">
            <Plus :size="14" /> Tambah
          </button>
        </div>

        <div class="space-y-5">
          <!-- Alergi -->
          <div>
            <h3 class="text-[13px] font-bold text-ink-soft mb-2">Alergi Teridentifikasi</h3>
            <div class="flex flex-wrap gap-2">
              <span v-for="(item, i) in healthData.allergies" :key="i" class="rounded-lg bg-red-50 text-red-600 px-3 py-1.5 text-[12px] font-medium border border-red-100">
                {{ item }}
              </span>
            </div>
          </div>

          <!-- Kondisi Medis -->
          <div>
            <h3 class="text-[13px] font-bold text-ink-soft mb-2">Kondisi Medis & Penyakit Bawaan</h3>
            <div class="flex flex-col gap-2">
              <div v-for="(item, i) in healthData.conditions" :key="i" class="rounded-lg bg-surface px-3 py-2.5 text-[13px] font-medium text-ink flex items-center gap-2">
                <span class="flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-orange-100">
                  <span class="h-1.5 w-1.5 rounded-full bg-orange-500"></span>
                </span>
                {{ item }}
              </div>
            </div>
          </div>

          <!-- Obat Rutin -->
          <div>
            <h3 class="text-[13px] font-bold text-ink-soft mb-2 flex items-center gap-1.5">
              Obat yang Rutin Dikonsumsi
            </h3>
            <div class="flex flex-col gap-2">
              <div v-for="(item, i) in healthData.medications" :key="i" class="rounded-lg bg-surface px-3 py-2.5 text-[13px] font-medium text-ink flex items-center gap-2">
                <span class="flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-blue-100 text-blue-600">
                  <Pill :size="12" />
                </span>
                {{ item }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Sticky Update Button at Bottom -->
    <div class="sticky bottom-0 left-0 right-0 bg-cream/90 backdrop-blur-md border-t border-line p-5 mt-6">
      <button class="flex w-full items-center justify-center gap-2 rounded-xl bg-primary-600 py-3.5 text-[14px] font-bold text-white shadow-soft transition-colors hover:bg-primary-700">
        <Edit2 :size="18" />
        Perbarui Rekam Medis
      </button>
    </div>
  </div>
</template>
