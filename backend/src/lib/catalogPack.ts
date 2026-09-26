import { readFile, unlink, writeFile } from 'fs/promises'
import { tmpdir } from 'os'
import path from 'path'

import type { Payload, PayloadRequest, Where } from 'payload'

import { isStaff, type AuthedUser } from '@/access/roles'
import { relId } from '@/lib/relations'
import type { PackMedia } from '@/lib/pack'

export const CATALOG_KIND = 'stayable-catalog' as const
export const CATALOG_VERSION = 1 as const

export type CatalogCollection = 'exercises' | 'programs' | 'media'

export type CatalogPack = {
  version: typeof CATALOG_VERSION
  kind: typeof CATALOG_KIND
  collection: CatalogCollection
  exportedAt: string
  media: PackMedia[]
  exercises: Record<string, unknown>[]
  programs: Record<string, unknown>[]
}

export type CatalogCounts = {
  media: { created: number; updated: number; skipped: number }
  exercises: { created: number; updated: number; skipped: number }
  programs: { created: number; updated: number; skipped: number }
  warnings: string[]
}

type Doc = { id: string } & Record<string, unknown>

function loc(value: unknown): { en: string; he: string } {
  const group = value as { en?: string | null; he?: string | null } | null
  const en = group?.en?.trim() || group?.he?.trim() || '—'
  return { en, he: group?.he || '' }
}

function emptyCounts(): CatalogCounts {
  return {
    media: { created: 0, updated: 0, skipped: 0 },
    exercises: { created: 0, updated: 0, skipped: 0 },
    programs: { created: 0, updated: 0, skipped: 0 },
    warnings: [],
  }
}

function asIdList(value: unknown): string[] {
  if (!Array.isArray(value)) return []
  return value.map((id) => String(id)).filter(Boolean)
}

async function findDocs(
  payload: Payload,
  collection: CatalogCollection,
  req: PayloadRequest,
  where: Where,
  depth = 0,
): Promise<Doc[]> {
  const docs: Doc[] = []
  let page = 1
  for (;;) {
    const result = await payload.find({
      collection,
      depth,
      limit: 200,
      page,
      pagination: true,
      overrideAccess: false,
      req,
      user: req.user ?? undefined,
      where,
    })
    docs.push(...(result.docs as unknown as Doc[]))
    if (!result.hasNextPage) break
    page += 1
  }
  return docs
}

async function findByClient(
  payload: Payload,
  collection: 'media' | 'exercises' | 'programs' | 'users',
  clientKey: 'clientId' | 'email' | 'filename',
  value: string,
): Promise<Doc | null> {
  const result = await payload.find({
    collection,
    depth: 0,
    limit: 1,
    overrideAccess: true,
    pagination: false,
    where: { [clientKey]: { equals: value } },
  })
  return (result.docs[0] as unknown as Doc | undefined) ?? null
}

async function packMediaDoc(row: Doc): Promise<PackMedia | null> {
  const filename = String(row.filename ?? '')
  if (!filename) return null
  const filePath = path.resolve('media', filename)
  try {
    const buffer = await readFile(filePath)
    return {
      clientId: (row.clientId as string | null) || mediaKey({ filename }),
      filename,
      alt: String(row.alt ?? filename),
      mimeType: String(row.mimeType ?? 'image/png'),
      data: buffer.toString('base64'),
    }
  } catch {
    return null
  }
}

function workoutTypeFromCategory(category: unknown): 'strength' | 'aerobic' | 'hiit' | 'functional' {
  if (category === 'strength') return 'strength'
  if (category === 'cardio') return 'aerobic'
  return 'functional'
}

