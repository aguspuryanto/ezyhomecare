export type Category = {
  id: string
  name: string
  icon: string
  gradientFrom: string
  gradientTo: string
}

export type Service = {
  id: string
  categoryId: string
  name: string
  shortDesc: string
  description: string
  price: number
  duration: number // minutes
  rating: number
  reviewCount: number
  benefits: string[]
  includes: string[]
}

export type Therapist = {
  id: string
  name: string
  photo: string
  rating: number
  reviewCount: number
  experienceYears: number
  distanceKm: number
  verified: boolean
  availableToday: boolean
  specialties: string[]
  bio: string
}

export type Address = {
  id: string
  label: 'Rumah' | 'Kantor' | 'Lainnya'
  recipient: string
  phone: string
  fullAddress: string
  detail: string
  isDefault: boolean
}

export type PaymentMethod = {
  id: string
  name: string
  type: 'qris' | 'ewallet' | 'card' | 'cash'
  subtitle: string
}

export type BookingHistoryItem = {
  id: string
  serviceName: string
  therapistName: string
  date: string
  time: string
  status: 'selesai' | 'dibatalkan' | 'berlangsung'
  price: number
  ratingGiven?: number
}

export const currentUser = {
  name: 'Agus Pratama',
  email: 'agus@suryasoft.com',
  phone: '+62 812-3456-7890',
  avatarInitials: 'AP'
}

export const categories: Category[] = [
  { id: 'relaksasi', name: 'Pijat Relaksasi', icon: 'Leaf', gradientFrom: '#3D8A70', gradientTo: '#1B4B3D' },
  { id: 'refleksi', name: 'Pijat Refleksi', icon: 'Sparkles', gradientFrom: '#6BAF95', gradientTo: '#2F7A63' },
  { id: 'fisioterapi', name: 'Fisioterapi', icon: 'Stethoscope', gradientFrom: '#3D6B8A', gradientTo: '#1F3C50' },
  { id: 'lansia', name: 'Perawatan Lansia', icon: 'Heart', gradientFrom: '#9C7A4F', gradientTo: '#5C4630' },
  { id: 'bayi', name: 'Baby Spa', icon: 'Baby', gradientFrom: '#E8A489', gradientTo: '#D97A5C' },
  { id: 'prenatal', name: 'Pijat Prenatal', icon: 'User', gradientFrom: '#B98BB0', gradientTo: '#83568B' }
]

