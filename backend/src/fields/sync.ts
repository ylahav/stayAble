import type { Field } from 'payload'

export function newClientId(): string {
  return crypto.randomUUID()
}

export function ensureClientId(value: unknown): string {
  if (typeof value === 'string' && value.trim()) return value.trim()
  return newClientId()
}

export const clientIdField: Field = {
  name: 'clientId',
  type: 'text',
  index: true,
  required: true,
  unique: true,
  defaultValue: () => newClientId(),
  admin: {
    readOnly: true,
    position: 'sidebar',
    description: 'Stable id for the app. Set automatically.',
  },
  hooks: {
    beforeChange: [
      ({ value, operation, originalDoc }) => {
        if (operation === 'update') {
          const existing =
            originalDoc && typeof originalDoc === 'object'
              ? (originalDoc as { clientId?: unknown }).clientId
              : undefined
          if (typeof existing === 'string' && existing.trim()) return existing.trim()
        }
        return ensureClientId(value)
      },
    ],
  },
}

/** Array row id. Not globally unique. Kept once set. */
export const nestedClientIdField: Field = {
  name: 'clientId',
  type: 'text',
  required: true,
  defaultValue: () => newClientId(),
  admin: {
    readOnly: true,
    description: 'Stable id for the app. Set automatically.',
  },
  hooks: {
    beforeChange: [
      ({ value }) => ensureClientId(value),
    ],
  },
}

export const adminTitleField: Field = {
  name: 'adminTitle',
  type: 'text',
  index: true,
  admin: { hidden: true },
}

export const deletedField: Field = {
  name: 'deleted',
  type: 'checkbox',
  defaultValue: false,
  index: true,
}

export const localizedTextFields: Field[] = [
  { name: 'en', type: 'text', required: true },
  { name: 'he', type: 'text' },
]
