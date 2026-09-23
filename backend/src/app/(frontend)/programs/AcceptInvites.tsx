'use client'

import { acceptOwnInvite } from '../dashboard/actions'

export function AcceptInvites({ count }: { count: number }) {
  if (count === 0) return null
  return (
    <form action={acceptOwnInvite} className="panel" style={{ marginBottom: '1.25rem' }}>
      <p style={{ marginTop: 0 }}>
        You have {count} trainer invite{count === 1 ? '' : 's'}.
      </p>
      <button className="btn" type="submit">
        Accept
      </button>
    </form>
  )
}