export const services: Service[] = [
  {
    id: 'relaksasi-90',
    categoryId: 'relaksasi',
    name: 'Pijat Relaksasi Penuh Tubuh',
    shortDesc: 'Redakan pegal dan lelah dengan pijat relaksasi menyeluruh',
    description:
      'Layanan pijat relaksasi menyeluruh yang dirancang untuk meredakan ketegangan otot, memperlancar peredaran darah, dan mengembalikan energi setelah hari yang panjang. Dilakukan oleh terapis bersertifikat langsung di rumah Anda.',
    price: 175000,
    duration: 90,
    rating: 4.9,
    reviewCount: 482,
    benefits: ['Meredakan pegal & nyeri otot', 'Melancarkan peredaran darah', 'Mengurangi stres'],
    includes: ['Terapis bersertifikat', 'Minyak pijat aromaterapi', 'Alas & handuk bersih', 'Alat dibawa terapis']
  },
  {
    id: 'refleksi-60',
    categoryId: 'refleksi',
    name: 'Pijat Refleksi Kaki & Tangan',
    shortDesc: 'Titik refleksi untuk relaksasi tubuh secara menyeluruh',
    description:
      'Terapi titik refleksi pada telapak kaki dan tangan yang dipercaya membantu melancarkan aliran energi tubuh, meredakan kelelahan, dan meningkatkan kualitas tidur.',
    price: 120000,
    duration: 60,
    rating: 4.8,
    reviewCount: 356,
    benefits: ['Melancarkan sirkulasi', 'Meningkatkan kualitas tidur', 'Relaksasi cepat'],
    includes: ['Terapis berpengalaman', 'Minyak esensial', 'Alas duduk ergonomis']
  },
  {
    id: 'fisio-60',
    categoryId: 'fisioterapi',
    name: 'Fisioterapi Pemulihan Cedera',
    shortDesc: 'Penanganan cedera & nyeri sendi oleh fisioterapis profesional',
    description:
      'Sesi fisioterapi rumah untuk pemulihan pasca cedera, nyeri sendi, atau pasca operasi ringan. Ditangani oleh fisioterapis berlisensi dengan pendekatan yang disesuaikan kondisi Anda.',
    price: 250000,
    duration: 60,
    rating: 4.9,
    reviewCount: 214,
    benefits: ['Pemulihan cedera lebih cepat', 'Mengurangi nyeri sendi', 'Program latihan personal'],
    includes: ['Fisioterapis berlisensi', 'Peralatan terapi portable', 'Laporan perkembangan']
  },
  {
    id: 'lansia-120',
    categoryId: 'lansia',
    name: 'Perawatan Harian Lansia',
    shortDesc: 'Pendampingan & perawatan lembut untuk orang tua tercinta',
    description:
      'Layanan pendampingan dan perawatan dasar untuk lansia di rumah, meliputi bantuan mobilitas, kebersihan diri, dan pemantauan kondisi kesehatan umum dengan penuh kesabaran.',
    price: 220000,
    duration: 120,
    rating: 4.9,
    reviewCount: 178,
    benefits: ['Pendamping berpengalaman', 'Pemantauan kesehatan dasar', 'Bantuan mobilitas'],
    includes: ['Perawat terlatih lansia', 'Laporan kondisi harian', 'Peralatan bantu dasar']
  },
  {
    id: 'bayi-45',
    categoryId: 'bayi',
    name: 'Baby Spa & Pijat Bayi',
    shortDesc: 'Stimulasi tumbuh kembang bayi lewat pijat lembut',
    description:
      'Sesi baby spa dan pijat lembut untuk membantu stimulasi tumbuh kembang, meningkatkan kualitas tidur, dan mempererat bonding orang tua dan bayi.',
    price: 150000,
    duration: 45,
    rating: 5.0,
    reviewCount: 302,
    benefits: ['Stimulasi tumbuh kembang', 'Tidur lebih nyenyak', 'Bonding orang tua & bayi'],
    includes: ['Terapis bersertifikat baby spa', 'Perlengkapan mandi bayi', 'Minyak bayi hipoalergenik']
  },
  {
    id: 'prenatal-60',
    categoryId: 'prenatal',
    name: 'Pijat Prenatal Ibu Hamil',
    shortDesc: 'Pijat aman & lembut khusus untuk ibu hamil',
    description:
      'Pijat khusus ibu hamil dengan teknik aman untuk meredakan nyeri punggung, kaki bengkak, dan kecemasan menjelang persalinan. Posisi pijat disesuaikan usia kandungan.',
    price: 160000,
    duration: 60,
    rating: 4.8,
    reviewCount: 198,
    benefits: ['Meredakan nyeri punggung', 'Mengurangi bengkak kaki', 'Menenangkan pikiran'],
    includes: ['Terapis bersertifikat prenatal', 'Bantal kehamilan', 'Minyak pijat aman kehamilan']
  }
]

