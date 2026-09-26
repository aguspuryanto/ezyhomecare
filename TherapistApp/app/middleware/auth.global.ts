const PUBLIC_ROUTES = ['/login', '/daftar']
const VERIFY_ROUTE = '/verifikasi'

export default defineNuxtRouteMiddleware(async (to) => {
  const { init, isLoggedIn, isApproved } = useAuth()
  await init()

  if (PUBLIC_ROUTES.includes(to.path)) {
    if (isLoggedIn.value) return navigateTo(isApproved.value ? '/order' : VERIFY_ROUTE)
    return
  }

  if (!isLoggedIn.value) return navigateTo('/login')

  if (!isApproved.value && to.path !== VERIFY_ROUTE) return navigateTo(VERIFY_ROUTE)
  if (isApproved.value && to.path === VERIFY_ROUTE) return navigateTo('/order')
})
