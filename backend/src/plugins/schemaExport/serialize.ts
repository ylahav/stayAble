import type { Block, Field, SanitizedConfig } from 'payload'

import {
  SCHEMA_VERSION,
  type ExportedBlock,
  type ExportedField,
  type ExportedLabel,
  type ExportedOption,
  type ExportedSchema,
  type ExportedTab,
} from './types'

// Payload's field union is wide and most properties exist on only some
// members. Reading them through this loose view keeps the walker short;
// the output type is what's checked.
type AnyField = Record<string, any>

/** Plain or per-locale labels survive; functions and `false` don't. */
export function label(value: unknown): ExportedLabel | undefined {
  if (typeof value === 'string') return value
  if (value && typeof value === 'object' && !Array.isArray(value)) {
    const entries = Object.entries(value).filter(([, v]) => typeof v === 'string')
    if (entries.length > 0) return Object.fromEntries(entries) as Record<string, string>
  }
  return undefined
}

function isJsonValue(value: unknown): boolean {
  if (value === null) return true
  switch (typeof value) {
    case 'string':
    case 'number':
    case 'boolean':
      return true
    case 'object':
      return Array.isArray(value)
        ? value.every(isJsonValue)
        : Object.values(value as object).every(isJsonValue)
    default:
      return false
  }
}

function options(raw: unknown): ExportedOption[] | undefined {
  if (!Array.isArray(raw)) return undefined
  return raw.map((option) =>
    typeof option === 'string'
      ? { label: option, value: option }
      : { label: label(option.label) ?? String(option.value), value: String(option.value) },
  )
}

/** Drops undefined keys so the JSON stays readable and diffs stay small. */
function compact<T extends object>(value: T): T {
  return Object.fromEntries(Object.entries(value).filter(([, v]) => v !== undefined)) as T
}

type Context = { blocksBySlug: Map<string, Block> }

export function fields(raw: readonly Field[], ctx: Context): ExportedField[] {
  const out: ExportedField[] = []
  for (const field of raw as readonly AnyField[]) {
    const exported = fieldToSchema(field, ctx)
    if (exported) out.push(exported)
  }
  return out
}

function fieldToSchema(field: AnyField, ctx: Context): ExportedField | undefined {
  // `ui` fields are custom admin components with no data. `hidden: true`
  // (not admin.hidden) means the API never returns the field at all:
  // auth hashes, salts and the like.
  if (field.type === 'ui' || field.hidden === true) return undefined

  const admin = field.admin ?? {}
  const exportedAdmin = compact({
    description: label(admin.description),
    hidden: admin.hidden === true ? true : undefined,
    readOnly: admin.readOnly === true ? true : undefined,
    position: admin.position === 'sidebar' ? ('sidebar' as const) : undefined,
    conditional: typeof admin.condition === 'function' ? true : undefined,
    placeholder: label(admin.placeholder),
  })

  const hasDefault = 'defaultValue' in field && field.defaultValue !== undefined
  const dynamicDefault = hasDefault && typeof field.defaultValue === 'function'

  const base: ExportedField = compact({
    name: typeof field.name === 'string' ? field.name : undefined,
    type: field.type,
    label: label(field.label),
    required: field.required === true ? true : undefined,
    localized: field.localized === true ? true : undefined,
    unique: field.unique === true ? true : undefined,
    hasMany: field.hasMany === true ? true : undefined,
    defaultValue:
      hasDefault && !dynamicDefault && isJsonValue(field.defaultValue)
        ? field.defaultValue
        : undefined,
    hasDynamicDefault: dynamicDefault ? true : undefined,
    admin: Object.keys(exportedAdmin).length > 0 ? exportedAdmin : undefined,
  })

  switch (field.type) {
    case 'select':
    case 'radio':
      return compact({ ...base, options: options(field.options) })

    case 'relationship':
    case 'upload':
      return compact({
        ...base,
        relationTo: field.relationTo,
        minRows: field.minRows,
        maxRows: field.maxRows,
      })

    case 'join':
      return compact({ ...base, relationTo: field.collection, on: field.on })

    case 'number':
      return compact({
        ...base,
        min: field.min,
        max: field.max,
        minRows: field.minRows,
        maxRows: field.maxRows,
      })

    case 'text':
    case 'textarea':
      return compact({ ...base, minLength: field.minLength, maxLength: field.maxLength })

    case 'date':
      return compact({ ...base, pickerAppearance: admin.date?.pickerAppearance })

    case 'code':
      return compact({ ...base, language: admin.language })

    case 'group':
    case 'row':
    case 'collapsible':
      return { ...base, fields: fields(field.fields ?? [], ctx) }

    case 'array':
      return compact({
        ...base,
        minRows: field.minRows,
        maxRows: field.maxRows,
        fields: fields(field.fields ?? [], ctx),
      })

    case 'tabs':
      return {
        ...base,
        tabs: (field.tabs ?? []).map(
          (tab: AnyField): ExportedTab =>
            compact({
              name: typeof tab.name === 'string' ? tab.name : undefined,
              label: label(tab.label) ?? (typeof tab.name === 'string' ? tab.name : undefined),
              fields: fields(tab.fields ?? [], ctx),
            }),
        ),
      }

    case 'blocks': {
      // Payload 3 lets blocks be declared once in config.blocks and
      // referenced by slug; `blockReferences` wins over `blocks` when set.
      const refs: (Block | string)[] = field.blockReferences ?? field.blocks ?? []
      const blocks: ExportedBlock[] = []
      for (const ref of refs) {
        const block = typeof ref === 'string' ? ctx.blocksBySlug.get(ref) : ref
        if (!block) continue
        blocks.push(
          compact({
            slug: block.slug,
            labels: block.labels
              ? compact({
                  singular: label(block.labels.singular),
                  plural: label(block.labels.plural),
                })
              : undefined,
            fields: fields(block.fields ?? [], ctx),
          }),
        )
      }
      return compact({ ...base, minRows: field.minRows, maxRows: field.maxRows, blocks })
    }

    default:
      // text-like (email, checkbox, json, point, richText) and anything a
      // future Payload adds: the type name alone lets the client decide.
      return base
  }
}

