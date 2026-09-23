import type { Payload } from 'payload'

import { relId } from '../lib/relations'
import { weekdaySlug, type ScheduleKind } from '../lib/schedule'

type LegacyDay = {
  clientId?: string
  weekday?: number | null
  date?: string | null
  exercises?: Array<{
    clientId?: string
    exercise?: unknown
    sortOrder?: number
    sets?: number
    repetitions?: number | null
    duration?: number | null
    loadKg?: number | null
    rest?: number | null
    notes?: string | null
  }>
}

function mongoCollection(payload: Payload, name: string) {
  const db = (
    payload.db as {
      connection?: { db?: { collection: (n: string) => {
        find: (q: object) => { toArray: () => Promise<Record<string, unknown>[]> }
        updateOne: (q: object, u: object) => Promise<unknown>
      } } }
    }
  ).connection?.db
  return db?.collection(name)
}

function relObjectId(value: unknown): string {
  if (value && typeof value === 'object' && '_id' in value) {
    return String((value as { _id: unknown })._id)
  }
  return relId(value)
}

function slotClientId(item: NonNullable<LegacyDay['exercises']>[number], dayClientId?: string): string {
  const raw = String(item.clientId ?? '').trim()
  if (dayClientId && raw.startsWith(`${dayClientId}-`)) {
    return raw.slice(dayClientId.length + 1)
  }
  return raw || `slot-${item.sortOrder ?? 1}`
}

function flattenDays(days: LegacyDay[]): {
  exercises: Array<Record<string, unknown>>
  scheduleDays: Array<{ clientId: string; weekday?: number; date?: string }>
  differs: boolean
} {
  const first = days[0]
  const firstExercises = (first.exercises ?? []).filter((row) => relObjectId(row.exercise))
  const firstKeys = firstExercises.map((row) => relObjectId(row.exercise)).join(',')
  const differs = days.slice(1).some((day) => {
    const keys = (day.exercises ?? []).map((row) => relObjectId(row.exercise)).join(',')
    return keys !== firstKeys
  })
  const exercises = firstExercises.map((row, index) => ({
    clientId: slotClientId(row, first.clientId),
    exercise: relObjectId(row.exercise),
    sortOrder: row.sortOrder ?? index + 1,
    sets: row.sets ?? 1,
    repetitions: row.repetitions ?? undefined,
    duration: row.duration ?? undefined,
    loadKg: row.loadKg ?? undefined,
    rest: row.rest ?? 0,
    notes: row.notes ?? undefined,
  }))
  const scheduleDays = days.flatMap((day, index) => {
    const weekday = typeof day.weekday === 'number' ? day.weekday : undefined
    const date = typeof day.date === 'string' ? day.date : undefined
    if (!weekday && !date) return []
    return [
      {
        clientId: day.clientId || (weekday ? `day-${weekdaySlug[weekday]}` : `day-${index + 1}`),
        weekday,
        date,
      },
    ]
  })
  return { exercises, scheduleDays, differs }
}

export async function migrateProgramTemplates(payload: Payload): Promise<void> {
  const programsCol = mongoCollection(payload, 'programs')
  const rawPrograms = programsCol
    ? await programsCol.find({ days: { $exists: true } }).toArray()
    : []

  if (rawPrograms.length === 0) return

  for (const raw of rawPrograms) {
    const id = String(raw._id ?? raw.id ?? '')
    if (!id) continue
    const days = Array.isArray(raw.days) ? (raw.days as LegacyDay[]) : []
    if (days.length === 0) {
      if (programsCol) {
        await programsCol.updateOne(
          { _id: raw._id },
          { $unset: { days: '', startDate: '', endDate: '', scheduleType: '' } },
        )
      }
      continue
    }

    const { exercises, scheduleDays, differs } = flattenDays(days)
    if (differs) {
      payload.logger.warn(
        `Program ${String(raw.clientId ?? id)} had different exercises per day; keeping the first day's list.`,
      )
    }

    await payload.update({
      collection: 'programs',
      id,
      overrideAccess: true,
      data: { exercises },
    })
    if (programsCol) {
      await programsCol.updateOne(
        { _id: raw._id },
        { $unset: { days: '', startDate: '', endDate: '', scheduleType: '' } },
      )
    }

    const assignments = await payload.find({
      collection: 'program-assignments',
      depth: 0,
      limit: 200,
      overrideAccess: true,
      pagination: false,
      where: { program: { equals: id } },
    })
    const inheritedType =
      raw.scheduleType === 'daily' || raw.scheduleType === 'weekly' || raw.scheduleType === 'custom'
        ? (raw.scheduleType as ScheduleKind)
        : 'weekly'
    for (const assignment of assignments.docs) {
      const data: {
        scheduleType?: ScheduleKind
        scheduleDays?: Array<{ clientId: string; weekday?: number; date?: string }>
      } = {}
      if (!assignment.scheduleType) data.scheduleType = inheritedType
      if (!assignment.scheduleDays?.length && scheduleDays.length > 0) {
        data.scheduleDays = scheduleDays
      }
      if (Object.keys(data).length === 0) continue
      await payload.update({
        collection: 'program-assignments',
        id: assignment.id,
        overrideAccess: true,
        data,
      })
    }
  }

  payload.logger.info(`Flattened ${rawPrograms.length} program template(s) off per-day lists`)
}
