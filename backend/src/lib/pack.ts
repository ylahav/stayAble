import { readFile, writeFile, unlink } from 'fs/promises'
import { tmpdir } from 'os'
import path from 'path'

import type { Payload, Where } from 'payload'

import { localizedToHtml } from '@/lib/richText'

export const PACK_VERSION = 1 as const

export type PackCounts = {
  media: { created: number; updated: number; skipped: number }
  users: { created: number; updated: number; skipped: number }
  exercises: { created: number; updated: number; skipped: number }
  programs: { created: number; updated: number; skipped: number }
  assignments: { created: number; updated: number; skipped: number }
  clients: { created: number; updated: number; skipped: number }
  sessions: { created: number; updated: number; skipped: number }
  warnings: string[]
}

export type StayAblePack = {
  version: typeof PACK_VERSION
  kind: 'stayable-pack' | 'home-gym-pack'
  exportedAt: string
  media: PackMedia[]
  users: Record<string, unknown>[]
  exercises: Record<string, unknown>[]
  programs: Record<string, unknown>[]
  programAssignments: Record<string, unknown>[]
  trainerClients: Record<string, unknown>[]
  workoutSessions: Record<string, unknown>[]
}

export type PackMedia = {
  clientId?: string | null
  filename: string
  alt: string
  mimeType: string
  data: string
}

type Doc = { id: string } & Record<string, unknown>

function asBool(value: unknown, fallback = false): boolean {
  return typeof value === 'boolean' ? value : fallback
}

function asStr(value: unknown): string | undefined {
  if (typeof value === 'string' && value.trim()) return value
  return undefined
}

function asNum(value: unknown): number | undefined {
  return typeof value === 'number' && Number.isFinite(value) ? value : undefined
}

function emptyCounts(): PackCounts {
  return {
    media: { created: 0, updated: 0, skipped: 0 },
    users: { created: 0, updated: 0, skipped: 0 },
    exercises: { created: 0, updated: 0, skipped: 0 },
    programs: { created: 0, updated: 0, skipped: 0 },
    assignments: { created: 0, updated: 0, skipped: 0 },
    clients: { created: 0, updated: 0, skipped: 0 },
    sessions: { created: 0, updated: 0, skipped: 0 },
    warnings: [],
  }
}

function relId(value: unknown): string {
  if (typeof value === 'string') return value
  if (value && typeof value === 'object' && 'id' in value) {
    return String((value as { id: string }).id)
  }
  return ''
}

function workoutTypeFromCategory(category: unknown): 'strength' | 'aerobic' | 'hiit' | 'functional' {
  if (category === 'strength') return 'strength'
  if (category === 'cardio') return 'aerobic'
  return 'functional'
}

function loc(value: unknown): { en: string; he: string } {
  const html = localizedToHtml(value)
  return { en: html.en || html.he || '—', he: html.he }
}

function mapPackExercise(
  item: Record<string, unknown>,
  exerciseIdByClient: Map<string, string>,
  dayClientId?: string,
) {
  const exerciseId = exerciseIdByClient.get(String(item.exerciseClientId ?? ''))
  if (!exerciseId) return null
  const rawId = String(item.clientId ?? '').trim()
  const clientId =
    dayClientId && rawId.startsWith(`${dayClientId}-`) ? rawId.slice(dayClientId.length + 1) : rawId
  return {
    clientId: clientId || `slot-${item.sortOrder ?? 1}`,
    exercise: exerciseId,
    sortOrder: item.sortOrder,
    sets: item.sets,
    repetitions: item.repetitions ?? undefined,
    duration: item.duration ?? undefined,
    loadKg: item.loadKg ?? undefined,
    rest: item.rest ?? 0,
    notes: item.notes ?? undefined,
  }
}

function packExercises(row: Record<string, unknown>, exerciseIdByClient: Map<string, string>) {
  const direct = (row.exercises as Array<Record<string, unknown>> | undefined) ?? []
  if (direct.length > 0) {
    return direct.map((item) => mapPackExercise(item, exerciseIdByClient)).filter(Boolean)
  }
  const days = (row.days as Array<Record<string, unknown>> | undefined) ?? []
  const first = days[0]
  if (!first) return []
  const items = (first.exercises as Array<Record<string, unknown>> | undefined) ?? []
  return items
    .map((item) => mapPackExercise(item, exerciseIdByClient, String(first.clientId ?? '')))
    .filter(Boolean)
}