function locales(config: SanitizedConfig): ExportedSchema['localization'] {
  const localization = config.localization
  if (!localization) return false
  return {
    defaultLocale: localization.defaultLocale,
    locales: (localization.locales as unknown[]).map((locale) =>
      typeof locale === 'string'
        ? { code: locale, rtl: false }
        : compact({
            code: (locale as AnyField).code as string,
            label: label((locale as AnyField).label),
            rtl: (locale as AnyField).rtl === true,
          }),
    ),
  }
}

/** Turns a sanitized Payload config into the exported schema. Pure; safe to call per request. */
export function buildSchema(config: SanitizedConfig): ExportedSchema {
  const ctx: Context = {
    blocksBySlug: new Map((config.blocks ?? []).map((block) => [block.slug, block])),
  }

  return {
    schemaVersion: SCHEMA_VERSION,
    adminUserCollection: config.admin?.user,
    idType: (config.db as AnyField | undefined)?.defaultIDType === 'number' ? 'number' : 'text',
    localization: locales(config),
    collections: config.collections
      // Payload's own internal collections (preferences, migrations,
      // locked documents, jobs) are implementation details.
      .filter((collection) => !collection.slug.startsWith('payload-'))
      .map((collection) => {
        const c = collection as AnyField
        const upload = c.upload
        return {
          slug: c.slug,
          labels: c.labels
            ? compact({ singular: label(c.labels.singular), plural: label(c.labels.plural) })
            : undefined,
          auth: Boolean(c.auth),
          upload: upload
            ? compact({
                mimeTypes: Array.isArray(upload.mimeTypes) ? upload.mimeTypes : undefined,
                imageSizes: Array.isArray(upload.imageSizes)
                  ? upload.imageSizes.map((size: AnyField) => size.name as string)
                  : undefined,
              })
            : false,
          drafts: Boolean(c.versions?.drafts),
          timestamps: c.timestamps !== false,
          admin: compact({
            useAsTitle: c.admin?.useAsTitle,
            defaultColumns: c.admin?.defaultColumns,
            group: label(c.admin?.group),
            hidden: c.admin?.hidden === true ? true : undefined,
            description: label(c.admin?.description),
          }),
          fields: fields(c.fields, ctx),
        }
      }),
    globals: config.globals.map((global) => {
      const g = global as AnyField
      return {
        slug: g.slug,
        label: label(g.label),
        drafts: Boolean(g.versions?.drafts),
        admin: compact({
          group: label(g.admin?.group),
          hidden: g.admin?.hidden === true ? true : undefined,
          description: label(g.admin?.description),
        }),
        fields: fields(g.fields, ctx),
      }
    }),
  }
}
