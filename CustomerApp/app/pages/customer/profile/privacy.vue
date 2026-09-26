<script setup lang="ts">
import { Shield, Lock, FileText, Database, UserCheck, CheckCircle2 } from '@lucide/vue'

definePageMeta({ showBottomNav: false })

const policies = [
  {
    icon: Lock,
    title: 'Keamanan Enkripsi End-to-End',
    desc: 'Semua data rekam medis Anda dienkripsi dengan standar keamanan tinggi AES-256 baik saat disimpan maupun saat sedang dikirimkan.'
  },
  {
    icon: Database,
    title: 'Penyimpanan Data Terisolasi',
    desc: 'Data kesehatan dan riwayat penyakit Anda disimpan dalam server terisolasi yang mematuhi pedoman keamanan informasi Kemenkes RI.'
  },
  {
    icon: UserCheck,
    title: 'Akses Terbatas Terhadap Terapis',
    desc: 'Terapis hanya dapat melihat sebagian rekam medis Anda yang relevan selama sesi berlangsung, dan akses akan dicabut otomatis setelah terapi selesai.'
  },
  {
    icon: FileText,
    title: 'Tidak Ada Jual Beli Data Pribadi',
    desc: 'EzyHomeCare berkomitmen penuh untuk menjaga kerahasiaan Anda. Kami tidak akan menjual atau membagikan data medis kepada pihak ketiga manapun.'
  }
]
</script>

<template>
  <div class="flex min-h-full flex-col pb-6 bg-cream-soft">
    <TopBar title="Kebijakan Privasi" :back="true" />

    <div class="flex-1 overflow-y-auto px-5 pt-4">
      <!-- Badge / Hero Info -->
      <div class="relative overflow-hidden rounded-[1.25rem] bg-gradient-to-br from-primary-600 to-primary-800 p-6 text-center shadow-soft">
        <div class="pointer-events-none absolute -right-6 -top-8 h-28 w-28 rounded-full bg-white/10" />
        <div class="pointer-events-none absolute -bottom-10 -left-10 h-28 w-28 rounded-full bg-white/10" />
        
        <div class="relative flex justify-center mb-3">
          <div class="flex h-14 w-14 items-center justify-center rounded-full bg-white/20 backdrop-blur-sm border border-white/30 text-white">
            <Shield :size="28" class="fill-current text-white/90" />
          </div>
        </div>
        
        <h2 class="relative font-display text-[18px] font-bold text-white mb-2">HIPAA Compliant Standard</h2>
        <p class="relative text-[12.5px] text-primary-100 leading-relaxed">
          Platform EzyHomeCare dirancang dan diaudit untuk mematuhi undang-undang perlindungan data medis terketat, menjamin keamanan privasi dari setiap rekam medis yang Anda masukkan.
        </p>
      </div>

      <!-- Policy Items -->
      <div class="mt-6 space-y-4">
        <div v-for="(policy, index) in policies" :key="index" class="flex gap-4 rounded-[1.25rem] bg-white p-4 shadow-sm border border-line/50">
          <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-primary-50 text-primary-600">
            <component :is="policy.icon" :size="22" />
          </div>
          <div>
            <h3 class="font-display text-[14px] font-bold text-ink mb-1">{{ policy.title }}</h3>
            <p class="text-[12px] text-ink-soft leading-relaxed">{{ policy.desc }}</p>
          </div>
        </div>
      </div>
      
      <div class="mt-8 mb-6 text-center">
        <p class="flex items-center justify-center gap-1.5 text-[12px] font-bold text-ink mb-2">
          <CheckCircle2 :size="16" class="text-green-600" /> Diverifikasi & Disetujui
        </p>
        <p class="text-[11px] text-ink-soft max-w-[280px] mx-auto leading-relaxed">
          Pembaruan Terakhir: 1 September 2026<br>
          Untuk informasi lebih lanjut tentang hak privasi Anda, silakan hubungi tim DPO kami di <span class="font-semibold text-primary-600">dpo@ezyhomecare.com</span>
        </p>
      </div>
    </div>
  </div>
</template>