function packExercise(row: Doc): Record<string, unknown> {
  const image = row.image as { clientId?: string | null; filename?: string | null } | string | null
  const imageClientId =
    image && typeof image === 'object'
      ? image.clientId || (image.filename ? String(image.filename).replace(/\.[^.]+$/, '') : null)
      : null
  return {
    clientId: row.clientId,
    deleted: row.deleted ?? false,
    name: loc(row.name),
    description: loc(row.description),
    instructions: loc(row.instructions),
    safetyNotes: loc(row.safetyNotes),
    photoPath: row.photoPath ?? '',
    category: row.category,
    difficulty: row.difficulty,
    venue: row.venue ?? 'both',
    workoutType: row.workoutType ?? workoutTypeFromCategory(row.category),
    gymNumber: row.gymNumber ?? null,
    duration: row.duration ?? null,
    repetitions: row.repetitions ?? null,
    targetMuscles: row.targetMuscles ?? [],
    equipment: row.equipment ?? 'none',
    active: row.active ?? true,
    imageClientId,
  }
}

function packProgram(row: Doc, exerciseClientById: Map<string, string>, ownerEmail: string | null) {
  return {
    clientId: row.clientId,
    deleted: row.deleted ?? false,
    ownerEmail,
    name: row.name,
    description: row.description ?? '',
    venue: row.venue ?? 'home',
    active: row.active ?? true,
    exercises: ((row.exercises as Array<Record<string, unknown>>) ?? []).map((item) => ({
      clientId: item.clientId,
      exerciseClientId: exerciseClientById.get(relId(item.exercise)) || null,
      sortOrder: item.sortOrder,
      sets: item.sets,
      repetitions: item.repetitions ?? null,
      duration: item.duration ?? null,
      loadKg: item.loadKg ?? null,
      rest: item.rest ?? 0,
      notes: item.notes ?? null,
    })),
  }
}

function mediaKey(row: { clientId?: string | null; filename?: string | null }): string {
  return String(row.clientId || '').trim() || String(row.filename || '').replace(/\.[^.]+$/, '')
}

function collectExerciseIds(programs: Doc[]): string[] {
  const ids = new Set<string>()
  for (const program of programs) {
    for (const item of (program.exercises as Array<Record<string, unknown>> | undefined) ?? []) {
      const id = relId(item.exercise)
      if (id) ids.add(id)
    }
  }
  return [...ids]
}

function collectMediaFromExercises(exercises: Doc[]): Doc[] {
  const byId = new Map<string, Doc>()
  for (const exercise of exercises) {
    const image = exercise.image
    if (image && typeof image === 'object' && 'id' in image) {
      const doc = image as Doc
      byId.set(doc.id, doc)
    }
  }
  return [...byId.values()]
}

export function parseCatalogPack(raw: string): { pack?: CatalogPack; error?: string } {
  let parsed: unknown
  try {
    parsed = JSON.parse(raw)
  } catch {
    return { error: 'That file is not valid JSON.' }
  }
  if (!parsed || typeof parsed !== 'object') return { error: 'Empty pack.' }
  const pack = parsed as Partial<CatalogPack> & { kind?: string; version?: number }
  if (pack.kind !== CATALOG_KIND) {
    return { error: 'Not a StayAble catalog pack. Export from Exercises, Programs, or Media.' }
  }
  if (pack.version !== CATALOG_VERSION) {
    return { error: `Unsupported pack version ${String(pack.version)}.` }
  }
  return {
    pack: {
      version: CATALOG_VERSION,
      kind: CATALOG_KIND,
      collection: pack.collection === 'programs' || pack.collection === 'media' ? pack.collection : 'exercises',
      exportedAt: String(pack.exportedAt ?? new Date().toISOString()),
      media: Array.isArray(pack.media) ? pack.media : [],
      exercises: Array.isArray(pack.exercises) ? pack.exercises : [],
      programs: Array.isArray(pack.programs) ? pack.programs : [],
    },
  }
}

