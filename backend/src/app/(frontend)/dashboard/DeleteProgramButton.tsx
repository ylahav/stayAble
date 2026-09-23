'use client'

import { useState } from 'react'

import { deleteProgram } from './actions'

export function DeleteProgramButton({
  programId,
  name,
}: {
  programId: string
  name: string
}) {
  const [error, setError] = useState<string | null>(null)
  const [pending, setPending] = useState(false)

  return (
    <form
      action={async (formData) => {
        if (!window.confirm(`Delete “${name}”? Past sessions stay. Assignments are removed.`)) {
          return
        }
        setPending(true)
        setError(null)
        const result = await deleteProgram(formData)
        setError(result.error ?? null)
        setPending(false)
      }}
    >
      <input type="hidden" name="programId" value={programId} />
      <button className="btn btn-ghost" type="submit" disabled={pending}>
        {pending ? 'Deleting…' : 'Delete'}
      </button>
      {error ? <p className="error">{error}</p> : null}
    </form>
  )
}
