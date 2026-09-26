'use server'

import { revalidatePath } from 'next/cache'

import { getCurrentUser, getPayloadClient } from '@/lib/auth'

function readNumber(
  raw: FormDataEntryValue | null,
  label: string,
  min: number,
  max: number,
  decimals = 0,
): number | null {
  const text = String(raw ?? '').trim()
  if (!text) return null
  const value = Number(text)
  if (!Number.isFinite(value) || value < min || value > max) {
    throw new Error(`${label} must be between ${min} and ${max}.`)
  }
  const factor = 10 ** decimals
  return Math.round(value * factor) / factor
}

function readChoice<T extends string>(
  raw: FormDataEntryValue | null,
  allowed: readonly T[],
): T | null {
  const value = String(raw ?? '').trim()
  if (!value) return null
  return (allowed as readonly string[]).includes(value) ? (value as T) : null
}

export async function updateProfile(formData: FormData): Promise<{ error?: string }> {
  const user = await getCurrentUser()
  if (!user) return { error: 'Sign in to edit your profile.' }

  const name = String(formData.get('name') ?? '').trim()
  if (!name) return { error: 'Name is required.' }

  const sex = readChoice(formData.get('sex'), ['female', 'male', 'other', 'unspecified'] as const)
  const level = readChoice(formData.get('level'), [
    'beginner',
    'returning',
    'intermediate',
    'advanced',
  ] as const)
  const trainingVenue = readChoice(formData.get('trainingVenue'), [
    'home',
    'gym',
    'both',
  ] as const)
  const preferredUnits = readChoice(formData.get('preferredUnits'), ['kg', 'lbs'] as const)
  const conditionNotes = String(formData.get('conditionNotes') ?? '').trim() || null

  let age: number | null
  let weightKg: number | null
  try {
    age = readNumber(formData.get('age'), 'Age', 10, 120)
    weightKg = readNumber(formData.get('weightKg'), 'Weight', 20, 400, 1)
  } catch (error) {
    return { error: error instanceof Error ? error.message : 'Check the numbers.' }
  }

  const payload = await getPayloadClient()
  try {
    await payload.update({
      collection: 'users',
      id: user.id,
      user,
      overrideAccess: false,
      data: {
        name,
        conditionNotes,
        ...(age != null ? { age } : {}),
        ...(weightKg != null ? { weightKg } : {}),
        ...(sex ? { sex, gender: sex } : {}),
        ...(level ? { level } : {}),
        ...(trainingVenue ? { trainingVenue } : {}),
        ...(preferredUnits ? { preferredUnits } : {}),
      },
    })
  } catch (error) {
    return { error: profileSaveError(error) }
  }

  revalidatePath('/profile')
  return {}
}

function profileSaveError(error: unknown): string {
  if (error && typeof error === 'object') {
    const payload = error as {
      data?: { errors?: { message?: string }[] }
      message?: string
    }
    const fields = payload.data?.errors
      ?.map((item) => item.message)
      .filter((item): item is string => Boolean(item))
    if (fields?.length) return fields.join(' ')
    if (typeof payload.message === 'string' && payload.message.trim()) {
      return payload.message
    }
  }
  return 'Could not save your profile.'
}

export async function changePassword(formData: FormData): Promise<{ error?: string }> {
  const user = await getCurrentUser()
  if (!user?.email) return { error: 'Sign in to change your password.' }

  const current = String(formData.get('currentPassword') ?? '')
  const next = String(formData.get('newPassword') ?? '')
  const confirm = String(formData.get('confirmPassword') ?? '')

  if (!current) return { error: 'Enter your current password.' }
  if (next.length < 8) return { error: 'New password must be at least 8 characters.' }
  if (next !== confirm) return { error: 'New passwords do not match.' }
  if (next === current) return { error: 'Pick a password that is different from the current one.' }

  const payload = await getPayloadClient()
  try {
    await payload.login({
      collection: 'users',
      data: { email: user.email, password: current },
    })
  } catch {
    return { error: 'Current password is incorrect.' }
  }

  await payload.update({
    collection: 'users',
    id: user.id,
    overrideAccess: true,
    data: { password: next },
  })

  revalidatePath('/profile')
  return {}
}
