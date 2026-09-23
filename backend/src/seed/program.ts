import type { Payload } from 'payload'

import {
  aerobicProgramClientId,
  aerobicProgramPlan,
  aerobicScheduleDays,
} from './aerobic-20min'
import { migrateProgramTemplates } from './migrate-programs'

export const defaultProgramClientId = 'program-20min'
const ownerEmail =
  process.env.PROGRAM_OWNER_EMAIL?.trim() ||
  process.env.PAYLOAD_ADMIN_EMAIL?.trim() ||
  'trainer@example.com'

type PlanRow = {
  exerciseId: string
  sortOrder: number
  sets: number
  repetitions?: number
  duration?: number
  rest: number
}

type ProgramSeed = {
  clientId: string
  name: string
  description: string
  venue: 'home' | 'gym' | 'mixed'
  assignmentClientId: string
  plan: readonly PlanRow[]
  scheduleDays: readonly { clientId: string; weekday: number }[]
}

export const defaultProgramPlan = [
  { exerciseId: 'ex-march', sortOrder: 1, sets: 1, duration: 60, rest: 0 },
  { exerciseId: 'ex-shoulder-rolls', sortOrder: 2, sets: 1, duration: 60, rest: 0 },
  { exerciseId: 'ex-cat-cow', sortOrder: 3, sets: 1, duration: 60, rest: 0 },
  { exerciseId: 'ex-worlds-stretch', sortOrder: 4, sets: 1, duration: 60, rest: 0 },
  { exerciseId: 'ex-squat', sortOrder: 5, sets: 2, repetitions: 12, rest: 30 },
  { exerciseId: 'ex-incline-pushup', sortOrder: 6, sets: 2, repetitions: 10, rest: 30 },
  { exerciseId: 'ex-reverse-lunge', sortOrder: 7, sets: 2, repetitions: 10, rest: 30 },
  { exerciseId: 'ex-glute-bridge', sortOrder: 8, sets: 2, repetitions: 12, rest: 30 },
  { exerciseId: 'ex-plank', sortOrder: 9, sets: 2, duration: 30, rest: 30 },
  { exerciseId: 'ex-cardio', sortOrder: 10, sets: 1, duration: 360, rest: 0 },
  { exerciseId: 'ex-cooldown', sortOrder: 11, sets: 1, duration: 120, rest: 0 },
] as const

const defaultScheduleDays = [
  { clientId: 'day-mon', weekday: 1 },
  { clientId: 'day-wed', weekday: 3 },
  { clientId: 'day-fri', weekday: 5 },
] as const

const seededPrograms: ProgramSeed[] = [
  {
    clientId: defaultProgramClientId,
    name: '20-Minute Home Workout',
    description: 'No-equipment full-body session.',
    venue: 'home',
    assignmentClientId: 'assignment-20min-self',
    plan: defaultProgramPlan,
    scheduleDays: defaultScheduleDays,
  },
  {
    clientId: aerobicProgramClientId,
    name: '20-Minute Aerobic Workout',
    description:
      'Low-impact aerobic session for ages 60–70+, with optional chair support. Warm-up, flow circuit, gentle power intervals, and cool-down.',
    venue: 'home',
    assignmentClientId: 'assignment-20min-aerobic-self',
    plan: aerobicProgramPlan,
    scheduleDays: aerobicScheduleDays,
  },
]

export async function seedDefaultProgram(payload: Payload): Promise<void> {
  await migrateProgramTemplates(payload)

  const owner = await findProgramOwner(payload)
  if (!owner) {
    payload.logger.warn(`Skip program seed: no user ${ownerEmail}`)
    return
  }

  for (const spec of seededPrograms) {
    await seedOneProgram(payload, owner.id, spec)
  }
}

async function findProgramOwner(payload: Payload) {
  const preferred = await payload.find({
    collection: 'users',
    depth: 0,
    limit: 1,
    pagination: false,
    where: { email: { equals: ownerEmail } },
  })
  if (preferred.docs[0]) return preferred.docs[0]

  const adminEmail = process.env.PAYLOAD_ADMIN_EMAIL
  if (!adminEmail) return null
  const admin = await payload.find({
    collection: 'users',
    depth: 0,
    limit: 1,
    pagination: false,
    where: { email: { equals: adminEmail } },
  })
  if (admin.docs[0]) {
    payload.logger.warn(`Program owner ${ownerEmail} missing; using ${adminEmail}`)
  }
  return admin.docs[0] ?? null
}

async function seedOneProgram(
  payload: Payload,
  ownerId: string,
  spec: ProgramSeed,
): Promise<void> {
  const existing = await payload.find({
    collection: 'programs',
    depth: 0,
    limit: 1,
    pagination: false,
    where: { clientId: { equals: spec.clientId } },
  })
  if (existing.docs[0]) {
    await ensureAssignment(payload, existing.docs[0].id, ownerId, spec)
    return
  }

  const exerciseIds = await mapExerciseIds(
    payload,
    spec.plan.map((row) => row.exerciseId),
  )
  const missing = spec.plan.filter((row) => !exerciseIds[row.exerciseId])
  if (missing.length > 0) {
    payload.logger.warn(
      `Skip program seed ${spec.clientId}: missing exercises ${missing.map((row) => row.exerciseId).join(', ')}`,
    )
    return
  }

  const program = await payload.create({
    collection: 'programs',
    data: {
      active: true,
      clientId: spec.clientId,
      deleted: false,
      description: spec.description,
      exercises: spec.plan.map((row) => ({
        clientId: row.exerciseId,
        exercise: exerciseIds[row.exerciseId],
        sortOrder: row.sortOrder,
        sets: row.sets,
        repetitions: row.repetitions,
        duration: row.duration,
        rest: row.rest,
      })),
      name: spec.name,
      owner: ownerId,
      venue: spec.venue,
    },
  })

  await ensureAssignment(payload, program.id, ownerId, spec)
  payload.logger.info(`Seeded program ${spec.clientId} for ${ownerEmail}`)
}

async function mapExerciseIds(
  payload: Payload,
  ids: string[],
): Promise<Record<string, string>> {
  const found = await payload.find({
    collection: 'exercises',
    depth: 0,
    limit: ids.length,
    pagination: false,
    where: { clientId: { in: ids } },
  })
  const map: Record<string, string> = {}
  for (const doc of found.docs) {
    map[doc.clientId] = doc.id
  }
  return map
}

async function ensureAssignment(
  payload: Payload,
  programId: string,
  athleteId: string,
  spec: ProgramSeed,
): Promise<void> {
  const existing = await payload.find({
    collection: 'program-assignments',
    depth: 0,
    limit: 1,
    pagination: false,
    where: {
      and: [
        { program: { equals: programId } },
        { athlete: { equals: athleteId } },
        { active: { equals: true } },
      ],
    },
  })
  const current = existing.docs[0]
  if (current) {
    const data: Record<string, unknown> = {}
    if (!current.scheduleType) data.scheduleType = 'weekly'
    if (!current.scheduleDays?.length) data.scheduleDays = [...spec.scheduleDays]
    if (Object.keys(data).length === 0) return
    await payload.update({
      collection: 'program-assignments',
      id: current.id,
      data,
    })
    return
  }

  await payload.create({
    collection: 'program-assignments',
    data: {
      active: true,
      athlete: athleteId,
      assignedBy: athleteId,
      clientId: spec.assignmentClientId,
      deleted: false,
      program: programId,
      scheduleDays: [...spec.scheduleDays],
      scheduleType: 'weekly',
      startDate: new Date().toISOString(),
    },
  })
}
