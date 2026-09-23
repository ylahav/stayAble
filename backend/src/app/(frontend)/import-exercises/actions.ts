'use server'

import { revalidatePath } from 'next/cache'

import { isStaff } from '@/access/roles'
import { getCurrentUser, getPayloadClient } from '@/lib/auth'
import { parseExerciseJson, validateExerciseDraft, type DraftIssue } from '@/lib/exerciseImport'

export type ImportExercisesResult = {
  error?: string
  imported: string[]
  skipped: DraftIssue[]
}

export async function importExercises(raw: string): Promise<ImportExercisesResult> {
  const user = await getCurrentUser()
  if (!user || !isStaff(user)) {
    return { error: 'Trainer or admin role required.', imported: [], skipped: [] }
  }

  const parsed = parseExerciseJson(raw)
  if (parsed.error) return { error: parsed.error, imported: [], skipped: [] }
  if (parsed.drafts.length === 0) {
    return { error: 'No exercises found in that JSON.', imported: [], skipped: [] }
  }

  const skipped: DraftIssue[] = []
  const drafts = []
  for (const [index, row] of parsed.drafts.entries()) {
    const next = validateExerciseDraft(row, index)
    if ('reason' in next) skipped.push(next)
    else drafts.push(next)
  }

  if (drafts.length === 0) {
    return { error: 'Nothing valid to import.', imported: [], skipped }
  }

  const payload = await getPayloadClient()
  const imported: string[] = []

  for (const draft of drafts) {
    const existing = await payload.find({
      collection: 'exercises',
      depth: 0,
      limit: 1,
      pagination: false,
      user,
      overrideAccess: false,
      where: { clientId: { equals: draft.clientId } },
    })
    if (existing.docs[0]) {
      skipped.push({ clientId: draft.clientId, reason: 'Already exists' })
      continue
    }

    try {
      await payload.create({
        collection: 'exercises',
        user,
        overrideAccess: false,
        data: {
          ...draft,
          active: false,
          deleted: false,
        },
      })
      imported.push(draft.clientId)
    } catch (error) {
      skipped.push({
        clientId: draft.clientId,
        reason: error instanceof Error ? error.message : 'Could not save',
      })
    }
  }

  revalidatePath('/import-exercises')
  return { imported, skipped }
}