function legacyScheduleFromDays(row: Record<string, unknown>): {
  type: 'daily' | 'weekly' | 'custom'
  days: Array<{ clientId: string; weekday?: number; date?: string }>
} | null {
  const days = (row.days as Array<Record<string, unknown>> | undefined) ?? []
  if (days.length === 0) return null
  const scheduleDays = days.flatMap((day, index) => {
    const weekday = typeof day.weekday === 'number' ? day.weekday : undefined
    const date = typeof day.date === 'string' ? day.date : undefined
    if (!weekday && !date) return []
    return [
      {
        clientId: String(day.clientId || (weekday ? `day-${weekday}` : `day-${index + 1}`)),
        weekday,
        date,
      },
    ]
  })
  if (scheduleDays.length === 0) return null
  const type: 'daily' | 'weekly' | 'custom' =
    row.scheduleType === 'daily' || row.scheduleType === 'weekly' || row.scheduleType === 'custom'
      ? row.scheduleType
      : scheduleDays.some((day) => day.date)
        ? 'custom'
        : 'weekly'
  return { type, days: scheduleDays }
}

async function findAll(
  payload: Payload,
  collection:
    | 'users'
    | 'media'
    | 'exercises'
    | 'programs'
    | 'program-assignments'
    | 'trainer-clients'
    | 'workout-sessions',
  depth = 0,
): Promise<Doc[]> {
  const docs: Doc[] = []
  let page = 1
  for (;;) {
    const result = await payload.find({
      collection,
      depth,
      limit: 200,
      page,
      overrideAccess: true,
      pagination: true,
    })
    docs.push(...(result.docs as unknown as Doc[]))
    if (!result.hasNextPage) break
    page += 1
  }
  return docs
}

async function findBy(
  payload: Payload,
  collection:
    | 'users'
    | 'media'
    | 'exercises'
    | 'programs'
    | 'program-assignments'
    | 'trainer-clients'
    | 'workout-sessions',
  where: Record<string, unknown>,
): Promise<Doc | null> {
  const result = await payload.find({
    collection,
    depth: 0,
    limit: 1,
    overrideAccess: true,
    pagination: false,
    where: where as Where,
  })
  return (result.docs[0] as unknown as Doc | undefined) ?? null
}

