'use server'

import { revalidatePath } from 'next/cache'

import { hasRole, isAdmin } from '@/access/roles'
import { getCurrentUser, getPayloadClient } from '@/lib/auth'
import { relId } from '@/lib/relations'
import { parseScheduleType, scheduleDaysFor } from '@/lib/schedule'

export async function inviteAthlete(formData: FormData): Promise<{ error?: string }> {
  const user = await getCurrentUser()
  if (!user || !hasRole(user, 'trainer')) return { error: 'Trainer role required.' }

  const email = String(formData.get('email') ?? '')
    .trim()
    .toLowerCase()
  if (!email) return { error: 'Enter an email.' }

  const payload = await getPayloadClient()
  const found = await payload.find({
    collection: 'users',
    depth: 0,
    limit: 1,
    overrideAccess: true,
    where: { email: { equals: email } },
  })
  const athlete = found.docs[0]
  if (!athlete) return { error: 'No account with that email.' }
  if (athlete.id === user.id) return { error: 'You cannot invite yourself.' }

  const existing = await payload.find({
    collection: 'trainer-clients',
    depth: 0,
    limit: 1,
    overrideAccess: true,
    where: {
      and: [{ trainer: { equals: user.id } }, { athlete: { equals: athlete.id } }],
    },
  })
  if (existing.docs[0] && existing.docs[0].status !== 'ended') {
    return { error: 'That person is already on your roster.' }
  }

  await payload.create({
    collection: 'trainer-clients',
    overrideAccess: true,
    data: {
      athlete: athlete.id,
      clientId: crypto.randomUUID(),
      invitedAt: new Date().toISOString(),
      status: 'invited',
      trainer: user.id,
    },
  })

  revalidatePath('/dashboard')
  return {}
}

export async function assignProgram(formData: FormData): Promise<{ error?: string }> {
  const user = await getCurrentUser()
  if (!user || !hasRole(user, 'trainer')) return { error: 'Trainer role required.' }

  const athleteId = String(formData.get('athleteId') ?? '')
  const programId = String(formData.get('programId') ?? '')
  const startDate = String(formData.get('startDate') ?? '')
  const scheduleType = parseScheduleType(String(formData.get('scheduleType') ?? '')) ?? 'weekly'
  const weekdays = formData
    .getAll('weekday')
    .map((value) => Number(value))
    .filter((value) => Number.isInteger(value) && value >= 1 && value <= 7)
  if (!athleteId || !programId) return { error: 'Choose a client and a program.' }

  const payload = await getPayloadClient()
  const links = await payload.find({
    collection: 'trainer-clients',
    depth: 0,
    limit: 1,
    user,
    overrideAccess: false,
    where: {
      and: [
        { trainer: { equals: user.id } },
        { athlete: { equals: athleteId } },
        { status: { equals: 'active' } },
      ],
    },
  })
  if (links.totalDocs === 0) return { error: 'Client must accept the invite first.' }

  const foundPrograms = await payload.find({
    collection: 'programs',
    depth: 0,
    limit: 1,
    overrideAccess: true,
    where: { id: { equals: programId } },
  })
  const program = foundPrograms.docs[0]
  if (!program) return { error: 'Program not found.' }
  if (relId(program.owner) !== user.id && !isAdmin(user)) {
    return { error: 'You can only assign a program you own.' }
  }
  const scheduleDays = scheduleDaysFor(scheduleType, weekdays)

  const existing = await payload.find({
    collection: 'program-assignments',
    depth: 0,
    limit: 1,
    overrideAccess: true,
    where: {
      and: [{ athlete: { equals: athleteId } }, { program: { equals: programId } }],
    },
    sort: '-updatedAt',
  })
  const current = existing.docs[0]
  if (current) {
    await payload.update({
      collection: 'program-assignments',
      id: current.id,
      overrideAccess: true,
      data: {
        active: true,
        assignedBy: user.id,
        endDate: null,
        scheduleType,
        ...(scheduleDays ? { scheduleDays } : {}),
        startDate: startDate || current.startDate || new Date().toISOString(),
      },
    })
  } else {
    await payload.create({
      collection: 'program-assignments',
      overrideAccess: true,
      data: {
        active: true,
        athlete: athleteId,
        assignedBy: user.id,
        clientId: crypto.randomUUID(),
        program: programId,
        scheduleDays,
        scheduleType,
        startDate: startDate || new Date().toISOString(),
      },
    })
  }

  revalidatePath('/dashboard')
  return {}
}

export async function deleteProgram(formData: FormData): Promise<{ error?: string }> {
  const user = await getCurrentUser()
  if (!user || !isAdmin(user)) return { error: 'Admin role required.' }

  const programId = String(formData.get('programId') ?? '')
  if (!programId) return { error: 'Choose a program.' }

  const payload = await getPayloadClient()
  const found = await payload.find({
    collection: 'programs',
    depth: 0,
    limit: 1,
    overrideAccess: true,
    where: { id: { equals: programId } },
  })
  if (!found.docs[0]) return { error: 'Program not found.' }

  await payload.delete({
    collection: 'programs',
    id: programId,
    user,
    overrideAccess: false,
  })

  revalidatePath('/dashboard')
  revalidatePath('/programs')
  return {}
}

export async function acceptOwnInvite(): Promise<void> {
  const user = await getCurrentUser()
  if (!user) return
  const payload = await getPayloadClient()
  const pending = await payload.find({
    collection: 'trainer-clients',
    depth: 0,
    limit: 20,
    user,
    overrideAccess: false,
    where: {
      and: [{ athlete: { equals: user.id } }, { status: { equals: 'invited' } }],
    },
  })
  for (const row of pending.docs) {
    if (relId(row.athlete) !== user.id) continue
    await payload.update({
      collection: 'trainer-clients',
      id: row.id,
      user,
      overrideAccess: false,
      data: { status: 'active' },
    })
  }
  revalidatePath('/programs')
  revalidatePath('/dashboard')
}
