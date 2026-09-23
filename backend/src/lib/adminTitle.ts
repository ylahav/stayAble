import type { Payload } from 'payload'

import { relEmail, relId, relName } from './relations'

export function joinTitle(...parts: Array<string | null | undefined>): string {
  return parts.map((part) => part?.trim()).filter(Boolean).join(' / ')
}

export function exerciseName(value: unknown): string {
  if (value && typeof value === 'object') {
    const row = value as { en?: string | null; he?: string | null }
    return String(row.en || row.he || '').trim()
  }
  return typeof value === 'string' ? value.trim() : ''
}

export function formatAdminDate(value: unknown): string {
  if (!value) return ''
  const date = value instanceof Date ? value : new Date(String(value))
  if (Number.isNaN(date.getTime())) return ''
  return date.toLocaleDateString('en-GB', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  })
}

export async function labelForUser(payload: Payload, value: unknown): Promise<string> {
  const name = relName(value)
  if (name) return name
  const email = relEmail(value)
  if (email) return email
  const id = relId(value)
  if (!id) return ''
  try {
    const user = await payload.findByID({
      collection: 'users',
      id,
      depth: 0,
      overrideAccess: true,
    })
    return String(user.name || user.email || id)
  } catch {
    return id
  }
}

export async function labelForProgram(payload: Payload, value: unknown): Promise<string> {
  if (value && typeof value === 'object' && 'name' in value) {
    const name = String((value as { name?: string }).name ?? '').trim()
    if (name) return name
  }
  const id = relId(value)
  if (!id) return ''
  try {
    const program = await payload.findByID({
      collection: 'programs',
      id,
      depth: 0,
      overrideAccess: true,
    })
    return String(program.name || id)
  } catch {
    return id
  }
}