export async function exportStayAblePack(payload: Payload): Promise<StayAblePack> {
  const [users, media, exercises, programs, assignments, clients, sessions] = await Promise.all([
    findAll(payload, 'users'),
    findAll(payload, 'media'),
    findAll(payload, 'exercises', 1),
    findAll(payload, 'programs', 1),
    findAll(payload, 'program-assignments', 1),
    findAll(payload, 'trainer-clients', 1),
    findAll(payload, 'workout-sessions', 1),
  ])

  const emailById = new Map(users.map((row) => [row.id, String(row.email ?? '')]))
  const exerciseClientById = new Map(exercises.map((row) => [row.id, String(row.clientId ?? '')]))
  const programClientById = new Map(programs.map((row) => [row.id, String(row.clientId ?? '')]))

  const packedMedia: PackMedia[] = []
  for (const row of media) {
    const filename = String(row.filename ?? '')
    if (!filename) continue
    const filePath = path.resolve('media', filename)
    try {
      const buffer = await readFile(filePath)
      packedMedia.push({
        clientId: (row.clientId as string | null) ?? null,
        filename,
        alt: String(row.alt ?? filename),
        mimeType: String(row.mimeType ?? 'image/png'),
        data: buffer.toString('base64'),
      })
    } catch {
      // file missing on disk — skip; import can still recreate from seed
    }
  }

  return {
    version: PACK_VERSION,
    kind: 'stayable-pack',
    exportedAt: new Date().toISOString(),
    media: packedMedia,
    users: users.map((row) => ({
      email: row.email,
      name: row.name,
      roles: row.roles,
      photo: row.photo,
      birthDate: row.birthDate,
      age: row.age,
      weightKg: row.weightKg,
      sex: row.sex,
      level: row.level,
      conditionNotes: row.conditionNotes,
      trainingVenue: row.trainingVenue,
      preferredUnits: row.preferredUnits,
      defaultRestSeconds: row.defaultRestSeconds,
      language: row.language,
      goals: row.goals,
      assessment: row.assessment,
      active: row.active,
    })),
    exercises: exercises.map((row) => {
      const image = row.image as { clientId?: string | null } | string | null
      const imageClientId =
        image && typeof image === 'object' ? image.clientId : null
      return {
        clientId: row.clientId,
        deleted: row.deleted ?? false,
        name: loc(row.name),
        description: loc(row.description),
        instructions: loc(row.instructions),
        safetyNotes: loc(row.safetyNotes),
        photoPath: row.photoPath ?? '',
        category: row.category,
        difficulty: row.difficulty,
        venue: row.venue ?? 'both',
        workoutType: row.workoutType ?? workoutTypeFromCategory(row.category),
        gymNumber: row.gymNumber ?? null,
        duration: row.duration ?? null,
        repetitions: row.repetitions ?? null,
        targetMuscles: row.targetMuscles ?? [],
        equipment: row.equipment ?? 'none',
        active: row.active ?? true,
        imageClientId,
      }
    }),
    programs: programs.map((row) => ({
      clientId: row.clientId,
      deleted: row.deleted ?? false,
      ownerEmail: emailById.get(relId(row.owner)) || null,
      name: row.name,
      description: row.description ?? '',
      venue: row.venue ?? 'home',
      active: row.active ?? true,
      exercises: ((row.exercises as Array<Record<string, unknown>>) ?? []).map((item) => ({
        clientId: item.clientId,
        exerciseClientId: exerciseClientById.get(relId(item.exercise)) || null,
        sortOrder: item.sortOrder,
        sets: item.sets,
        repetitions: item.repetitions ?? null,
        duration: item.duration ?? null,
        loadKg: item.loadKg ?? null,
        rest: item.rest ?? 0,
        notes: item.notes ?? null,
      })),
    })),
    programAssignments: assignments.map((row) => ({
      clientId: row.clientId,
      deleted: row.deleted ?? false,
      programClientId: programClientById.get(relId(row.program)) || null,
      athleteEmail: emailById.get(relId(row.athlete)) || null,
      assignedByEmail: emailById.get(relId(row.assignedBy)) || null,
      scheduleType: row.scheduleType ?? 'weekly',
      startDate: row.startDate ?? null,
      endDate: row.endDate ?? null,
      active: row.active ?? true,
      scheduleDays: ((row.scheduleDays as Array<Record<string, unknown>>) ?? []).map((day) => ({
        clientId: day.clientId,
        weekday: day.weekday ?? null,
        date: day.date ?? null,
      })),
      refinements: ((row.refinements as Array<Record<string, unknown>>) ?? []).map((item) => ({
        programExerciseClientId: item.programExerciseClientId,
        sets: item.sets ?? null,
        repetitions: item.repetitions ?? null,
        duration: item.duration ?? null,
        loadKg: item.loadKg ?? null,
        rest: item.rest ?? null,
        notes: item.notes ?? null,
      })),
    })),
    trainerClients: clients.map((row) => ({
      clientId: row.clientId,
      deleted: row.deleted ?? false,
      trainerEmail: emailById.get(relId(row.trainer)) || null,
      athleteEmail: emailById.get(relId(row.athlete)) || null,
      status: row.status,
      invitedAt: row.invitedAt ?? null,
      acceptedAt: row.acceptedAt ?? null,
      endedAt: row.endedAt ?? null,
    })),
    workoutSessions: sessions.map((row) => ({
      clientId: row.clientId,
      deleted: row.deleted ?? false,
      athleteEmail: emailById.get(relId(row.athlete)) || null,
      programClientId: programClientById.get(relId(row.program)) || null,
      programDayClientId: row.programDayClientId ?? null,
      startedAt: row.startedAt,
      completedAt: row.completedAt ?? null,
      duration: row.duration ?? null,
      status: row.status,
      notes: row.notes ?? null,
      totalVolumeKg: row.totalVolumeKg ?? null,
      exercises: ((row.exercises as Array<Record<string, unknown>>) ?? []).map((item) => ({
        clientId: item.clientId,
        exerciseClientId: exerciseClientById.get(relId(item.exercise)) || null,
        programExerciseClientId: item.programExerciseClientId ?? null,
        sortOrder: item.sortOrder,
        plannedSets: item.plannedSets,
        actualSets: item.actualSets ?? 0,
        plannedRepetitions: item.plannedRepetitions ?? null,
        actualRepetitions: item.actualRepetitions ?? null,
        plannedDuration: item.plannedDuration ?? null,
        actualDuration: item.actualDuration ?? null,
        completed: item.completed ?? false,
        effort: item.effort ?? null,
        notes: item.notes ?? null,
        personalRecord: item.personalRecord ?? false,
        sets: ((item.sets as Array<Record<string, unknown>>) ?? []).map((set) => ({
          clientId: set.clientId,
          setNumber: set.setNumber,
          plannedReps: set.plannedReps ?? null,
          actualReps: set.actualReps ?? null,
          plannedDuration: set.plannedDuration ?? null,
          actualDuration: set.actualDuration ?? null,
          plannedLoadKg: set.plannedLoadKg ?? null,
          actualLoadKg: set.actualLoadKg ?? null,
          completed: set.completed ?? false,
        })),
      })),
    })),
  }
}

