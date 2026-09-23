import { stripLoopbackOrigin } from './publicOrigin'

export function relId(value: unknown): string {
  if (typeof value === 'string' || typeof value === 'number') return String(value)
  if (value && typeof value === 'object' && 'id' in value) {
    return String((value as { id: string | number }).id)
  }
  return ''
}

export function relName(value: unknown): string {
  if (value && typeof value === 'object' && 'name' in value) {
    return String((value as { name?: string }).name ?? '')
  }
  return ''
}

export function relEmail(value: unknown): string {
  if (value && typeof value === 'object' && 'email' in value) {
    return String((value as { email?: string }).email ?? '')
  }
  return ''
}

export function minutesFromSeconds(seconds?: number | null): string {
  if (seconds == null) return '—'
  return String(Math.round(seconds / 60))
}

export function formatSeconds(seconds?: number | null): string {
  if (seconds == null) return '—'
  const m = Math.floor(seconds / 60)
  const s = Math.round(seconds % 60)
  if (m <= 0) return `${s}s`
  return `${m}:${String(s).padStart(2, '0')}`
}

export function vs(actual?: number | null, planned?: number | null): string {
  if (actual == null && planned == null) return '—'
  if (planned == null) return String(actual)
  return `${actual ?? 0} / ${planned}`
}

export function exerciseName(value: unknown): string {
  if (value && typeof value === 'object' && 'name' in value) {
    const name = (value as { name?: { en?: string | null; he?: string | null } }).name
    return name?.en || name?.he || ''
  }
  return ''
}

export function mediaUrl(value: unknown): string | null {
  if (value && typeof value === 'object' && 'url' in value) {
    const url = (value as { url?: string | null }).url
    return url ? stripLoopbackOrigin(url) : null
  }
  return null
}

export function exerciseImageUrl(value: unknown): string | null {
  if (value && typeof value === 'object' && 'image' in value) {
    return mediaUrl((value as { image?: unknown }).image)
  }
  return null
}

export function sessionStatusLabel(status: string): string {
  const labels: Record<string, string> = {
    planned: 'Planned',
    started: 'Started',
    completed: 'Completed',
    partiallyCompleted: 'Partial',
    skipped: 'Skipped',
    cancelled: 'Cancelled',
  }
  return labels[status] ?? status
}

export function effortLabel(value?: string | null): string {
  if (value === 'easy') return 'Easy'
  if (value === 'good') return 'Good'
  if (value === 'difficult') return 'Difficult'
  return '—'
}

export function venueLabel(value?: string | null): string {
  if (value === 'home') return 'Home'
  if (value === 'gym') return 'Gym'
  if (value === 'mixed') return 'Mixed'
  if (value === 'both') return 'Home + gym'
  return '—'
}

export function scheduleTypeLabel(value?: string | null): string {
  if (value === 'daily') return 'Daily'
  if (value === 'weekly') return 'Weekly'
  if (value === 'custom') return 'Custom'
  return ''
}

export function relSelect(value: unknown, key: string): string {
  if (value && typeof value === 'object' && key in value) {
    const selected = (value as Record<string, unknown>)[key]
    return selected == null ? '' : String(selected)
  }
  return ''
}

export function relVenue(value: unknown): string {
  return relSelect(value, 'venue')
}

export function startOfWeek(now = new Date()): Date {
  const date = new Date(now)
  const day = date.getDay()
  const mondayOffset = day === 0 ? -6 : 1 - day
  date.setHours(0, 0, 0, 0)
  date.setDate(date.getDate() + mondayOffset)
  return date
}
