export type BodyMeasurementValues = {
  measuredAt: string
  sourceUserId?: string
  heightCm?: number
  age?: number
  weightKg?: number
  bmi?: number
  bodyFatPercent?: number
  fatMassKg?: number
  fatFreeMassKg?: number
  muscleMassKg?: number
  boneMassKg?: number
  proteinKg?: number
  bodyWaterPercent?: number
  bodyWaterKg?: number
  bmrKcal?: number
  bmrKj?: number
  metabolicAge?: number
  visceralFat?: number
}

export type ParsedTanitaPdf = BodyMeasurementValues & {
  source: 'mytanita-pdf'
  strings: string[]
}

const historyDate = /^\d{1,2}\.\d{1,2}\.\d{4}$/
const headerDate = /^(\d{1,2})\/(\d{1,2})\/(\d{4})(?:\s+(\d{1,2}):(\d{2}))?$/
const heightRe = /^(\d+(?:\.\d+)?)\s*cm$/i
const kgRe = /^(-?\d+(?:\.\d+)?)\s*kg$/i
const pctRe = /^(-?\d+(?:\.\d+)?)\s*%$/
const kjRe = /^(\d+(?:\.\d+)?)\s*kJ$/i
const kcalRe = /^(\d+(?:\.\d+)?)\s*kcal$/i
const rangeRe = /^\d+(?:\.\d+)?\s*-\s*\d+(?:\.\d+)?/
const bareRe = /^\d+(?:\.\d+)?$/

function decodeUtf16Be(bytes: Buffer): string {
  const units: number[] = []
  for (let i = 0; i + 1 < bytes.length; i += 2) {
    units.push((bytes[i] << 8) | bytes[i + 1])
  }
  return String.fromCharCode(...units)
}

function decodePdfLiteral(inner: string): string {
  const bytes: number[] = []
  for (let i = 0; i < inner.length; i++) {
    if (inner[i] === '\\' && i + 1 < inner.length) {
      const next = inner[i + 1]
      if (next === 'n') {
        bytes.push(10)
        i += 1
        continue
      }
      if (next === 'r') {
        bytes.push(13)
        i += 1
        continue
      }
      if (next === 't') {
        bytes.push(9)
        i += 1
        continue
      }
      if (next === '(' || next === ')' || next === '\\') {
        bytes.push(next.charCodeAt(0))
        i += 1
        continue
      }
      if (/[0-7]/.test(next)) {
        let oct = next
        let j = i + 2
        while (j < inner.length && oct.length < 3 && /[0-7]/.test(inner[j])) {
          oct += inner[j]
          j += 1
        }
        bytes.push(parseInt(oct, 8))
        i = j - 1
        continue
      }
      bytes.push(next.charCodeAt(0))
      i += 1
      continue
    }
    bytes.push(inner.charCodeAt(i) & 0xff)
  }
  const buf = Buffer.from(bytes)
  if (buf.length >= 2 && buf[0] === 0xfe && buf[1] === 0xff) {
    return decodeUtf16Be(buf.subarray(2))
  }
  if (buf.length >= 2 && buf[0] === 0) {
    return decodeUtf16Be(buf)
  }
  return buf.toString('utf8')
}

export function extractPdfStrings(buffer: Buffer): string[] {
  const raw = buffer.toString('latin1')
  const out: string[] = []
  const re = /\((?:\\[\\()]|[^()])*\)\s*Tj/g
  let match: RegExpExecArray | null
  while ((match = re.exec(raw))) {
    const token = match[0]
    const inner = token.slice(1, token.lastIndexOf(')'))
    const text = decodePdfLiteral(inner).replace(/\s+/g, ' ').trim()
    if (text) out.push(text)
  }
  return out
}

function num(value: string): number | null {
  const match = value.replace(',', '.').match(/-?\d+(?:\.\d+)?/)
  if (!match) return null
  const n = Number(match[0])
  return Number.isFinite(n) ? n : null
}

function closest(values: number[], target: number, maxDelta: number): number | undefined {
  let best: number | undefined
  let bestDelta = maxDelta
  for (const value of values) {
    const delta = Math.abs(value - target)
    if (delta <= bestDelta) {
      best = value
      bestDelta = delta
    }
  }
  return best
}

function take(values: number[], predicate: (value: number) => boolean): number | undefined {
  const index = values.findIndex(predicate)
  if (index < 0) return undefined
  return values.splice(index, 1)[0]
}

function removeAll(values: number[], match?: number): void {
  if (match == null) return
  for (let i = values.length - 1; i >= 0; i--) {
    if (values[i] === match) values.splice(i, 1)
  }
}

function pad2(value: string): string {
  return value.padStart(2, '0')
}

function toIso(day: string, month: string, year: string, hour = '00', minute = '00'): string {
  return `${year}-${pad2(month)}-${pad2(day)}T${pad2(hour)}:${pad2(minute)}:00.000Z`
}

