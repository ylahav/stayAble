import type { Payload } from 'payload'

import { isAdmin, type AuthedUser } from './roles'

export async function athleteIdsForTrainer(
  payload: Payload,
  trainerId: string,
): Promise<string[]> {
  const links = await payload.find({
    collection: 'trainer-clients',
    depth: 0,
    limit: 500,
    overrideAccess: true,
    pagination: false,
    where: {
      and: [{ trainer: { equals: trainerId } }, { status: { equals: 'active' } }],
    },
  })

  return links.docs.map((doc) => {
    const athlete = doc.athlete
    return typeof athlete === 'string' ? athlete : athlete.id
  })
}

export async function trainerCanSeeAthlete(
  payload: Payload,
  trainer: AuthedUser,
  athleteId: string,
): Promise<boolean> {
  if (isAdmin(trainer)) return true
  const ids = await athleteIdsForTrainer(payload, trainer.id)
  return ids.includes(athleteId)
}
