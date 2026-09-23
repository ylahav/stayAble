import type { Payload } from 'payload'

import { defaultProgramClientId, defaultProgramPlan } from './program'

const ownerEmail =
  process.env.PROGRAM_OWNER_EMAIL?.trim() ||
  process.env.PAYLOAD_ADMIN_EMAIL?.trim() ||
  'trainer@example.com'
const sessionClientId = 'session-local-completed'

function lastFriday(from: Date): Date {
  const date = new Date(from)
  const day = date.getDay()
  const back = day >= 5 ? day - 5 : day + 2
  date.setDate(date.getDate() - back)
  date.setHours(18, 12, 0, 0)
  return date
}

export async function seedCompletedSession(payload: Payload): Promise<void> {
  const users = await payload.find({
    collection: 'users',
    depth: 0,
    limit: 1,
    pagination: false,
    where: { email: { equals: ownerEmail } },
  })
  const athlete = users.docs[0]
  if (!athlete) {
    payload.logger.warn(`Skip session seed: no user ${ownerEmail}`)
    return
  }

  const existing = await payload.find({
    collection: 'workout-sessions',
    depth: 0,
    limit: 1,
    pagination: false,
    where: { clientId: { equals: sessionClientId } },
  })
  if (existing.docs[0]) {
    if (existing.docs[0].athlete !== athlete.id) {
      await payload.update({
        collection: 'workout-sessions',
        id: existing.docs[0].id,
        data: { athlete: athlete.id },
      })
      payload.logger.info(`Reassigned seeded session to ${ownerEmail}`)
    }
    return
  }

  const programs = await payload.find({
    collection: 'programs',
    depth: 0,
    limit: 1,
    pagination: false,
    where: { clientId: { equals: defaultProgramClientId } },
  })
  const program = programs.docs[0]
  if (!program) {
    payload.logger.warn('Skip session seed: program-20min missing')
    return
  }

  const catalog = await payload.find({
    collection: 'exercises',
    depth: 0,
    limit: 50,
    pagination: false,
    where: { clientId: { in: defaultProgramPlan.map((row) => row.exerciseId) } },
  })
  const exerciseIds: Record<string, string> = {}
  for (const doc of catalog.docs) {
    exerciseIds[doc.clientId] = doc.id
  }
  const missing = defaultProgramPlan.filter((row) => !exerciseIds[row.exerciseId])
  if (missing.length > 0) {
    payload.logger.warn(
      `Skip session seed: missing exercises ${missing.map((row) => row.exerciseId).join(', ')}`,
    )
    return
  }

  const startedAt = lastFriday(new Date())
  const duration = 21 * 60
  const completedAt = new Date(startedAt.getTime() + duration * 1000)

  await payload.create({
    collection: 'workout-sessions',
    data: {
      activeDeviceId: 'seed-local',
      athlete: athlete.id,
      clientId: sessionClientId,
      completedAt: completedAt.toISOString(),
      deleted: false,
      duration,
      program: program.id,
      programDayClientId: 'day-fri',
      startedAt: startedAt.toISOString(),
      status: 'completed',
      exercises: defaultProgramPlan.map((row) => {
        const plannedDuration = 'duration' in row ? row.duration : undefined
        const plannedReps = 'repetitions' in row ? row.repetitions : undefined
        return {
          actualDuration: plannedDuration,
          actualRepetitions: plannedReps ? plannedReps * row.sets : undefined,
          actualSets: row.sets,
          clientId: `${sessionClientId}-${row.exerciseId}`,
          completed: true,
          effort: row.sortOrder >= 9 ? ('good' as const) : ('easy' as const),
          exercise: exerciseIds[row.exerciseId],
          plannedDuration,
          plannedRepetitions: plannedReps,
          plannedSets: row.sets,
          programExerciseClientId: row.exerciseId,
          sortOrder: row.sortOrder,
          sets: Array.from({ length: row.sets }, (_, index) => ({
            actualDuration: plannedDuration,
            actualReps: plannedReps,
            clientId: `${sessionClientId}-${row.exerciseId}-set-${index + 1}`,
            completed: true,
            plannedDuration,
            plannedReps,
            setNumber: index + 1,
          })),
        }
      }),
    },
  })

  payload.logger.info(`Seeded completed session for ${ownerEmail}`)
}
