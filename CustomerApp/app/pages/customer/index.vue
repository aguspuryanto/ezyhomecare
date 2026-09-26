<script setup lang="ts">
import { Baby, ChevronDown, Heart, Leaf, MapPin, Search, Sparkles, Stethoscope, User } from '@lucide/vue'
import { categories, services } from '~/data/dummy'

definePageMeta({ showBottomNav: true })

const { user } = useAuth()
const router = useRouter()

const categoryIcons: Record<string, any> = {
  Leaf,
  Sparkles,
  Stethoscope,
  Heart,
  Baby,
  User
}

const activeCategory = ref<string | null>(null)

const filteredServices = computed(() =>
  activeCategory.value ? services.filter((s) => s.categoryId === activeCategory.value) : services
)

function toggleCategory(id: string) {
  activeCategory.value = activeCategory.value === id ? null : id
}

const firstName = computed(() => user.value.name.split(' ')[0])
</script>

<template>
  <div class="pb-8">
    <div class="flex items-center gap-3 px-5 pb-2 pt-6">
      <div>
        <p class="text-[13px] text-ink-soft">Halo, {{ firstName }}</p>
        <button type="button" class="mt-0.5 flex items-center gap-1 text-[14px] font-bold text-ink">
          <MapPin :size="15" class="text-primary-600" :stroke-width="2" />
          Jl. Kenanga No. 12, Jaksel
          <ChevronDown :size="14" class="text-ink-soft" />
        </button>
      </div>
      <NuxtLink
        to="/customer/profile"
        aria-label="Profil"
        title="Profil"
        class="ml-auto flex h-10 w-10 items-center justify-center rounded-full bg-primary-600 font-display text-[13px] font-bold text-white"
      >
        {{ user.avatarInitials }}
      </NuxtLink>
    </div>

    <div class="px-5 pt-3">
      <div class="flex items-center gap-2 rounded-2xl bg-surface px-4 py-3 shadow-soft">
        <Search :size="18" class="text-ink-soft" :stroke-width="1.75" />
        <input
          type="text"
          placeholder="Cari layanan perawatan..."
          class="w-full bg-transparent text-[14px] text-ink outline-none placeholder:text-ink-soft/70"
        >
      </div>
    </div>

    <div class="px-5 pt-4">
      <div class="relative overflow-hidden rounded-card bg-primary-600 px-5 py-5">
        <div class="pointer-events-none absolute -right-6 -top-8 h-28 w-28 rounded-full bg-white/10" />
        <div class="pointer-events-none absolute -bottom-10 right-10 h-20 w-20 rounded-full bg-accent-500/30" />
        <p class="relative font-display text-[12px] font-bold uppercase tracking-wide text-primary-100">Promo Pengguna Baru</p>
        <p class="relative mt-1 font-display text-[18px] font-extrabold text-white">Diskon 20% Booking Pertama</p>
        <p class="relative mt-1 text-[12px] text-primary-100">Gunakan kode EZYNEW20 saat checkout</p>
      </div>
    </div>

    <div class="pt-5">
      <div class="flex items-center justify-between px-5">
        <h2 class="font-display text-[15px] font-bold text-ink">Kategori Layanan</h2>
      </div>
      <div class="mt-3 flex gap-4 overflow-x-auto px-5 pb-1">
        <button
          v-for="category in categories"
          :key="category.id"
          type="button"
          class="flex shrink-0 flex-col items-center gap-1.5"
          @click="toggleCategory(category.id)"
        >
          <span
            class="flex h-14 w-14 items-center justify-center rounded-2xl transition-colors"
            :class="activeCategory === category.id ? 'bg-primary-600 text-white' : 'bg-surface text-primary-600 shadow-soft'"
          >
            <component :is="categoryIcons[category.icon]" :size="22" :stroke-width="1.75" />
          </span>
          <span class="w-16 text-center text-[11px] font-medium leading-tight text-ink-soft">{{ category.name }}</span>
        </button>
      </div>
    </div>

    <div class="pt-5">
      <div class="flex items-center justify-between px-5">
        <h2 class="font-display text-[15px] font-bold text-ink">
          {{ activeCategory ? categories.find((c) => c.id === activeCategory)?.name : 'Layanan Populer' }}
        </h2>
        <button v-if="activeCategory" type="button" class="text-[12px] font-semibold text-primary-600" @click="activeCategory = null">
          Lihat Semua
        </button>
      </div>
      <div class="mt-3 flex flex-col gap-3 px-5">
        <ServiceCard v-for="service in filteredServices" :key="service.id" :service="service" />
      </div>
    </div>
  </div>
</template>
