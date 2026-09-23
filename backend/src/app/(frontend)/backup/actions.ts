'use server'

import { revalidatePath } from 'next/cache'

import { isAdmin } from '@/access/roles'
import { getCurrentUser, getPayloadClient } from '@/lib/auth'
import { importStayAblePack, parseStayAblePack, type PackCounts } from '@/lib/pack'

export type ImportBackupResult = {
  error?: string
  counts?: PackCounts
}

export async function importBackupPack(raw: string): Promise<ImportBackupResult> {
  const user = await getCurrentUser()
  if (!user || !isAdmin(user)) {
    return { error: 'Admin role required.' }
  }

  const parsed = parseStayAblePack(raw)
  if (parsed.error || !parsed.pack) return { error: parsed.error }

  const payload = await getPayloadClient()
  try {
    const counts = await importStayAblePack(payload, parsed.pack)
    revalidatePath('/dashboard')
    revalidatePath('/programs')
    revalidatePath('/exercises')
    revalidatePath('/backup')
    return { counts }
  } catch (error) {
    return { error: error instanceof Error ? error.message : 'Import failed.' }
  }
}
