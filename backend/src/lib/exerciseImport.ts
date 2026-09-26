const categories = ['warmUp', 'mobility', 'strength', 'cardio', 'stretching', 'coolDown'] as const
const difficulties = ['beginner', 'intermediate', 'advanced'] as const
const equipmentKinds = [
  'none',
  'mat',
  'resistanceBand',
  'dumbbells',
  'chair',
  'machine',
  'barbell',
  'cable',
  'kettlebell',
  'bench',
] as const
const venues = ['home', 'gym', 'both'] as const
const workoutTypes = ['strength', 'aerobic', 'hiit', 'functional'] as const

function workoutTypeFromCategory(
  category: (typeof categories)[number],
): (typeof workoutTypes)[number] {
  if (category === 'strength') return 'strength'
  if (category === 'cardio') return 'aerobic'
  return 'functional'
}
const clientIdPattern = /^ex-[a-z0-9]+(?:-[a-z0-9]+)*$/

export type ExerciseDraft = {
  clientId: string
  name: { en: string; he?: string | null }
  description: { en: string; he?: string | null }
  instructions: { en: string; he?: string | null }
  safetyNotes: { en: string; he?: string | null }
  category: (typeof categories)[number]
  difficulty: (typeof difficulties)[number]
  duration?: number | null
  repetitions?: number | null
  targetMuscles?: string[] | null
  equipment: (typeof equipmentKinds)[number]
  venue: (typeof venues)[number]
  workoutType: (typeof workoutTypes)[number]
  gymNumber?: number | null
  photoPath?: string | null
  active: false
  deleted: false
}

export type DraftIssue = { clientId: string; reason: string }

function unwrapJson(raw: string): string {
  let text = raw.trim()
  if (text.startsWith('```')) {
    text = text.replace(/^```(?:json)?\s*/i, '').replace(/\s*```$/, '')
  }
  return text.trim()
}

function asRecord(value: unknown): Record<string, unknown> | null {
  if (value && typeof value === 'object' && !Array.isArray(value)) {
    return value as Record<string, unknown>
  }
  return null
}

function localized(value: unknown, label: string, required = true): { en: string; he?: string } {
  const row = asRecord(value)
  if (!row) {
    throw new Error(`${label} must be { "en": "...", "he": "..." }`)
  }
  const en = String(row.en ?? '').trim()
  const he = String(row.he ?? '').trim()
  if (required && !en) throw new Error(`${label}.en is required`)
  return he ? { en: en || he, he } : { en }
}

function optionalNumber(value: unknown, label: string): number | null {
  if (value == null || value === '') return null
  const n = Number(value)
  if (!Number.isFinite(n) || n < 0) throw new Error(`${label} must be a positive number`)
  return Math.round(n)
}

function oneOf<T extends string>(value: unknown, allowed: readonly T[], label: string, fallback?: T): T {
  if (value == null || value === '') {
    if (fallback) return fallback
    throw new Error(`${label} is required`)
  }
  const text = String(value)
  if ((allowed as readonly string[]).includes(text)) return text as T
  throw new Error(`${label} must be one of: ${allowed.join(', ')}`)
}

export function parseExerciseJson(raw: string): { drafts: unknown[]; error?: string } {
  if (!raw.trim()) return { drafts: [], error: 'Paste or drop JSON first.' }
  let parsed: unknown
  try {
    parsed = JSON.parse(unwrapJson(raw))
  } catch {
    return { drafts: [], error: 'That is not valid JSON. Copy the object or array only.' }
  }

  if (Array.isArray(parsed)) return { drafts: parsed }
  const row = asRecord(parsed)
  if (!row) return { drafts: [], error: 'JSON must be an object or an array of objects.' }
  if (Array.isArray(row.exercises)) return { drafts: row.exercises }
  return { drafts: [row] }
}

export function validateExerciseDraft(value: unknown, index: number): ExerciseDraft | DraftIssue {
  const row = asRecord(value)
  const fallbackId = `item ${index + 1}`
  if (!row) return { clientId: fallbackId, reason: 'Not an object' }

  try {
    const clientId = String(row.clientId ?? '').trim().toLowerCase()
    if (!clientIdPattern.test(clientId)) {
      throw new Error('clientId must look like ex-hip-hinge (lowercase, hyphenated)')
    }
    const duration = optionalNumber(row.duration, 'duration')
    const repetitions = optionalNumber(row.repetitions, 'repetitions')
    const category = oneOf(row.category, categories, 'category')
    const muscles = Array.isArray(row.targetMuscles)
      ? row.targetMuscles.map((item) => String(item).trim()).filter(Boolean)
      : []
    const photoPath = String(row.photoPath ?? '').trim() || null
    const safetyNotes = row.safetyNotes
      ? localized(row.safetyNotes, 'safetyNotes', false)
      : {
          en: 'Move within a comfortable range. Stop if you feel sharp pain.',
          he: 'הישארו בטווח נוח. עצרו אם מופיע כאב חד.',
        }
    if (!safetyNotes.en) {
      safetyNotes.en = 'Move within a comfortable range. Stop if you feel sharp pain.'
    }

    return {
      clientId,
      name: localized(row.name, 'name'),
      description: localized(row.description, 'description'),
      instructions: localized(row.instructions, 'instructions'),
      safetyNotes,
      category,
      difficulty: oneOf(row.difficulty, difficulties, 'difficulty'),
      duration,
      repetitions,
      targetMuscles: muscles,
      equipment: oneOf(row.equipment, equipmentKinds, 'equipment', 'none'),
      venue: oneOf(row.venue, venues, 'venue', 'both'),
      workoutType: oneOf(
        row.workoutType,
        workoutTypes,
        'workoutType',
        workoutTypeFromCategory(category),
      ),
      gymNumber: optionalNumber(row.gymNumber, 'gymNumber'),
      photoPath,
      active: false,
      deleted: false,
    }
  } catch (error) {
    return {
      clientId: String(row.clientId ?? fallbackId),
      reason: error instanceof Error ? error.message : 'Invalid exercise',
    }
  }
}
