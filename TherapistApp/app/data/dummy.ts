export type BookingStatus =
  | 'baru'
  | 'terkonfirmasi'
  | 'menuju_lokasi'
  | 'tiba_lokasi'
  | 'berlangsung'
  | 'selesai'
  | 'ditolak'
  | 'dibatalkan'

export type Booking = {
  id: string
  serviceName: string
  serviceTag?: string
  duration: number // minutes
  price: number
  partnerSharePct: number
  customerName: string
  customerPhone: string
  customerNote?: string
  address: string
  distanceKm: number
  travelMinutes?: number
  dateLabel: string
  timeLabel: string
  status: BookingStatus
  isRegular?: boolean
  orderCount?: number
  ratingGiven?: number
  reviewText?: string
  serviceNotes?: string
  cancelCompensation?: number
}

export type ServiceOffering = {
  id: string
  name: string
  price: number
  partnerSharePct: number
  active: boolean
}

export type Transaction = {
  id: string
  label: string
  timestamp: string
  amount: number
  kind: 'income' | 'withdrawal' | 'tip'
}

export type ScheduleDay = {
  day: string
  active: boolean
  start: string
  end: string
}

export const services: ServiceOffering[] = [
  { id: 'bekam-sunnah', name: 'Bekam Sunnah Medis', price: 175000, partnerSharePct: 0.8, active: true },
  { id: 'bekam-premium', name: 'Bekam Premium & Akupresur', price: 250000, partnerSharePct: 0.8, active: true },
  { id: 'refleksi-relaksasi', name: 'Pijat Refleksi Relaksasi', price: 150000, partnerSharePct: 0.8, active: false }
]

export const bookings: Booking[] = [
  {
    id: 'BK-10240',
    serviceName: 'Bekam Sunnah Medis',
    serviceTag: '60 Mnt',
    duration: 60,
    price: 175000,
    partnerSharePct: 0.8,
    customerName: 'Budi Santoso',
    customerPhone: '+6281234567890',
    address: 'Jl. Dharmahusada Indah No. 42',
    distanceKm: 2.4,
    dateLabel: 'Hari Ini',
    timeLabel: '16:30 WIB',
    status: 'baru',
    isRegular: true,
    orderCount: 4
  },
  {
    id: 'BK-10231',
    serviceName: 'Bekam Sunnah (10 Titik Medis)',
    duration: 90,
    price: 175000,
    partnerSharePct: 0.8,
    customerName: 'Agus Supriyadi',
    customerPhone: '+6281298765432',
    customerNote: 'Keluhan: Nyeri Leher & Punggung',
    address: 'Komplek Mediterania Blok C-12',
    distanceKm: 1.8,
    travelMinutes: 6,
    dateLabel: 'Hari Ini',
    timeLabel: '14:00 - 15:30 WIB',
    status: 'menuju_lokasi'
  },
  {
    id: 'BK-10233',
    serviceName: 'Pijat Refleksi Relaksasi',
    duration: 90,
    price: 150000,
    partnerSharePct: 0.8,
    customerName: 'Hendra K.',
    customerPhone: '+6281355566677',
    customerNote: 'Permintaan Tambahan: Minyak Lavender & Lembut',
    address: 'Jl. Manyar Kertoarjo No. 88',
    distanceKm: 3.1,
    dateLabel: 'Hari Ini',
    timeLabel: '19:00 - 20:30 WIB',
    status: 'terkonfirmasi'
  },
  {
    id: 'BK-10198',
    serviceName: 'Bekam Premium & Akupresur',
    duration: 60,
    price: 250000,
    partnerSharePct: 0.8,
    customerName: 'Siti Aminah',
    customerPhone: '+6281300011122',
    address: 'Jl. Manyar Kertoarjo No. 88',
    distanceKm: 2.0,
    dateLabel: '2 Sep 2026',
    timeLabel: '11:00 WIB',
    status: 'selesai',
    ratingGiven: 4,
    reviewText: 'Ruang keluhan ditangani dengan hati-hati.',
    serviceNotes: 'Kondisi pasien stabil, dilakukan 8 titik bekam di area punggung atas. Tidak ada reaksi alergi terhadap minyak zaitun.'
  },
  {
    id: 'BK-10180',
    serviceName: 'Pijat Refleksi Relaksasi',
    duration: 60,
    price: 150000,
    partnerSharePct: 0.8,
    customerName: 'Hendra K.',
    customerPhone: '+6281355566677',
    address: 'Jl. Manyar Kertoarjo No. 88',
    distanceKm: 3.1,
    dateLabel: '30 Agu 2026',
    timeLabel: '10:00 WIB',
    status: 'dibatalkan',
    cancelCompensation: 35000
  }
]

export const transactions: Transaction[] = [
  { id: 'tx-1', label: 'Bagi Hasil • Order #BK-10231', timestamp: '4 Sep 2026, 17:40', amount: 140000, kind: 'income' },
  { id: 'tx-2', label: 'Bagi Hasil • Order #BK-10198', timestamp: '2 Sep 2026, 11:05', amount: 200000, kind: 'income' },
  { id: 'tx-3', label: 'Penarikan • ke BCA •••4521', timestamp: '1 Sep 2026, 09:20', amount: -1000000, kind: 'withdrawal' },
  { id: 'tx-4', label: 'Tip • dari Budi Santoso', timestamp: '4 Sep 2026, 17:42', amount: 25000, kind: 'tip' }
]

export const initialSchedule: ScheduleDay[] = [
  { day: 'Senin', active: true, start: '08:00', end: '20:00' },
  { day: 'Selasa', active: true, start: '08:00', end: '20:00' },
  { day: 'Rabu', active: true, start: '08:00', end: '20:00' },
  { day: 'Kamis', active: true, start: '08:00', end: '20:00' },
  { day: 'Jumat', active: true, start: '08:00', end: '20:00' },
  { day: 'Sabtu', active: true, start: '09:00', end: '17:00' },
  { day: 'Minggu', active: false, start: '09:00', end: '17:00' }
]

export function formatIDR(value: number): string {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
}
