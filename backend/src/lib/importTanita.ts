import type { Payload } from 'payload'

import { trainerCanSeeAthlete } from '@/access/linkedAthletes'
import { isStaff, type AuthedUser } from '@/access/roles'
import { measurementStamp, parseTanitaPdf, type BodyMeasurementValues } from '@/lib/tanitaPdf'

export type ImportTanitaResult = {
  error?: string
  saved?: boolean
  updated?: boolean
  athleteName?: string
  values?: BodyMeasurementValues
}

function payloadErrorMessage(error: unknown): string {
  if (error && typeof error === 'object' && 'data' in error) {
    const errors = (error as { data?: { errors?: Array<{ message?: string }> } }).data?.errors
    const first = errors?.map((item) => item.message).find(Boolean)
    if (first) return first
  }
  if (error instanceof Error && error.message) return error.message
  return 'Could not save that scan.'
}

function safeJson(value: Record<string, unknown>): { [k: string]: unknown } {
  return JSON.parse(
    JSON.stringify(value, (_key, item) => {
      if (typeof item !== 'string') return item
      return item.replace(/[\uD800-\uDFFF]/g, '').replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/g, '')
    }),
  ) as { [k: string]: unknown }
}

export async function importTanitaForTrainee(input: {
  payload: Payload
  user: AuthedUser
  athleteId: string
  filename: string
  buffer: Buffer
}): Promise<ImportTanitaResult> {
  const { payload, user, filename, buffer } = input
  const athleteId = input.athleteId.trim()
  if (!user || !isStaff(user)) return { error: 'Instructor or admin role required.' }
  if (!athleteId) return { error: 'Choose the trainee this scan belongs to.' }
  if (buffer.length === 0) return { error: 'Drop a MyTanita PDF first.' }
  if (!filename.toLowerCase().endsWith('.pdf')) return { error: 'That file is not a PDF.' }

  try {
    const allowed = user.id === athleteId || (await trainerCanSeeAthlete(payload, user, athleteId))
    if (!allowed) return { error: 'That trainee is not on your client list.' }

    return await saveTanitaScan({ payload, athleteId, filename, buffer })
  } catch (error) {
    return { error: payloadErrorMessage(error) }
  }
}

async function saveTanitaScan(input: {
  payload: Payload
  athleteId: string
  filename: string
  buffer: Buffer
}): Promise<ImportTanitaResult> {
  const { payload, athleteId, filename, buffer } = input
  let parsed
  try {
    parsed = parseTanitaPdf(buffer)
  } catch (error) {
    return { error: error instanceof Error ? error.message : 'Could not read that PDF.' }
  }

  const { strings, ...values } = parsed
  const stamp = measurementStamp(values.measuredAt)
  const existing = await payload.find({
    collection: 'body-measurements',
    depth: 0,
    limit: 40,
    overrideAccess: true,
    pagination: false,
    where: {
      and: [{ athlete: { equals: athleteId } }, { source: { equals: 'mytanita-pdf' } }],
    },
  })
  const same = existing.docs.find((row) => {
    const raw = row.measuredAt as unknown
    const when =
      typeof raw === 'string'
        ? raw
        : raw instanceof Date
          ? raw.toISOString()
          : ''
    return when ? measurementStamp(when) === stamp : false
  })

  const data = {
    athlete: athleteId,
    measuredAt: values.measuredAt,
    source: 'mytanita-pdf' as const,
    sourceUserId: values.sourceUserId ?? null,
    filename,
    heightCm: values.heightCm ?? null,
    age: values.age ?? null,
    weightKg: values.weightKg ?? null,
    bmi: values.bmi ?? null,
    bodyFatPercent: values.bodyFatPercent ?? null,
    fatMassKg: values.fatMassKg ?? null,
    fatFreeMassKg: values.fatFreeMassKg ?? null,
    muscleMassKg: values.muscleMassKg ?? null,
    boneMassKg: values.boneMassKg ?? null,
    proteinKg: values.proteinKg ?? null,
    bodyWaterPercent: values.bodyWaterPercent ?? null,
    bodyWaterKg: values.bodyWaterKg ?? null,
    bmrKcal: values.bmrKcal ?? null,
    bmrKj: values.bmrKj ?? null,
    metabolicAge: values.metabolicAge ?? null,
    visceralFat: values.visceralFat ?? null,
    raw: safeJson({ ...values, strings: strings.slice(0, 40) }),
    deleted: false,
  }

  try {
    if (same) {
      await payload.update({
        collection: 'body-measurements',
        id: same.id,
        overrideAccess: true,
        data,
      })
    } else {
      await payload.create({
        collection: 'body-measurements',
        overrideAccess: true,
        data,
      })
    }
  } catch (error) {
    return { error: payloadErrorMessage(error) }
  }

  const athlete = await payload.findByID({
    collection: 'users',
    id: athleteId,
    depth: 0,
    overrideAccess: true,
  })
  try {
    await payload.update({
      collection: 'users',
      id: athleteId,
      overrideAccess: true,
      data: {
        ...(values.weightKg != null ? { weightKg: values.weightKg } : {}),
        ...(values.age != null && athlete.age == null ? { age: values.age } : {}),
      },
    })
  } catch (error) {
    payload.logger.warn({ err: error }, 'Imported scan but could not update trainee profile weight')
  }

  return {
    saved: true,
    updated: Boolean(same),
    athleteName: athlete.name || athlete.email || athleteId,
    values,
  }
}
