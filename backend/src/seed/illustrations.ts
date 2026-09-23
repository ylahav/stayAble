import { access, mkdir } from 'fs/promises'
import path from 'path'
import { fileURLToPath } from 'url'

import sharp from 'sharp'

import type { SeedExercise } from './exercises'

const dirname = path.dirname(fileURLToPath(import.meta.url))

const categoryFill: Record<SeedExercise['category'], string> = {
  warmUp: '#D9C9A8',
  mobility: '#B7C4B8',
  strength: '#7FAF96',
  cardio: '#8FA898',
  stretching: '#C5C1B5',
  coolDown: '#9AA39C',
}

function exerciseDirCandidates(): string[] {
  return [
    path.resolve(process.cwd(), '../assets/exercises'),
    path.resolve(process.cwd(), 'assets/exercises'),
    path.resolve(dirname, '../../../assets/exercises'),
  ]
}

export function exercisePngPath(clientId: string): string {
  return path.join(exerciseDirCandidates()[0], `${clientId}.png`)
}

export async function ensureExercisePng(exercise: SeedExercise): Promise<string> {
  for (const dir of exerciseDirCandidates()) {
    const dest = path.join(dir, `${exercise.clientId}.png`)
    try {
      await access(dest)
      return dest
    } catch {
      // try the next known catalog folder
    }
  }

  const dest = exercisePngPath(exercise.clientId)
  await mkdir(path.dirname(dest), { recursive: true })
  const svg = illustrationSvg(exercise)
  await sharp(Buffer.from(svg)).png().toFile(dest)
  return dest
}

function illustrationSvg(exercise: SeedExercise): string {
  const fill = categoryFill[exercise.category]
  const label = escapeXml(exercise.name.en)
  return `<?xml version="1.0" encoding="UTF-8"?>
<svg width="960" height="640" viewBox="0 0 960 640" xmlns="http://www.w3.org/2000/svg">
  <rect width="960" height="640" fill="#EEF0EC"/>
  <rect x="48" y="48" width="864" height="544" rx="28" fill="${fill}"/>
  <circle cx="360" cy="250" r="72" fill="none" stroke="#222824" stroke-width="16" stroke-linecap="round"/>
  <line x1="360" y1="322" x2="360" y2="500" stroke="#222824" stroke-width="16" stroke-linecap="round"/>
  <line x1="360" y1="370" x2="250" y2="460" stroke="#222824" stroke-width="16" stroke-linecap="round"/>
  <line x1="360" y1="370" x2="470" y2="460" stroke="#222824" stroke-width="16" stroke-linecap="round"/>
  <circle cx="700" cy="200" r="46" fill="#0E6B4F" fill-opacity="0.35"/>
  <text x="700" y="520" text-anchor="middle" font-family="Arial, sans-serif" font-size="28" font-weight="700" fill="#222824">${label}</text>
</svg>`
}

function escapeXml(value: string): string {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
}
