'use client'

export function LogoutButton() {
  async function logout() {
    await fetch('/api/users/logout', { method: 'POST', credentials: 'include' })
    window.location.href = '/'
  }

  return (
    <button type="button" onClick={() => void logout()}>
      Log out
    </button>
  )
}
