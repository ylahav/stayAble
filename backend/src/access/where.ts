import type { Where } from 'payload'

export function selfOrIn(field: string, userId: string, extraIds: string[]): Where {
  if (extraIds.length === 0) {
    return { [field]: { equals: userId } }
  }
  return {
    or: [{ [field]: { equals: userId } }, { [field]: { in: extraIds } }],
  }
}

export function eitherParty(userId: string): Where {
  return {
    or: [{ trainer: { equals: userId } }, { athlete: { equals: userId } }],
  }
}

export function athleteIn(ids: string[]): Where {
  return { athlete: { in: ids } }
}

export function selfAssigned(userId: string): Where {
  return {
    and: [{ athlete: { equals: userId } }, { assignedBy: { equals: userId } }],
  }
}

export function ownerOrIds(userId: string, programIds: string[]): Where {
  if (programIds.length === 0) {
    return { owner: { equals: userId } }
  }
  return {
    or: [{ owner: { equals: userId } }, { id: { in: programIds } }],
  }
}
