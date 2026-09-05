import type { Address, BookingHistoryItem, PaymentMethod, Service, Therapist } from '~/data/dummy'
import { bookingHistory, initialAddresses } from '~/data/dummy'

export type BookingFlowState = {
  service: Service | null
  therapist: Therapist | null
  date: string | null
  dateLabel: string | null
  time: string | null
  notes: string
  address: Address | null
  payment: PaymentMethod | null
  promoCode: string | null
  promoDiscount: number
  bookingId: string | null
}

function createEmptyFlow(): BookingFlowState {
  return {
    service: null,
    therapist: null,
    date: null,
    dateLabel: null,
    time: null,
    notes: '',
    address: null,
    payment: null,
    promoCode: null,
    promoDiscount: 0,
    bookingId: null
  }
}

export function useBookingFlow() {
  const flow = useState<BookingFlowState>('booking-flow', createEmptyFlow)
  const addresses = useState<Address[]>('booking-addresses', () => [...initialAddresses])
  const history = useState<BookingHistoryItem[]>('booking-history', () => [...bookingHistory])

  function resetFlow() {
    flow.value = createEmptyFlow()
  }

  function addAddress(address: Address) {
    addresses.value.push(address)
  }

  function addHistoryEntry(entry: BookingHistoryItem) {
    history.value.unshift(entry)
  }

  return { flow, addresses, history, resetFlow, addAddress, addHistoryEntry }
}