export function parseStayAblePack(raw: string): { pack?: StayAblePack; error?: string } {
  let parsed: unknown
  try {
    parsed = JSON.parse(raw)
  } catch {
    return { error: 'That file is not valid JSON.' }
  }
  if (!parsed || typeof parsed !== 'object') return { error: 'Empty pack.' }
  const pack = parsed as Partial<StayAblePack>
  if (pack.kind !== 'stayable-pack' && pack.kind !== 'home-gym-pack') {
    return { error: 'Not a StayAble backup pack. Export from Backup on this site.' }
  }
  if (pack.version !== PACK_VERSION) {
    return { error: `Unsupported pack version ${String(pack.version)}.` }
  }
  return { pack: pack as StayAblePack }
}

export async function importStayAblePack(
  payload: Payload,
  pack: StayAblePack,
  options: { password?: string } = {},
): Promise<PackCounts> {
  const counts = emptyCounts()
  const password = options.password || process.env.IMPORT_DEFAULT_PASSWORD || ''

  const mediaIdByClient = new Map<string, string>()
  for (const file of pack.media ?? []) {
    if (!file.data || !file.filename) {
      counts.media.skipped += 1
      continue
    }
    const clientId = file.clientId || file.filename.replace(/\.[^.]+$/, '')
    const existing = await findBy(payload, 'media', { clientId: { equals: clientId } })
    const buffer = Buffer.from(file.data, 'base64')
    const tempFilePath = path.join(tmpdir(), `pack-${clientId}-${file.filename}`)
    await writeFile(tempFilePath, buffer)
    try {
      const body = {
        collection: 'media' as const,
        overrideAccess: true,
        data: { alt: file.alt || clientId, clientId },
        file: {
          data: Buffer.alloc(0),
          mimetype: file.mimeType || 'image/png',
          name: file.filename,
          size: buffer.length,
          tempFilePath,
        },
      }
      const doc = existing
        ? await payload.update({ ...body, id: existing.id })
        : await payload.create(body)
      mediaIdByClient.set(clientId, doc.id)
      if (existing) counts.media.updated += 1
      else counts.media.created += 1
    } finally {
      await unlink(tempFilePath).catch(() => undefined)
    }
  }

  const userIdByEmail = new Map<string, string>()
  for (const row of pack.users ?? []) {
    const email = String(row.email ?? '')
      .trim()
      .toLowerCase()
    if (!email) {
      counts.users.skipped += 1
      continue
    }
    const existing = await findBy(payload, 'users', { email: { equals: email } })
    const data = {
      name: String(row.name ?? email),
      email,
      roles: (row.roles as string[]) ?? ['athlete'],
      photo: row.photo,
      birthDate: row.birthDate,
      age: row.age,
      weightKg: row.weightKg,
      sex: row.sex,
      level: row.level,
      conditionNotes: row.conditionNotes,
      trainingVenue: row.trainingVenue ?? 'both',
      preferredUnits: row.preferredUnits ?? 'kg',
      defaultRestSeconds: row.defaultRestSeconds,
      language: row.language ?? 'en',
      goals: row.goals ?? [],
      assessment: row.assessment,
      active: row.active ?? true,
    }
    if (existing) {
      await payload.update({
        collection: 'users',
        id: existing.id,
        overrideAccess: true,
        data: data as never,
      })
      userIdByEmail.set(email, existing.id)
      counts.users.updated += 1
    } else if (!password) {
      counts.users.skipped += 1
      counts.warnings.push(`Skip new user ${email}: set IMPORT_DEFAULT_PASSWORD`)
    } else {
      const created = await payload.create({
        collection: 'users',
        overrideAccess: true,
        data: { ...data, password } as never,
      })
      userIdByEmail.set(email, created.id)
      counts.users.created += 1
    }
  }

  const exerciseIdByClient = new Map<string, string>()
  for (const row of pack.exercises ?? []) {
    const clientId = String(row.clientId ?? '')
    if (!clientId) {
      counts.exercises.skipped += 1
      continue
    }
    const imageClientId = String(row.imageClientId ?? clientId)
    const data = {
      clientId,
      deleted: Boolean(row.deleted),
      name: loc(row.name),
      description: loc(row.description),
      instructions: loc(row.instructions),
      safetyNotes: loc(row.safetyNotes),
      photoPath: row.photoPath ?? '',
      category: row.category,
      difficulty: row.difficulty,
      venue: row.venue ?? 'both',
      workoutType: row.workoutType ?? workoutTypeFromCategory(row.category),
      gymNumber: row.gymNumber ?? undefined,
      duration: row.duration ?? undefined,
      repetitions: row.repetitions ?? undefined,
      targetMuscles: row.targetMuscles ?? [],
      equipment: row.equipment ?? 'none',
      active: row.active ?? true,
      image: mediaIdByClient.get(imageClientId) ?? undefined,
    }
    const existing = await findBy(payload, 'exercises', { clientId: { equals: clientId } })
    if (existing) {
      await payload.update({
        collection: 'exercises',
        id: existing.id,
        overrideAccess: true,
        data: data as never,
      })
      exerciseIdByClient.set(clientId, existing.id)
      counts.exercises.updated += 1
    } else {
      const created = await payload.create({
        collection: 'exercises',
        overrideAccess: true,
        data: data as never,
      })
      exerciseIdByClient.set(clientId, created.id)
      counts.exercises.created += 1
    }
  }

  const programIdByClient = new Map<string, string>()
  const legacyScheduleByProgram = new Map<
    string,
    { type: 'daily' | 'weekly' | 'custom'; days: Array<{ clientId: string; weekday?: number; date?: string }> }
  >()
  for (const row of pack.programs ?? []) {
    const clientId = String(row.clientId ?? '')
    const ownerEmail = String(row.ownerEmail ?? '')
      .trim()
      .toLowerCase()
    const ownerId = userIdByEmail.get(ownerEmail)
    if (!clientId || !ownerId) {
      counts.programs.skipped += 1
      if (clientId && !ownerId) counts.warnings.push(`Skip program ${clientId}: owner ${ownerEmail} missing`)
      continue
    }
    const exercises = packExercises(row, exerciseIdByClient)
    const legacy = legacyScheduleFromDays(row)
    if (legacy) legacyScheduleByProgram.set(clientId, legacy)
    const data = {
      clientId,
      deleted: Boolean(row.deleted),
      owner: ownerId,
      name: row.name,
      description: row.description ?? '',
      venue: row.venue ?? 'home',
      active: row.active ?? true,
      exercises,
    }
    const existing = await findBy(payload, 'programs', { clientId: { equals: clientId } })
    if (existing) {
      await payload.update({
        collection: 'programs',
        id: existing.id,
        overrideAccess: true,
        data: data as never,
      })
      programIdByClient.set(clientId, existing.id)
      counts.programs.updated += 1
    } else {
      const created = await payload.create({
        collection: 'programs',
        overrideAccess: true,
        data: data as never,
      })
      programIdByClient.set(clientId, created.id)
      counts.programs.created += 1
    }
  }

  for (const row of pack.trainerClients ?? []) {
    const clientId = String(row.clientId ?? '')
    const trainerId = userIdByEmail.get(String(row.trainerEmail ?? '').trim().toLowerCase())
    const athleteId = userIdByEmail.get(String(row.athleteEmail ?? '').trim().toLowerCase())
    if (!clientId || !trainerId || !athleteId) {
      counts.clients.skipped += 1
      continue
    }
    const data = {
      clientId,
      deleted: Boolean(row.deleted),
      trainer: trainerId,
      athlete: athleteId,
      status: row.status ?? 'active',
      invitedAt: row.invitedAt ?? undefined,
      acceptedAt: row.acceptedAt ?? undefined,
      endedAt: row.endedAt ?? undefined,
    }
    const existing = await findBy(payload, 'trainer-clients', { clientId: { equals: clientId } })
    if (existing) {
      await payload.update({
        collection: 'trainer-clients',
        id: existing.id,
        overrideAccess: true,
        data: data as never,
      })
      counts.clients.updated += 1
    } else {
      await payload.create({
        collection: 'trainer-clients',
        overrideAccess: true,
        data: data as never,
      })
      counts.clients.created += 1
    }
  }

  for (const row of pack.programAssignments ?? []) {
    const clientId = String(row.clientId ?? '')
    const programId = programIdByClient.get(String(row.programClientId ?? ''))
    const athleteId = userIdByEmail.get(String(row.athleteEmail ?? '').trim().toLowerCase())
    const assignedBy =
      userIdByEmail.get(String(row.assignedByEmail ?? '').trim().toLowerCase()) || athleteId
    if (!clientId || !programId || !athleteId || !assignedBy) {
      counts.assignments.skipped += 1
      continue
    }
    const legacy = legacyScheduleByProgram.get(String(row.programClientId ?? ''))
    const data = {
      clientId,
      deleted: Boolean(row.deleted),
      program: programId,
      athlete: athleteId,
      assignedBy,
      scheduleType: row.scheduleType ?? legacy?.type ?? 'weekly',
      startDate: row.startDate ?? undefined,
      endDate: row.endDate ?? undefined,
      active: row.active ?? true,
      scheduleDays: ((row.scheduleDays as Array<Record<string, unknown>>) ?? []).length
        ? (row.scheduleDays as Array<Record<string, unknown>>).map((day) => ({
            clientId: day.clientId,
            weekday: day.weekday ?? undefined,
            date: day.date ?? undefined,
          }))
        : legacy?.days,
      refinements: ((row.refinements as Array<Record<string, unknown>>) ?? []).map((item) => ({
        programExerciseClientId: item.programExerciseClientId,
        sets: item.sets ?? undefined,
        repetitions: item.repetitions ?? undefined,
        duration: item.duration ?? undefined,
        loadKg: item.loadKg ?? undefined,
        rest: item.rest ?? undefined,
        notes: item.notes ?? undefined,
      })),
    }
    const existing = await findBy(payload, 'program-assignments', { clientId: { equals: clientId } })
    if (existing) {
      await payload.update({
        collection: 'program-assignments',
        id: existing.id,
        overrideAccess: true,
        data: data as never,
      })
      counts.assignments.updated += 1
    } else {
      await payload.create({
        collection: 'program-assignments',
        overrideAccess: true,
        data: data as never,
      })
      counts.assignments.created += 1
    }
  }

  for (const row of pack.workoutSessions ?? []) {
    const clientId = String(row.clientId ?? '')
    const athleteId = userIdByEmail.get(String(row.athleteEmail ?? '').trim().toLowerCase())
    if (!clientId || !athleteId) {
      counts.sessions.skipped += 1
      continue
    }
    const exercises = ((row.exercises as Array<Record<string, unknown>>) ?? [])
      .map((item) => {
        const exerciseId = exerciseIdByClient.get(String(item.exerciseClientId ?? ''))
        if (!exerciseId) return null
        return {
          clientId: item.clientId,
          exercise: exerciseId,
          programExerciseClientId: item.programExerciseClientId ?? undefined,
          sortOrder: item.sortOrder,
          plannedSets: item.plannedSets,
          actualSets: item.actualSets ?? 0,
          plannedRepetitions: item.plannedRepetitions ?? undefined,
          actualRepetitions: item.actualRepetitions ?? undefined,
          plannedDuration: item.plannedDuration ?? undefined,
          actualDuration: item.actualDuration ?? undefined,
          completed: item.completed ?? false,
          effort: item.effort ?? undefined,
          notes: item.notes ?? undefined,
          personalRecord: item.personalRecord ?? false,
          sets: item.sets ?? [],
        }
      })
      .filter(Boolean)
    const data = {
      clientId,
      deleted: Boolean(row.deleted),
      athlete: athleteId,
      program: programIdByClient.get(String(row.programClientId ?? '')) ?? undefined,
      programDayClientId: row.programDayClientId ?? undefined,
      startedAt: row.startedAt,
      completedAt: row.completedAt ?? undefined,
      duration: row.duration ?? undefined,
      status: row.status,
      notes: row.notes ?? undefined,
      totalVolumeKg: row.totalVolumeKg ?? undefined,
      exercises,
    }
    const existing = await findBy(payload, 'workout-sessions', { clientId: { equals: clientId } })
    if (existing) {
      await payload.update({
        collection: 'workout-sessions',
        id: existing.id,
        overrideAccess: true,
        data: data as never,
      })
      counts.sessions.updated += 1
    } else {
      await payload.create({
        collection: 'workout-sessions',
        overrideAccess: true,
        data: data as never,
      })
      counts.sessions.created += 1
    }
  }

  return counts
}
