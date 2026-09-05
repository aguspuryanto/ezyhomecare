import { currentUser } from '~/data/dummy'

export function useAuth() {
  const isLoggedIn = useState('auth-logged-in', () => false)
  const user = useState('auth-user', () => currentUser)

  function login() {
    isLoggedIn.value = true
  }

  function logout() {
    isLoggedIn.value = false
  }

  return { isLoggedIn, user, login, logout }
}
