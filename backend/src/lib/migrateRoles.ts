import type { Payload } from 'payload'

import { canonicalizeRoles, storedRolesNeedRewrite } from '@/access/roles'

type UpdateMany = (
  filter: Record<string, unknown>,
  update: Record<string, unknown>,
  options?: { arrayFilters?: Array<Record<string, unknown>> },
) => Promise<{ modifiedCount?: number }>

function mongoUsers(payload: Payload): { updateMany: UpdateMany } | null {
  const db = payload.db as {
    connection?: { collection?: (name: string) => { updateMany: UpdateMany } }
  }
  if (typeof db.connection?.collection === 'function') {
    return db.connection.collection('users')
  }
  return null
}

async function rewriteLegacyRolesInMongo(payload: Payload): Promise<number> {
  const users = mongoUsers(payload)
  if (!users) return 0
  const athlete = await users.updateMany(
    { roles: 'athlete' },
    { $set: { 'roles.$[role]': 'trainee' } },
    { arrayFilters: [{ role: 'athlete' }] },
  )
  const trainer = await users.updateMany(
    { roles: 'trainer' },
    { $set: { 'roles.$[role]': 'instructor' } },
    { arrayFilters: [{ role: 'trainer' }] },
  )
  return (athlete.modifiedCount ?? 0) + (trainer.modifiedCount ?? 0)
}

export async function migrateLegacyUserRoles(payload: Payload): Promise<void> {
  const mongoChanged = await rewriteLegacyRolesInMongo(payload)

  let page = 1
  let changed = 0
  while (true) {
    const result = await payload.find({
      collection: 'users',
      depth: 0,
      limit: 100,
      overrideAccess: true,
      page,
    })
    for (const user of result.docs) {
      const next = canonicalizeRoles(user.roles)
      if (next.length === 0 || !storedRolesNeedRewrite(user.roles, next)) continue
      await payload.update({
        collection: 'users',
        id: user.id,
        overrideAccess: true,
        data: { roles: next },
      })
      changed += 1
    }
    if (!result.hasNextPage) break
    page += 1
  }

  const total = mongoChanged + changed
  if (total > 0) {
    payload.logger.info(`Migrated ${total} user role document(s) to trainee / instructor`)
  }
}
