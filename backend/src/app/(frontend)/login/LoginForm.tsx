'use client'

import { useState } from 'react'

type Props = {
  nextPath: string
}

export function LoginForm({ nextPath }: Props) {
  const [error, setError] = useState<string | null>(null)
  const [pending, setPending] = useState(false)

  async function onSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError(null)
    setPending(true)
    const form = new FormData(event.currentTarget)
    const email = String(form.get('email') ?? '')
    const password = String(form.get('password') ?? '')

    const response = await fetch('/api/users/login', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    })

    if (!response.ok) {
      setPending(false)
      setError('Email or password is wrong.')
      return
    }

    const body = (await response.json()) as {
      user?: { roles?: string[] }
    }
    const roles = body.user?.roles ?? []
    let dest = nextPath
    if (dest === '/' || dest === '/login') {
      if (roles.includes('trainer')) dest = '/dashboard'
      else if (roles.includes('athlete')) dest = '/programs'
      else if (roles.includes('admin')) dest = '/admin'
    }
    window.location.href = dest
  }

  return (
    <form className="form" onSubmit={(event) => void onSubmit(event)}>
      <label>
        Email
        <input name="email" type="email" autoComplete="username" required />
      </label>
      <label>
        Password
        <input name="password" type="password" autoComplete="current-password" required />
      </label>
      {error && <p className="error">{error}</p>}
      <button className="btn" type="submit" disabled={pending}>
        {pending ? 'Signing in…' : 'Log in'}
      </button>
    </form>
  )
}
