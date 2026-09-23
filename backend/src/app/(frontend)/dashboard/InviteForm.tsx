'use client'

import { useState } from 'react'

import { inviteAthlete } from './actions'

export function InviteForm() {
  const [error, setError] = useState<string | null>(null)
  const [ok, setOk] = useState(false)

  return (
    <form
      className="form"
      action={async (formData) => {
        setOk(false)
        const result = await inviteAthlete(formData)
        setError(result.error ?? null)
        setOk(!result.error)
      }}
    >
      <label>
        Athlete email
        <input name="email" type="email" required placeholder="alex@example.com" />
      </label>
      {error && <p className="error">{error}</p>}
      {ok && <p className="muted">Invite sent. They accept it on Programs.</p>}
      <button className="btn" type="submit">
        Invite
      </button>
    </form>
  )
}