export function parseTanitaStrings(strings: string[]): BodyMeasurementValues {
  const historyAt = strings.findIndex((item) => historyDate.test(item) || /^initial$/i.test(item))
  const current = historyAt >= 0 ? strings.slice(0, historyAt) : strings

  const values: BodyMeasurementValues = { measuredAt: '' }
  const kgs: number[] = []
  const percents: number[] = []
  const bares: number[] = []

  for (const item of current) {
    const dated = item.match(headerDate)
    if (dated && !values.measuredAt) {
      values.measuredAt = toIso(dated[1], dated[2], dated[3], dated[4] ?? '00', dated[5] ?? '00')
      continue
    }
    if (/^\d{6,12}$/.test(item) && !values.sourceUserId) {
      values.sourceUserId = item
      continue
    }
    const height = item.match(heightRe)
    if (height) {
      values.heightCm = Number(height[1])
      continue
    }
    if (rangeRe.test(item)) continue
    const kg = item.match(kgRe)
    if (kg) {
      kgs.push(Number(kg[1]))
      continue
    }
    const pct = item.match(pctRe)
    if (pct) {
      percents.push(Number(pct[1]))
      continue
    }
    const kj = item.match(kjRe)
    if (kj) {
      values.bmrKj = Number(kj[1])
      continue
    }
    const kcal = item.match(kcalRe)
    if (kcal) {
      values.bmrKcal = Number(kcal[1])
      continue
    }
    if (bareRe.test(item)) {
      const value = Number(item)
      if (!values.age && value >= 10 && value <= 100 && Number.isInteger(value) && kgs.length === 0) {
        values.age = value
        continue
      }
      bares.push(value)
    }
  }

  values.weightKg = take(kgs, (value) => value >= 35 && value <= 250)
  removeAll(kgs, values.weightKg)
  values.bodyFatPercent = take(percents, (value) => value >= 5 && value <= 45)
  values.bodyWaterPercent = take(percents, (value) => value >= 40 && value <= 80)

  if (values.weightKg != null && values.bodyFatPercent != null) {
    const expectedFat = (values.weightKg * values.bodyFatPercent) / 100
    values.fatMassKg = closest(kgs, expectedFat, 1.5) ?? expectedFat
    removeAll(kgs, values.fatMassKg)
    const expectedFfm = values.weightKg - (values.fatMassKg ?? 0)
    values.fatFreeMassKg = closest(kgs, expectedFfm, 1.5) ?? expectedFfm
    removeAll(kgs, values.fatFreeMassKg)
    const muscleCandidates = kgs.filter((value) => value >= 30 && value <= values.weightKg! - 2)
    values.muscleMassKg = muscleCandidates.sort((a, b) => b - a)[0]
    removeAll(kgs, values.muscleMassKg)
    if (values.fatFreeMassKg != null && values.muscleMassKg != null) {
      const expectedBone = values.fatFreeMassKg - values.muscleMassKg
      if (expectedBone >= 1.5 && expectedBone <= 6) {
        values.boneMassKg = closest(kgs, expectedBone, 0.5) ?? expectedBone
        removeAll(kgs, values.boneMassKg)
      }
    }
  }

  if (values.weightKg != null && values.bodyWaterPercent != null) {
    const expectedWater = (values.weightKg * values.bodyWaterPercent) / 100
    values.bodyWaterKg = closest(kgs, expectedWater, 1.5) ?? expectedWater
    if (values.bodyWaterKg != null) {
      const waterIndex = kgs.findIndex((value) => value === values.bodyWaterKg)
      if (waterIndex >= 0) kgs.splice(waterIndex, 1)
    }
  }

  values.proteinKg =
    take(kgs, (value) => {
      if (value < 6 || value > 25) return false
      return !kgs.some((other) => other !== value && Math.abs(other - value) <= 0.35)
    }) ?? take(kgs, (value) => value >= 6 && value <= 25)

  if (values.weightKg != null && values.heightCm != null && values.heightCm > 0) {
    const expectedBmi = values.weightKg / (values.heightCm / 100) ** 2
    values.bmi = closest(bares, expectedBmi, 1.2)
    if (values.bmi != null) {
      const bmiIndex = bares.findIndex((value) => value === values.bmi)
      if (bmiIndex >= 0) bares.splice(bmiIndex, 1)
    } else {
      values.bmi = Math.round(expectedBmi * 100) / 100
    }
  }

  values.metabolicAge = take(bares, (value) => value >= 10 && value <= 90)
  values.visceralFat = take(bares, (value) => Number.isInteger(value) && value >= 1 && value <= 30)

  if (!values.measuredAt) {
    throw new Error('Could not find a measurement date in that PDF.')
  }
  if (values.weightKg == null && values.bodyFatPercent == null) {
    throw new Error('Could not read body composition values from that PDF.')
  }

  return values
}

export function parseTanitaPdf(buffer: Buffer): ParsedTanitaPdf {
  const strings = extractPdfStrings(buffer)
  if (strings.length === 0) {
    throw new Error('That PDF has no readable text. Export it again from MyTanita.')
  }
  return {
    ...parseTanitaStrings(strings),
    source: 'mytanita-pdf',
    strings,
  }
}

export function measurementStamp(iso: string): string {
  return iso.slice(0, 16)
}
