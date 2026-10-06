import { relEmail, relId, relName } from './relations'

export type BodyScan = {
  id: string
  traineeId: string
  traineeName: string
  measuredAt: string
  source: string
  sourceUserId?: string | null
  filename?: string | null
  heightCm?: number | null
  age?: number | null
  weightKg?: number | null
  bmi?: number | null
  bodyFatPercent?: number | null
  fatMassKg?: number | null
  fatFreeMassKg?: number | null
  muscleMassKg?: number | null
  boneMassKg?: number | null
  proteinKg?: number | null
  bodyWaterPercent?: number | null
  bodyWaterKg?: number | null
  bmrKcal?: number | null
  bmrKj?: number | null
  metabolicAge?: number | null
  visceralFat?: number | null
}

export const SCAN_METRICS = [
  { key: 'weightKg', label: 'Weight', suffix: ' kg' },
  { key: 'bodyFatPercent', label: 'Body fat', suffix: ' %' },
  { key: 'fatMassKg', label: 'Fat mass', suffix: ' kg' },
  { key: 'muscleMassKg', label: 'Muscle', suffix: ' kg' },
  { key: 'fatFreeMassKg', label: 'Fat-free', suffix: ' kg' },
  { key: 'bmi', label: 'BMI', suffix: '' },
  { key: 'bodyWaterPercent', label: 'Water', suffix: ' %' },
  { key: 'bodyWaterKg', label: 'Water mass', suffix: ' kg' },
  { key: 'boneMassKg', label: 'Bone', suffix: ' kg' },
  { key: 'proteinKg', label: 'Protein', suffix: ' kg' },
  { key: 'bmrKcal', label: 'BMR', suffix: ' kcal' },
  { key: 'visceralFat', label: 'Visceral fat', suffix: '' },
  { key: 'metabolicAge', label: 'Metabolic age', suffix: '' },
] as const satisfies ReadonlyArray<{
  key: keyof BodyScan
  label: string
  suffix: string
}>

type ScanDoc = {
  id: string
  athlete?: unknown
  measuredAt: string
  source?: string | null
  sourceUserId?: string | null
  filename?: string | null
  heightCm?: number | null
  age?: number | null
  weightKg?: number | null
  bmi?: number | null
  bodyFatPercent?: number | null
  fatMassKg?: number | null
  fatFreeMassKg?: number | null
  muscleMassKg?: number | null
  boneMassKg?: number | null
  proteinKg?: number | null
  bodyWaterPercent?: number | null
  bodyWaterKg?: number | null
  bmrKcal?: number | null
  bmrKj?: number | null
  metabolicAge?: number | null
  visceralFat?: number | null
}

function asIso(value: unknown): string {
  if (typeof value === 'string' && value) return value
  if (value instanceof Date && !Number.isNaN(value.getTime())) return value.toISOString()
  return ''
}

export function bodyScanFromDoc(row: ScanDoc, fallbackName = ''): BodyScan {
  const traineeId = relId(row.athlete)
  return {
    id: row.id,
    traineeId,
    traineeName: relName(row.athlete) || relEmail(row.athlete) || fallbackName || traineeId,
    measuredAt: asIso(row.measuredAt),
    source: row.source || 'mytanita-pdf',
    sourceUserId: row.sourceUserId,
    filename: row.filename,
    heightCm: row.heightCm,
    age: row.age,
    weightKg: row.weightKg,
    bmi: row.bmi,
    bodyFatPercent: row.bodyFatPercent,
    fatMassKg: row.fatMassKg,
    fatFreeMassKg: row.fatFreeMassKg,
    muscleMassKg: row.muscleMassKg,
    boneMassKg: row.boneMassKg,
    proteinKg: row.proteinKg,
    bodyWaterPercent: row.bodyWaterPercent,
    bodyWaterKg: row.bodyWaterKg,
    bmrKcal: row.bmrKcal,
    bmrKj: row.bmrKj,
    metabolicAge: row.metabolicAge,
    visceralFat: row.visceralFat,
  }
}

export function formatScanValue(value?: number | null, suffix = ''): string {
  if (value == null) return '—'
  const shown = Number.isInteger(value) ? String(value) : String(Math.round(value * 100) / 100)
  return `${shown}${suffix}`
}

export function formatScanWhen(iso: string): string {
  const date = new Date(iso)
  if (Number.isNaN(date.getTime())) return iso || '—'
  const day = String(date.getUTCDate()).padStart(2, '0')
  const month = String(date.getUTCMonth() + 1).padStart(2, '0')
  const year = date.getUTCFullYear()
  const hour = String(date.getUTCHours()).padStart(2, '0')
  const minute = String(date.getUTCMinutes()).padStart(2, '0')
  return `${day}/${month}/${year} ${hour}:${minute}`
}

export function scansForTrainee(scans: BodyScan[], traineeId: string): BodyScan[] {
  return scans
    .filter((scan) => scan.traineeId === traineeId)
    .sort((a, b) => (a.measuredAt < b.measuredAt ? 1 : -1))
}

export function previousScan(scans: BodyScan[], currentId: string): BodyScan | undefined {
  const current = scans.find((scan) => scan.id === currentId)
  if (!current) return undefined
  return scansForTrainee(scans, current.traineeId).find(
    (scan) => scan.id !== current.id && scan.measuredAt < current.measuredAt,
  )
}

export function scanDelta(current?: number | null, other?: number | null): number | null {
  if (current == null || other == null) return null
  return Math.round((current - other) * 100) / 100
}

export function formatScanDelta(value: number | null, suffix = ''): string {
  if (value == null) return '—'
  if (value === 0) return `0${suffix}`
  const sign = value > 0 ? '+' : ''
  const shown = Number.isInteger(value) ? String(value) : value.toFixed(2)
  return `${sign}${shown}${suffix}`
}