export async function exportCatalogPack(
  req: PayloadRequest,
  collection: CatalogCollection,
  body: { ids?: unknown; where?: unknown },
): Promise<{ pack?: CatalogPack; error?: string; status?: number }> {
  const user = req.user as AuthedUser | null
  if (!user || !isStaff(user)) {
    return { error: 'Trainer or admin role required.', status: 403 }
  }

  const ids = asIdList(body.ids)
  const where = (
    ids.length > 0
      ? { id: { in: ids } }
      : body.where && typeof body.where === 'object'
        ? (body.where as Where)
        : null
  ) as Where | null
  if (!where) {
    return { error: 'Select one or more rows to export.', status: 400 }
  }

  const payload = req.payload
  let mediaDocs: Doc[] = []
  let exercises: Doc[] = []
  let programs: Doc[] = []

  if (collection === 'media') {
    mediaDocs = await findDocs(payload, 'media', req, where)
  } else if (collection === 'exercises') {
    exercises = await findDocs(payload, 'exercises', req, where, 1)
    mediaDocs = collectMediaFromExercises(exercises)
  } else {
    programs = await findDocs(payload, 'programs', req, where, 1)
    const exerciseIds = collectExerciseIds(programs)
    if (exerciseIds.length > 0) {
      exercises = await findDocs(payload, 'exercises', req, { id: { in: exerciseIds } }, 1)
    }
    mediaDocs = collectMediaFromExercises(exercises)
  }

  if (mediaDocs.length === 0 && exercises.length === 0 && programs.length === 0) {
    return { error: 'Nothing matched that selection.', status: 404 }
  }

  const media: PackMedia[] = []
  for (const row of mediaDocs) {
    const packed = await packMediaDoc(row)
    if (packed) media.push(packed)
  }

  const exerciseClientById = new Map(exercises.map((row) => [row.id, String(row.clientId ?? '')]))
  const ownerEmailById = new Map<string, string>()
  for (const program of programs) {
    const ownerId = relId(program.owner)
    if (!ownerId || ownerEmailById.has(ownerId)) continue
    try {
      const owner = await payload.findByID({
        collection: 'users',
        id: ownerId,
        depth: 0,
        overrideAccess: true,
      })
      if (owner.email) ownerEmailById.set(ownerId, String(owner.email))
    } catch {
      // fall back to the current user below
    }
  }

  return {
    pack: {
      version: CATALOG_VERSION,
      kind: CATALOG_KIND,
      collection,
      exportedAt: new Date().toISOString(),
      media,
      exercises: exercises.map(packExercise),
      programs: programs.map((row) =>
        packProgram(
          row,
          exerciseClientById,
          ownerEmailById.get(relId(row.owner)) || user.email || null,
        ),
      ),
    },
  }
}

