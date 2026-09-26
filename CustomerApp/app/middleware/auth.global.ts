export default defineNuxtRouteMiddleware((to) => {
  if (to.path.startsWith('/auth')) return

  const { isLoggedIn } = useAuth()
  if (!isLoggedIn.value) {
    return navigateTo('/auth/login')
  }
})
