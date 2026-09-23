import type { Payload } from 'payload'

/** Past sessions keep their logged sets. Assignments go away with the template. */
export async function detachProgramUsage(payload: Payload, programId: string): Promise<void> {
  const assignments = await payload.find({
    collection: 'program-assignments',
    depth: 0,
    limit: 500,
    overrideAccess: true,
    pagination: false,
    where: { program: { equals: programId } },
  })
  for (const row of assignments.docs) {
    await payload.delete({
      collection: 'program-assignments',
      id: row.id,
      overrideAccess: true,
    })
  }

  const sessions = await payload.find({
    collection: 'workout-sessions',
    depth: 0,
    limit: 1000,
    overrideAccess: true,
    pagination: false,
    where: { program: { equals: programId } },
  })
  for (const row of sessions.docs) {
    await payload.update({
      collection: 'workout-sessions',
      id: row.id,
      overrideAccess: true,
      data: { program: null },
    })
  }
}
