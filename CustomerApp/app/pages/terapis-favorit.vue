<script setup lang="ts">
import { computed } from 'vue'
import { therapists } from '~/data/dummy'
import { Star, MapPin, Heart, BadgeCheck, Clock } from '@lucide/vue'

definePageMeta({ showBottomNav: false })

// Simulasi mengambil terapis favorit (misalnya 3 terapis pertama)
const favoriteTherapists = computed(() => therapists.slice(0, 3))
</script>

<template>
  <div class="flex min-h-full flex-col pb-6 bg-cream-soft">
    <TopBar title="Terapis Favorit" :back="true" />

    <div class="flex-1 flex flex-col gap-4 px-5 pt-4">
      <div v-for="therapist in favoriteTherapists" :key="therapist.id" class="relative overflow-hidden rounded-[1.25rem] bg-white p-4 shadow-soft">
        <!-- Favorite Icon -->
        <button class="absolute right-4 top-4 text-red-500 transition-transform active:scale-90">
          <Heart :size="20" class="fill-current" />
        </button>

        <div class="flex gap-4">
          <div class="relative h-20 w-20 shrink-0">
            <img :src="therapist.photo" :alt="therapist.name" class="h-full w-full rounded-2xl object-cover" />
            <div v-if="therapist.verified" class="absolute -bottom-2 -right-2 flex h-6 w-6 items-center justify-center rounded-full bg-white text-blue-500 shadow-sm">
              <BadgeCheck :size="20" class="fill-current text-white" />
            </div>
          </div>
          
          <div class="flex-1 min-w-0">
            <h3 class="font-display text-[15px] font-bold text-ink truncate pr-6">{{ therapist.name }}</h3>
            
            <div class="mt-1 flex items-center gap-1.5 text-[12px] font-medium text-ink-soft">
              <Star :size="12" class="fill-orange-400 text-orange-400" />
              <span>{{ therapist.rating }} ({{ therapist.reviewCount }})</span>
              <span class="mx-0.5 text-line">&middot;</span>
              <span>{{ therapist.experienceYears }}thn Pengalaman</span>
            </div>

            <div class="mt-1.5 flex items-center gap-1 text-[11px] text-ink-soft">
              <MapPin :size="12" />
              {{ therapist.distanceKm }} km dari lokasi Anda
            </div>
            
            <div class="mt-2.5 flex flex-wrap gap-1.5">
              <span v-for="spec in therapist.specialties" :key="spec" class="rounded-md bg-primary-50 px-2 py-0.5 text-[10px] font-bold text-primary-700">
                {{ spec }}
              </span>
            </div>
          </div>
        </div>

        <div class="mt-4 flex items-center justify-between border-t border-line pt-3">
          <div class="flex items-center gap-1.5 text-[12px] font-bold" :class="therapist.availableToday ? 'text-[#00AA13]' : 'text-orange-500'">
            <Clock :size="14" />
            {{ therapist.availableToday ? 'Tersedia Hari Ini' : 'Penuh Hari Ini' }}
          </div>
          
          <button class="rounded-xl bg-primary-600 px-5 py-1.5 text-[12px] font-bold text-white shadow-sm transition-transform active:scale-95">
            Booking
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
