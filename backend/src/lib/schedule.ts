export const weekdaySlug = ['', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'] as const

export type ScheduleKind = 'daily' | 'weekly' | 'custom'

export function parseScheduleType(raw: string): ScheduleKind | null {
  if (raw === 'daily' || raw === 'weekly' || raw === 'custom') return raw
  return null
}

export function slugify(value: string): string {
  return value
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

export function scheduleDaysFor(
  type: ScheduleKind,
  weekdays: number[],
): { clientId: string; weekday: number }[] | undefined {
  if (type === 'custom') return undefined
  const selected =
    type === 'daily' ? [1, 2, 3, 4, 5, 6, 7] : weekdays.length > 0 ? weekdays : [1, 3, 5]
  return selected.map((weekday) => ({
    clientId: `day-${weekdaySlug[weekday]}`,
    weekday,
  }))
}
