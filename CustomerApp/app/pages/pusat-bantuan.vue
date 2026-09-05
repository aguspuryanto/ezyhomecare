<script setup lang="ts">
import { Send, Phone, ChevronRight } from '@lucide/vue'
import { ref, nextTick } from 'vue'

definePageMeta({ showBottomNav: false })

const messages = ref([
  { id: 1, sender: 'cs', text: 'Halo Agus! Selamat datang di Pusat Bantuan EzyHomeCare.', time: '10:00' },
  { id: 2, sender: 'cs', text: 'Ada yang bisa kami bantu hari ini terkait layanan atau jadwal terapi Anda?', time: '10:00' },
  { id: 3, sender: 'user', text: 'Halo, saya ingin bertanya tentang cara mengubah jadwal fisioterapi yang sudah dipesan.', time: '10:05' },
  { id: 4, sender: 'cs', text: 'Tentu. Anda bisa masuk ke menu "Riwayat", pilih pesanan yang sedang "Berlangsung", lalu klik tombol "Ubah Jadwal". Mohon pastikan perubahan dilakukan minimal 4 jam sebelum jadwal awal ya.', time: '10:06' },
])

const newMessage = ref('')
const chatContainer = ref<HTMLElement | null>(null)

const scrollToBottom = async () => {
  await nextTick()
  if (chatContainer.value) {
    chatContainer.value.scrollTop = chatContainer.value.scrollHeight
  }
}

function sendMessage() {
  if (!newMessage.value.trim()) return
  messages.value.push({
    id: Date.now(),
    sender: 'user',
    text: newMessage.value,
    time: new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
  })
  newMessage.value = ''
  scrollToBottom()
  
  // Simulate reply
  setTimeout(() => {
    messages.value.push({
      id: Date.now(),
      sender: 'cs',
      text: 'Baik, kami sedang memproses pertanyaan Anda. Mohon tunggu sebentar ya, agen kami akan segera membalas.',
      time: new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
    })
    scrollToBottom()
  }, 1000)
}
</script>

<template>
  <div class="flex h-[100dvh] md:h-[880px] flex-col bg-[#F8F9FA]">
    <TopBar title="Pusat Bantuan" :back="true">
      <template #right>
        <button class="flex items-center justify-center h-9 w-9 rounded-full bg-[#25D366]/10 text-[#25D366]">
          <Phone :size="18" />
        </button>
      </template>
    </TopBar>

    <!-- WhatsApp Banner -->
    <a href="#" class="flex items-center gap-3 bg-[#25D366] px-5 py-3 text-white transition-colors hover:bg-[#20bd5a]">
      <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-white/20">
        <Phone :size="20" class="fill-current" />
      </div>
      <div class="flex-1 min-w-0">
        <p class="font-display text-[14px] font-bold">Layanan Darurat WhatsApp</p>
        <p class="text-[12px] text-white/90">Hubungi langsung via WhatsApp 24 Jam</p>
      </div>
      <ChevronRight :size="18" class="text-white/80" />
    </a>

    <!-- Chat Messages -->
    <div ref="chatContainer" class="flex-1 overflow-y-auto px-5 py-4 space-y-4">
      <div class="flex justify-center mb-6">
        <span class="rounded-full bg-surface px-3 py-1 text-[11px] font-medium text-ink-soft shadow-sm border border-line">
          Hari Ini
        </span>
      </div>

      <div v-for="msg in messages" :key="msg.id" class="flex flex-col" :class="msg.sender === 'user' ? 'items-end' : 'items-start'">
        <div class="flex items-end gap-2 max-w-[85%]">
          <div v-if="msg.sender === 'cs'" class="shrink-0 h-8 w-8 rounded-full bg-primary-100 flex items-center justify-center overflow-hidden">
            <span class="text-[10px] font-bold text-primary-700">CS</span>
          </div>
          
          <div class="rounded-[1.25rem] px-4 py-3 shadow-sm" :class="msg.sender === 'user' ? 'bg-primary-600 text-white rounded-br-sm' : 'bg-white text-ink rounded-bl-sm'">
            <p class="text-[13.5px] leading-relaxed">{{ msg.text }}</p>
            <p class="mt-1 text-[10px] text-right" :class="msg.sender === 'user' ? 'text-primary-100' : 'text-ink-soft'">
              {{ msg.time }}
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Chat Input -->
    <div class="bg-white p-4 border-t border-line" style="padding-bottom: env(safe-area-inset-bottom)">
      <form @submit.prevent="sendMessage" class="flex items-center gap-2 rounded-full bg-surface px-4 py-2 shadow-sm border border-line focus-within:border-primary-500 transition-colors">
        <input 
          v-model="newMessage"
          type="text" 
          placeholder="Ketik pesan Anda..." 
          class="flex-1 bg-transparent py-2 text-[14px] text-ink outline-none placeholder:text-ink-soft"
        >
        <button 
          type="submit" 
          class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-primary-600 text-white transition-transform active:scale-90"
          :class="{ 'opacity-50 pointer-events-none': !newMessage.trim() }"
        >
          <Send :size="18" class="-ml-0.5" />
        </button>
      </form>
    </div>
  </div>
</template>
