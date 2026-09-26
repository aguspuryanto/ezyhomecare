import type { Session } from '@supabase/supabase-js'

export type VerificationStatus = 'pending' | 'approved' | 'rejected' | 'suspended'

export type TherapistUser = {
  name: string
  initials: string
  phone: string | null
  licenseNo: string | null
  area: string | null
  radiusKm: number
  specialties: string[]
  completedSessions: number
  onTimePct: number | null
  sopViolations: number
  rating: number
  reviewCount: number
  bankAccount: string | null
  rejectionReason: string | null
}

export type RegisterPayload = {
  fullName: string
  phone: string
  email: string
  password: string
  licenseNo: string
  area: string
}

const emptyUser = (): TherapistUser => ({
  name: '',
  initials: '',
  phone: null,
  licenseNo: null,
  area: null,
  radiusKm: 0,
  specialties: [],
  completedSessions: 0,
  onTimePct: null,
  sopViolations: 0,
  rating: 0,
  reviewCount: 0,
  bankAccount: null,
  rejectionReason: null
})

function toInitials(name: string): string {
  return name
    .trim()
    .split(/\s+/)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase() ?? '')
    .join('')
}

function maskAccount(bank: string | null, accountNo: string | null): string | null {
  if (!accountNo) return null
  return `${bank ?? ''} •••• ${accountNo.slice(-4)}`.trim()
}

export function mapAuthError(error: unknown): string {
  const message = error instanceof Error ? error.message : String(error)
  if (/invalid login credentials/i.test(message)) return 'Email atau kata sandi salah'
  if (/email not confirmed/i.test(message)) return 'Email belum dikonfirmasi. Cek kotak masuk Anda.'
  if (/already registered/i.test(message)) return 'Email sudah terdaftar'
  if (/password should be at least/i.test(message)) return 'Kata sandi terlalu pendek'
  if (/rate limit/i.test(message)) return 'Terlalu banyak percobaan. Coba lagi nanti.'
  if (/failed to fetch|network/i.test(message)) return 'Tidak dapat terhubung ke server'
  return message
}

// Shared across callers so the initial session check runs once
let initPromise: Promise<void> | null = null

export function useAuth() {
  const supabase = useSupabase()

  const session = useState<Session | null>('auth-session', () => null)
  const user = useState<TherapistUser>('auth-user', emptyUser)
  const verificationStatus = useState<VerificationStatus | null>('auth-verification', () => null)
  const isAvailable = useState('auth-available', () => false)
  const ready = useState('auth-ready', () => false)

  const isLoggedIn = computed(() => !!session.value)
  const isApproved = computed(() => verificationStatus.value === 'approved')

  function reset() {
    session.value = null
    user.value = emptyUser()
    verificationStatus.value = null
    isAvailable.value = false
  }

  async function loadProfile() {
    const userId = session.value?.user.id
    if (!userId) return

    const { data, error } = await supabase
      .from('profiles')
      // therapists has two FKs to profiles (id, verified_by); embed via the 1:1 one
      .select('full_name, phone, role, therapists!therapists_id_fkey(*)')
      .eq('id', userId)
      .single()

    if (error) throw error
    const therapist = Array.isArray(data.therapists) ? data.therapists[0] : data.therapists
    if (data.role !== 'THERAPIST' || !therapist) {
      throw new Error('Akun ini bukan akun mitra')
    }

    user.value = {
      name: data.full_name,
      initials: toInitials(data.full_name),
      phone: data.phone,
      licenseNo: therapist.license_no,
      area: therapist.area,
      radiusKm: Number(therapist.radius_km),
      specialties: therapist.specialties ?? [],
      completedSessions: therapist.completed_sessions,
      onTimePct: null,
      sopViolations: therapist.sop_violations,
      rating: Number(therapist.rating_avg),
      reviewCount: therapist.review_count,
      bankAccount: maskAccount(therapist.bank_name, therapist.bank_account_no),
      rejectionReason: therapist.rejection_reason
    }
    verificationStatus.value = therapist.verification_status
    isAvailable.value = therapist.is_available
  }

  function init() {
    if (initPromise) return initPromise

    initPromise = (async () => {
      const { data } = await supabase.auth.getSession()
      session.value = data.session
      if (data.session) {
        try {
          await loadProfile()
        } catch {
          await supabase.auth.signOut()
          reset()
        }
      }

      supabase.auth.onAuthStateChange((event, newSession) => {
        if (event === 'SIGNED_OUT') {
          reset()
          return
        }
        session.value = newSession
      })

      ready.value = true
    })()

    return initPromise
  }

  async function login(email: string, password: string) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) throw new Error(mapAuthError(error))
    session.value = data.session

    const { data: role, error: roleError } = await supabase.rpc('get_my_role')
    if (roleError || role !== 'THERAPIST') {
      await logout()
      throw new Error('Akun ini bukan akun mitra')
    }

    await loadProfile()
    return verificationStatus.value
  }

  async function register(payload: RegisterPayload) {
    const { data, error } = await supabase.auth.signUp({
      email: payload.email,
      password: payload.password,
      options: {
        data: {
          role: 'THERAPIST',
          full_name: payload.fullName,
          phone: payload.phone,
          license_no: payload.licenseNo,
          area: payload.area
        }
      }
    })
    if (error) throw new Error(mapAuthError(error))

    // With email confirmation on, an existing email comes back with no identities
    if (data.user && data.user.identities?.length === 0) {
      throw new Error('Email sudah terdaftar')
    }

    session.value = data.session
    if (data.session) await loadProfile()

    return { needsEmailConfirm: !data.session }
  }

  async function logout() {
    await supabase.auth.signOut()
    reset()
  }

  const available = computed({
    get: () => isAvailable.value,
    set: async (value: boolean) => {
      const userId = session.value?.user.id
      if (!userId || !isApproved.value) return

      const previous = isAvailable.value
      isAvailable.value = value
      const { data, error } = await supabase
        .from('therapists')
        .update({ is_available: value })
        .eq('id', userId)
        .select('is_available')
        .single()

      isAvailable.value = error ? previous : data.is_available
    }
  })

  return {
    session,
    user,
    verificationStatus,
    ready,
    isLoggedIn,
    isApproved,
    available,
    init,
    login,
    register,
    loadProfile,
    logout
  }
}
