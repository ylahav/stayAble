import { convertLexicalToHTML } from '@payloadcms/richtext-lexical/html'

import type { Exercise } from '../payload-types'

export type LexicalState = {
  root: {
    type: 'root'
    children: unknown[]
    direction: 'ltr' | 'rtl' | null
    format: string
    indent: number
    version: number
  }
}

export function isLexicalState(value: unknown): value is LexicalState {
  return Boolean(value && typeof value === 'object' && 'root' in value)
}

function emptyLexical(): LexicalState {
  return {
    root: {
      type: 'root',
      children: [paragraph('')],
      direction: 'ltr',
      format: '',
      indent: 0,
      version: 1,
    },
  }
}

function paragraph(text: string): Record<string, unknown> {
  return {
    type: 'paragraph',
    format: '',
    indent: 0,
    version: 1,
    direction: 'ltr',
    textFormat: 0,
    textStyle: '',
    children: text
      ? [
          {
            type: 'text',
            text,
            mode: 'normal',
            style: '',
            detail: 0,
            format: 0,
            version: 1,
          },
        ]
      : [],
  }
}

export function toLexical(value: unknown): LexicalState {
  if (isLexicalState(value)) return value
  if (typeof value !== 'string') return emptyLexical()
  const trimmed = value.trim()
  if (!trimmed) return emptyLexical()
  const chunks = /<[a-z][\s\S]*>/i.test(trimmed)
    ? [trimmed.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim()].filter(Boolean)
    : trimmed.split(/\n+/).map((line) => line.trim()).filter(Boolean)
  return {
    root: {
      type: 'root',
      children: (chunks.length > 0 ? chunks : [trimmed]).map((line) => paragraph(line)),
      direction: 'ltr',
      format: '',
      indent: 0,
      version: 1,
    },
  }
}

export function richTextToHtml(value: unknown): string {
  if (value == null) return ''
  if (typeof value === 'string') {
    return value
  }
  if (isLexicalState(value)) {
    try {
      return convertLexicalToHTML({
        data: value as Parameters<typeof convertLexicalToHTML>[0]['data'],
        disableContainer: true,
      })
    } catch {
      return ''
    }
  }
  return ''
}

export function localizedToHtml(value: unknown): { en: string; he: string } {
  const group = value && typeof value === 'object' ? (value as { en?: unknown; he?: unknown }) : null
  const en = richTextToHtml(group?.en)
  const he = richTextToHtml(group?.he)
  return { en: en || he, he }
}

export function localizedToLexical(value: unknown): Exercise['instructions'] {
  const group = value && typeof value === 'object' ? (value as { en?: unknown; he?: unknown }) : null
  const next: Exercise['instructions'] = {
    en: toLexical(group?.en ?? group?.he) as Exercise['instructions']['en'],
  }
  if (group?.he != null && group.he !== '') {
    next.he = toLexical(group.he) as NonNullable<Exercise['instructions']['he']>
  }
  return next
}
