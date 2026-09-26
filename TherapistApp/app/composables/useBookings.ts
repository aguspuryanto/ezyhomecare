import type { Booking, BookingStatus } from '~/data/dummy'
import { bookings as seedBookings } from '~/data/dummy'

const STATUS_FLOW: BookingStatus[] = ['terkonfirmasi', 'menuju_lokasi', 'tiba_lokasi', 'berlangsung', 'selesai']

export function useBookings() {
  const bookings = useState<Booking[]>('bookings', () => JSON.parse(JSON.stringify(seedBookings)))

  const incoming = computed(() => bookings.value.filter((b) => b.status === 'baru'))
  const todaySchedule = computed(() =>
    bookings.value.filter((b) => ['terkonfirmasi', 'menuju_lokasi', 'tiba_lokasi', 'berlangsung'].includes(b.status))
  )
  const history = computed(() => bookings.value.filter((b) => ['selesai', 'dibatalkan'].includes(b.status)))

  function getById(id: string) {
    return computed(() => bookings.value.find((b) => b.id === id) ?? null)
  }

  function acceptBooking(id: string) {
    const booking = bookings.value.find((b) => b.id === id)
    if (booking) booking.status = 'terkonfirmasi'
  }

  function rejectBooking(id: string) {
    const booking = bookings.value.find((b) => b.id === id)
    if (booking) booking.status = 'ditolak'
  }

  function nextStatusLabel(status: BookingStatus): string | null {
    switch (status) {
      case 'terkonfirmasi': return 'Mulai Menuju Lokasi'
      case 'menuju_lokasi': return 'Saya Tiba di Lokasi'
      case 'tiba_lokasi': return 'Mulai Sesi Terapi'
      case 'berlangsung': return 'Selesaikan Layanan'
      default: return null
    }
  }

  function advanceStatus(id: string) {
    const booking = bookings.value.find((b) => b.id === id)
    if (!booking) return
    const idx = STATUS_FLOW.indexOf(booking.status)
    if (idx === -1 || idx === STATUS_FLOW.length - 1) return
    booking.status = STATUS_FLOW[idx + 1]
  }

  function completeWithNotes(id: string, notes: string) {
    const booking = bookings.value.find((b) => b.id === id)
    if (!booking) return
    booking.serviceNotes = notes
    booking.status = 'selesai'
  }

  return {
    bookings,
    incoming,
    todaySchedule,
    history,
    getById,
    acceptBooking,
    rejectBooking,
    advanceStatus,
    nextStatusLabel,
    completeWithNotes
  }
}