export const therapists: Therapist[] = [
  {
    id: 'th-1',
    name: 'Sri Wahyuni',
    photo: 'https://i.pravatar.cc/150?img=47',
    rating: 4.9,
    reviewCount: 312,
    experienceYears: 6,
    distanceKm: 1.2,
    verified: true,
    availableToday: true,
    specialties: ['Relaksasi', 'Refleksi'],
    bio: 'Terapis berpengalaman dengan spesialisasi pijat relaksasi dan refleksi selama 6 tahun.'
  },
  {
    id: 'th-2',
    name: 'Budi Santoso',
    photo: 'https://i.pravatar.cc/150?img=12',
    rating: 4.8,
    reviewCount: 264,
    experienceYears: 5,
    distanceKm: 2.4,
    verified: true,
    availableToday: true,
    specialties: ['Fisioterapi', 'Relaksasi'],
    bio: 'Fisioterapis berlisensi, fokus pada pemulihan cedera dan nyeri otot kronis.'
  },
  {
    id: 'th-3',
    name: 'Nur Aisyah',
    photo: 'https://i.pravatar.cc/150?img=32',
    rating: 5.0,
    reviewCount: 189,
    experienceYears: 4,
    distanceKm: 0.8,
    verified: true,
    availableToday: false,
    specialties: ['Prenatal', 'Baby Spa'],
    bio: 'Spesialis pijat prenatal dan baby spa, bersertifikat resmi dari asosiasi terapis Indonesia.'
  },
  {
    id: 'th-4',
    name: 'Dewi Lestari',
    photo: 'https://i.pravatar.cc/150?img=45',
    rating: 4.7,
    reviewCount: 156,
    experienceYears: 8,
    distanceKm: 3.6,
    verified: true,
    availableToday: true,
    specialties: ['Perawatan Lansia', 'Relaksasi'],
    bio: 'Perawat lansia berpengalaman 8 tahun dengan pendekatan yang sabar dan penuh perhatian.'
  }
]

export const initialAddresses: Address[] = [
  {
    id: 'addr-1',
    label: 'Rumah',
    recipient: 'Agus Pratama',
    phone: '+62 812-3456-7890',
    fullAddress: 'Jl. Kenanga No. 12, Kebayoran Baru, Jakarta Selatan',
    detail: 'Pagar hitam, sebelah minimarket',
    isDefault: true
  },
  {
    id: 'addr-2',
    label: 'Kantor',
    recipient: 'Agus Pratama',
    phone: '+62 812-3456-7890',
    fullAddress: 'Menara Suryasoft Lt. 8, Jl. Sudirman Kav. 25, Jakarta Pusat',
    detail: 'Lobi utama, resepsionis lantai 8',
    isDefault: false
  }
]

export const paymentMethods: PaymentMethod[] = [
  { id: 'qris', name: 'QRIS', type: 'qris', subtitle: 'Bayar dengan scan QR' },
  { id: 'ewallet', name: 'E-Wallet', type: 'ewallet', subtitle: 'GoPay, OVO, DANA' },
  { id: 'card', name: 'Kartu Kredit/Debit', type: 'card', subtitle: 'Visa, Mastercard' },
  { id: 'cash', name: 'Bayar di Tempat', type: 'cash', subtitle: 'Tunai ke terapis' }
]

export const promoCodes: Record<string, { discount: number; label: string }> = {
  EZYNEW20: { discount: 0.2, label: 'Diskon 20% pengguna baru' },
  EZYHEMAT10: { discount: 0.1, label: 'Diskon 10% booking hemat' }
}

export const bookingHistory: BookingHistoryItem[] = [
  {
    id: 'EHC-240815-01',
    serviceName: 'Pijat Relaksasi Penuh Tubuh',
    therapistName: 'Sri Wahyuni',
    date: '15 Agustus 2026',
    time: '14:00',
    status: 'selesai',
    price: 175000,
    ratingGiven: 5
  },
  {
    id: 'EHC-240722-01',
    serviceName: 'Fisioterapi Pemulihan Cedera',
    therapistName: 'Budi Santoso',
    date: '22 Juli 2026',
    time: '10:00',
    status: 'selesai',
    price: 250000,
    ratingGiven: 4
  },
  {
    id: 'EHC-240630-01',
    serviceName: 'Pijat Refleksi Kaki & Tangan',
    therapistName: 'Sri Wahyuni',
    date: '30 Juni 2026',
    time: '16:30',
    status: 'dibatalkan',
    price: 120000
  },
  {
    id: 'EHC-240602-01',
    serviceName: 'Baby Spa & Pijat Bayi',
    therapistName: 'Nur Aisyah',
    date: '02 Juni 2026',
    time: '09:00',
    status: 'selesai',
    price: 150000,
    ratingGiven: 5
  }
]

export function formatIDR(value: number): string {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
}
