<script setup lang="ts">
import { AlertTriangle, Briefcase, Calendar, CheckCircle2, Clock, MapPin, Navigation, Phone, ShieldCheck, Star, Wallet } from '@lucide/vue'
import { formatIDR } from '~/data/dummy'

const { user } = useAuth()
// console.log('user', user.value)
const { incoming, todaySchedule, acceptBooking, rejectBooking } = useBookings()

const today = new Date().toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'short' })

function mapsUrl(address: string) {
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(address)}`
}

function telUrl(phone: string) {
  return `tel:${phone}`
}
</script>

<template>
  <div class="flex flex-col gap-5 px-5 pt-[18px] pb-6">
    <TopBar />

    <!-- Greeting -->
    <div class="flex items-start justify-between">
      <div class="flex items-center gap-3">
        <div class="flex h-[52px] w-[52px] items-center justify-center rounded-full border-2 border-white bg-gradient-to-br from-primary-container to-primary text-[16px] font-bold text-on-primary shadow-[0_2px_8px_rgba(0,104,93,0.15)]">
          {{ user.initials }}
        </div>
        <div class="flex flex-col gap-0.5">
          <div class="flex items-center gap-1.5">
            <span class="text-[18px] font-bold">Halo, {{ user.name }}</span>
            <ShieldCheck :size="15" class="text-primary" fill="currentColor" />
          </div>
          <span class="text-[13px] text-on-surface-variant">Area Siaga: {{ user.area }}<br>(Radius {{ user.radiusKm }} km)</span>
        </div>
      </div>
      <div class="mt-0.5 whitespace-nowrap rounded-lg border border-outline-variant/60 bg-surface-container-lowest px-2.5 py-1.5 text-xs font-semibold text-on-surface-variant capitalize">
        {{ today }}
      </div>
    </div>

    <!-- Stat row -->
    <div class="flex gap-2.5">
      <div class="flex flex-1 flex-col gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <div class="flex items-center gap-1.5 text-primary">
          <Calendar :size="15" :stroke-width="1.8" />
          <span class="text-[11px] font-semibold text-on-surface-variant">Booking</span>
        </div>
        <span class="text-[19px] font-bold">{{ todaySchedule.length }}</span>
        <span class="text-[11px] text-outline">Hari ini</span>
      </div>
      <div class="flex flex-1 flex-col gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <div class="flex items-center gap-1.5 text-primary">
          <Wallet :size="15" :stroke-width="1.8" />
          <span class="text-[11px] font-semibold text-on-surface-variant">Estimasi</span>
        </div>
        <span class="text-[19px] font-bold">{{ formatIDR(todaySchedule.reduce((sum, b) => sum + b.price * b.partnerSharePct, 0)) }}</span>
        <span class="text-[11px] text-outline">Pendapatan</span>
      </div>
      <div class="flex flex-1 flex-col gap-1.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-3 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
        <div class="flex items-center gap-1.5 text-secondary">
          <Star :size="14" fill="currentColor" stroke="none" />
          <span class="text-[11px] font-semibold text-on-surface-variant">Rating</span>
        </div>
        <span class="text-[19px] font-bold">{{ user.rating }}<span class="text-xs font-medium text-outline">/5.0</span></span>
        <span class="text-[11px] text-outline">{{ user.reviewCount }} Ulasan</span>
      </div>
    </div>

    <!-- Incoming order -->
    <div
      v-for="req in incoming"
      :key="req.id"
      class="overflow-hidden rounded-2xl border border-secondary-container/60 bg-surface-container-lowest shadow-[0_8px_20px_rgba(140,79,7,0.10)]"
    >
      <div class="flex items-center justify-between bg-secondary-container/20 px-4 py-2.5">
        <div class="flex items-center gap-1.5">
          <AlertTriangle :size="15" class="text-secondary" :stroke-width="1.9" />
          <span class="text-[13px] font-bold text-secondary">Pesanan Baru Masuk!</span>
        </div>
        <div class="flex items-center gap-1 rounded-lg bg-primary px-2.5 py-1 text-on-primary">
          <Clock :size="12" />
          <span class="text-xs font-bold">00:44</span>
        </div>
      </div>
      <div class="flex flex-col gap-3 px-4 pb-4 pt-3.5">
        <div class="flex items-start justify-between gap-2">
          <div class="flex flex-col gap-1">
            <div class="flex items-center gap-2">
              <span class="text-[16px] font-bold">{{ req.serviceName }}</span>
              <span v-if="req.serviceTag" class="rounded-lg bg-primary-container/15 px-2 py-0.5 text-[11px] font-semibold text-primary">{{ req.serviceTag }}</span>
            </div>
          </div>
          <span class="whitespace-nowrap text-[16px] font-bold text-primary">{{ formatIDR(req.price) }}</span>
        </div>
        <div class="flex items-center gap-2.5 rounded-xl bg-surface-container-low px-3 py-2.5">
          <div class="flex h-[34px] w-[34px] shrink-0 items-center justify-center rounded-full bg-primary-container text-[13px] font-bold text-on-primary-container">
            {{ req.customerName.split(' ').map(w => w[0]).slice(0, 2).join('') }}
          </div>
          <div class="flex flex-1 flex-col gap-px">
            <span class="text-[13px] font-bold">{{ req.customerName }}</span>
            <span class="text-[11px] text-outline">
              {{ req.isRegular ? `Pasien Reguler (Order ke-${req.orderCount})` : 'Pasien Baru' }}
            </span>
          </div>
          <div class="flex items-center gap-1 text-primary">
            <MapPin :size="12" :stroke-width="1.9" />
            <span class="text-xs font-semibold">{{ req.distanceKm }} km</span>
          </div>
        </div>
        <div class="flex flex-col gap-0.5">
          <div class="flex items-center gap-1.5 text-on-surface-variant">
            <MapPin :size="14" :stroke-width="1.8" />
            <span class="text-[12.5px]">{{ req.address }}</span>
          </div>
          <div class="flex items-center gap-1.5 text-on-surface-variant">
            <Clock :size="14" :stroke-width="1.8" />
            <span class="text-[12.5px]">Jadwal Penanganan: {{ req.dateLabel }}, {{ req.timeLabel }}</span>
          </div>
        </div>
        <div class="flex gap-2.5">
          <button
            type="button"
            class="h-[46px] flex-1 rounded-xl bg-surface-container text-sm font-semibold text-on-surface-variant"
            @click="rejectBooking(req.id)"
          >
            Tolak
          </button>
          <button
            type="button"
            class="flex h-[46px] flex-[2] items-center justify-center gap-1.5 rounded-xl bg-primary text-sm font-semibold text-on-primary"
            @click="acceptBooking(req.id)"
          >
            <CheckCircle2 :size="16" />
            Terima Pesanan
          </button>
        </div>
      </div>
    </div>

    <!-- Jadwal kunjungan -->
    <div class="flex flex-col gap-3">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-1.5">
          <Calendar :size="18" :stroke-width="1.8" />
          <span class="text-[16px] font-bold">Jadwal Kunjungan Hari Ini</span>
        </div>
        <span class="text-xs font-semibold text-primary">{{ todaySchedule.length }} Jadwal</span>
      </div>

      <p v-if="!todaySchedule.length" class="rounded-2xl border border-dashed border-outline-variant px-4 py-6 text-center text-sm text-outline">
        Belum ada jadwal kunjungan hari ini.
      </p>

      <NuxtLink
        v-for="item in todaySchedule"
        :key="item.id"
        :to="`/order/${item.id}`"
        class="flex flex-col gap-2.5 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]"
      >
        <div class="flex items-center justify-between">
          <span
            v-if="item.status === 'menuju_lokasi' || item.status === 'tiba_lokasi' || item.status === 'berlangsung'"
            class="flex items-center gap-1.5 rounded-lg bg-secondary-container/20 px-2.5 py-1 text-[11px] font-bold text-secondary"
          >
            <span class="inline-block h-1.5 w-1.5 rounded-full bg-secondary-container" />
            {{ item.status === 'menuju_lokasi' ? 'Menuju Lokasi' : item.status === 'tiba_lokasi' ? 'Tiba di Lokasi' : 'Sedang Berlangsung' }}
          </span>
          <span v-else class="rounded-lg bg-primary-container/15 px-2.5 py-1 text-[11px] font-bold text-primary">Terkonfirmasi</span>
          <span class="flex items-center gap-1 text-xs font-semibold text-on-surface-variant">
            <Clock :size="13" :stroke-width="1.8" />
            {{ item.timeLabel }}
          </span>
        </div>
        <span class="text-[15px] font-bold">{{ item.serviceName }}</span>
        <div class="flex items-center gap-1.5 text-[12.5px] text-on-surface-variant">
          <span class="font-semibold">{{ item.customerName }}</span>
          <span class="text-outline-variant">&bull;</span>
          <span>{{ item.customerNote ?? item.address }}</span>
        </div>

        <template v-if="item.status === 'menuju_lokasi' || item.status === 'tiba_lokasi'">
          <div class="flex items-center gap-1.5 text-[12.5px] text-on-surface-variant">
            <MapPin :size="14" :stroke-width="1.8" />
            {{ item.address }}
            <span class="font-semibold text-primary">{{ item.distanceKm }} km<template v-if="item.travelMinutes"> ({{ item.travelMinutes }} mnt)</template></span>
          </div>
          <div class="flex gap-2.5">
            <a
              :href="mapsUrl(item.address)"
              target="_blank"
              rel="noopener"
              class="flex h-[44px] flex-1 items-center justify-center gap-1.5 rounded-xl bg-primary text-[13.5px] font-semibold text-on-primary"
              @click.stop
            >
              <Navigation :size="15" />
              Buka Navigasi
            </a>
            <a
              :href="telUrl(item.customerPhone)"
              class="flex h-[44px] flex-1 items-center justify-center gap-1.5 rounded-xl border border-outline-variant bg-surface-container-lowest text-[13.5px] font-semibold text-primary"
              @click.stop
            >
              <Phone :size="15" />
              Hubungi Pasien
            </a>
          </div>
        </template>
        <div v-else-if="item.customerNote" class="rounded-lg bg-surface-container-low px-2.5 py-2 text-xs text-on-surface-variant">
          {{ item.customerNote }}
        </div>
      </NuxtLink>
    </div>

    <!-- SOP -->
    <div class="flex flex-col gap-3 rounded-2xl border border-outline-variant/60 bg-surface-container-lowest p-4 shadow-[0_4px_12px_rgba(22,135,122,0.06)]">
      <div class="flex items-center gap-2.5">
        <div class="flex h-[34px] w-[34px] shrink-0 items-center justify-center rounded-[10px] bg-primary-container/15">
          <ShieldCheck :size="18" class="text-primary" :stroke-width="1.9" />
        </div>
        <div class="flex flex-col">
          <span class="text-[15px] font-bold">SOP Sterilisasi &amp; Kit Terapis</span>
          <span class="text-[11.5px] font-semibold text-primary">Standar Higienitas CareHome Medika</span>
        </div>
      </div>

      <div class="flex flex-col gap-3">
        <div v-for="tip in [
          { title: 'Kop Bekam Sekali Pakai (Disposable)', desc: 'Pastikan segel steril dibuka langsung di depan pasien.' },
          { title: 'Minyak Zaitun Murni & Antiseptik Alkohol 70%', desc: 'Kemasan botol steril dan sarung tangan nitril non-powder.' },
          { title: 'Lancing Device & Jarum Steril Baru', desc: 'Buang jarum bekas langsung ke Sharp Biohazard Container.' }
        ]" :key="tip.title" class="flex gap-2.5">
          <CheckCircle2 :size="18" class="mt-px shrink-0 text-primary" :stroke-width="2.1" />
          <div class="flex flex-col gap-0.5">
            <span class="text-[13.5px] font-bold">{{ tip.title }}</span>
            <span class="text-xs text-on-surface-variant">{{ tip.desc }}</span>
          </div>
        </div>
      </div>

      <div class="flex items-start gap-2 rounded-lg bg-surface-container-low px-3 py-2.5">
        <Briefcase :size="15" class="mt-px shrink-0 text-primary" :stroke-width="1.9" />
        <span class="text-xs leading-relaxed text-on-surface-variant">Patuhi etika penanganan medis untuk menjaga kepercayaan dan keselamatan pasien.</span>
      </div>
    </div>
  </div>
</template>