export async function importCatalogPack(
  req: PayloadRequest,
  pack: CatalogPack,
): Promise<{ counts?: CatalogCounts; error?: string; status?: number }> {
  const user = req.user as AuthedUser | null
  if (!user || !isStaff(user)) {
    return { error: 'Trainer or admin role required.', status: 403 }
  }

  const payload = req.payload
  const counts = emptyCounts()
  const mediaIdByClient = new Map<string, string>()

  for (const file of pack.media ?? []) {
    if (!file.data || !file.filename) {
      counts.media.skipped += 1
      continue
    }
    const clientId = mediaKey(file)
    const existing =
      (clientId ? await findByClient(payload, 'media', 'clientId', clientId) : null) ??
      (await findByClient(payload, 'media', 'filename', file.filename))
    const buffer = Buffer.from(file.data, 'base64')
    const tempFilePath = path.join(tmpdir(), `catalog-${clientId || 'file'}-${file.filename}`)
    await writeFile(tempFilePath, buffer)
    try {
      const body = {
        collection: 'media' as const,
        overrideAccess: true,
        data: { alt: file.alt || clientId, clientId },
        file: {
          data: Buffer.alloc(0),
          mimetype: file.mimeType || 'image/png',
          name: file.filename,
          size: buffer.length,
          tempFilePath,
        },
      }
      const doc = existing
        ? await payload.update({ ...body, id: existing.id })
        : await payload.create(body)
      if (clientId) mediaIdByClient.set(clientId, doc.id)
      if (existing) counts.media.updated += 1
      else counts.media.created += 1
    } finally {
      await unlink(tempFilePath).catch(() => undefined)
    }
  }

  const exerciseIdByClient = new Map<string, string>()
  for (const row of pack.exercises ?? []) {
    const clientId = String(row.clientId ?? '')
    if (!clientId) {
      counts.exercises.skipped += 1
      continue
    }
    const imageClientId = String(row.imageClientId ?? clientId)
    const data = {
      clientId,
      deleted: Boolean(row.deleted),
      name: loc(row.name),
      description: loc(row.description),
      instructions: loc(row.instructions),
      safetyNotes: loc(row.safetyNotes),
      photoPath: row.photoPath ?? '',
      category: row.category,
      difficulty: row.difficulty,
      venue: row.venue ?? 'both',
      workoutType: row.workoutType ?? workoutTypeFromCategory(row.category),
      gymNumber: row.gymNumber ?? undefined,
      duration: row.duration ?? undefined,
      repetitions: row.repetitions ?? undefined,
      targetMuscles: row.targetMuscles ?? [],
      equipment: row.equipment ?? 'none',
      active: row.active ?? true,
      image: mediaIdByClient.get(imageClientId) ?? undefined,
    }
    const existing = await findByClient(payload, 'exercises', 'clientId', clientId)
    if (existing) {
      await payload.update({
        collection: 'exercises',
        id: existing.id,
        overrideAccess: true,
        data: data as never,
      })
      exerciseIdByClient.set(clientId, existing.id)
      counts.exercises.updated += 1
    } else {
      const created = await payload.create({
        collection: 'exercises',
        overrideAccess: true,
        data: data as never,
      })
      exerciseIdByClient.set(clientId, created.id)
      counts.exercises.created += 1
    }
  }

  for (const row of pack.programs ?? []) {
    const clientId = String(row.clientId ?? '')
    if (!clientId) {
      counts.programs.skipped += 1
      continue
    }
    const ownerEmail = String(row.ownerEmail ?? '')
      .trim()
      .toLowerCase()
    const owner =
      (ownerEmail ? await findByClient(payload, 'users', 'email', ownerEmail) : null) ??
      ({ id: user.id } as Doc)
    const exercises = []
    for (const item of (row.exercises as Array<Record<string, unknown>>) ?? []) {
      const exerciseClientId = String(item.exerciseClientId ?? '')
      let exerciseId = exerciseIdByClient.get(exerciseClientId)
      if (!exerciseId && exerciseClientId) {
        const existingExercise = await findByClient(payload, 'exercises', 'clientId', exerciseClientId)
        if (existingExercise) {
          exerciseId = existingExercise.id
          exerciseIdByClient.set(exerciseClientId, existingExercise.id)
        }
      }
      if (!exerciseId) {
        counts.warnings.push(`Program ${clientId}: missing exercise ${exerciseClientId || '?'}`)
        continue
      }
      exercises.push({
        clientId: String(item.clientId ?? `slot-${item.sortOrder ?? 1}`),
        exercise: exerciseId,
        sortOrder: item.sortOrder,
        sets: item.sets,
        repetitions: item.repetitions ?? undefined,
        duration: item.duration ?? undefined,
        loadKg: item.loadKg ?? undefined,
        rest: item.rest ?? 0,
        notes: item.notes ?? undefined,
      })
    }
    const data = {
      clientId,
      deleted: Boolean(row.deleted),
      owner: owner.id,
      name: row.name,
      description: row.description ?? '',
      venue: row.venue ?? 'home',
      active: row.active ?? true,
      exercises,
    }
    const existing = await findByClient(payload, 'programs', 'clientId', clientId)
    if (existing) {
      await payload.update({
        collection: 'programs',
        id: existing.id,
        overrideAccess: true,
        data: data as never,
      })
      counts.programs.updated += 1
    } else {
      await payload.create({
        collection: 'programs',
        overrideAccess: true,
        data: data as never,
      })
      counts.programs.created += 1
    }
  }

  return { counts }
}

export function catalogFilename(collection: CatalogCollection, exportedAt: string): string {
  const day = exportedAt.slice(0, 10) || new Date().toISOString().slice(0, 10)
  return `stayable-${collection}-${day}.json`
}
