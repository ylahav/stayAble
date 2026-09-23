import { copyFile, stat, unlink } from 'fs/promises'
import { tmpdir } from 'os'
import path from 'path'

import type { Payload } from 'payload'

import type { SeedExercise } from './exercises'
import { ensureExercisePng } from './illustrations'

export async function ensureExerciseMedia(
  payload: Payload,
  exercise: SeedExercise,
): Promise<string> {
  const existing = await payload.find({
    collection: 'media',
    depth: 0,
    limit: 1,
    pagination: false,
    where: { clientId: { equals: exercise.clientId } },
  })
  if (existing.docs[0]) return existing.docs[0].id

  const sourcePath = await ensureExercisePng(exercise)
  const info = await stat(sourcePath)
  const tempFilePath = path.join(tmpdir(), `stayable-${exercise.clientId}.png`)
  await copyFile(sourcePath, tempFilePath)

  try {
    const created = await payload.create({
      collection: 'media',
      data: {
        alt: exercise.name.en,
        clientId: exercise.clientId,
      },
      file: {
        data: Buffer.alloc(0),
        mimetype: 'image/png',
        name: `${exercise.clientId}.png`,
        size: info.size,
        tempFilePath,
      },
    })
    return created.id
  } finally {
    await unlink(tempFilePath).catch(() => undefined)
  }
}
