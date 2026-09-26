import { createClient, type SupabaseClient } from '@supabase/supabase-js'

// Created lazily on first use so it never depends on plugin order
let client: SupabaseClient | null = null

export function useSupabase() {
  if (client) return client

  const { supabaseUrl, supabaseKey } = useRuntimeConfig().public
  if (!supabaseUrl || !supabaseKey) {
    throw new Error('Supabase belum dikonfigurasi: isi NUXT_PUBLIC_SUPABASE_URL dan NUXT_PUBLIC_SUPABASE_KEY di .env, lalu restart dev server')
  }

  client = createClient(supabaseUrl, supabaseKey)
  return client
}
