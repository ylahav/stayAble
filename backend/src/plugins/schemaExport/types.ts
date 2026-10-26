/**
 * The exported schema: the contract between a Payload site and the Dart
 * side (codegen and the editor app). docs/SCHEMA_SPEC.md is the prose
 * version of this file; change both together and bump SCHEMA_VERSION on
 * any change a reader would have to handle.
 */

export const SCHEMA_VERSION = 1

/** A label as Payload allows it: plain, or per-locale. Functions are dropped. */
export type ExportedLabel = string | Record<string, string>

export type ExportedOption = { label: ExportedLabel; value: string }

export type ExportedFieldAdmin = {
  description?: ExportedLabel
  hidden?: boolean
  readOnly?: boolean
  position?: 'sidebar'
  /** True when the field has an admin `condition` function. The function itself can't cross the wire. */
  conditional?: boolean
  placeholder?: ExportedLabel
}

export type ExportedField = {
  /** Absent for presentational fields (row, collapsible, unnamed tabs). */
  name?: string
  type: string
  label?: ExportedLabel
  required?: boolean
  localized?: boolean
  unique?: boolean
  hasMany?: boolean
  /** Only when the default is a JSON value; function defaults are flagged instead. */
  defaultValue?: unknown
  hasDynamicDefault?: boolean
  admin?: ExportedFieldAdmin

  // select / radio
  options?: ExportedOption[]
  // relationship / upload / join
  relationTo?: string | string[]
  /** join: the field on `relationTo` that points back here. */
  on?: string
  // number
  min?: number
  max?: number
  // text / textarea
  minLength?: number
  maxLength?: number
  // array / blocks / select(hasMany) / relationship(hasMany)
  minRows?: number
  maxRows?: number
  // group / array / row / collapsible
  fields?: ExportedField[]
  // tabs
  tabs?: ExportedTab[]
  // blocks
  blocks?: ExportedBlock[]
  // date
  pickerAppearance?: string
  // code
  language?: string
}

export type ExportedTab = {
  /** A named tab nests its data under this key; an unnamed one is presentational. */
  name?: string
  label?: ExportedLabel
  fields: ExportedField[]
}

export type ExportedBlock = {
  slug: string
  labels?: { singular?: ExportedLabel; plural?: ExportedLabel }
  fields: ExportedField[]
}

export type ExportedCollection = {
  slug: string
  labels?: { singular?: ExportedLabel; plural?: ExportedLabel }
  auth: boolean
  upload: false | { mimeTypes?: string[]; imageSizes?: string[] }
  drafts: boolean
  timestamps: boolean
  admin: {
    useAsTitle?: string
    defaultColumns?: string[]
    group?: ExportedLabel
    hidden?: boolean
    description?: ExportedLabel
  }
  fields: ExportedField[]
}

export type ExportedGlobal = {
  slug: string
  label?: ExportedLabel
  drafts: boolean
  admin: { group?: ExportedLabel; hidden?: boolean; description?: ExportedLabel }
  fields: ExportedField[]
}

export type ExportedLocale = { code: string; label?: ExportedLabel; rtl: boolean }

export type ExportedSchema = {
  schemaVersion: typeof SCHEMA_VERSION
  /** The collection the admin panel signs in against (config.admin.user). */
  adminUserCollection?: string
  /** Default upload/relationship ID type, so clients know whether IDs are strings or numbers. */
  idType: 'text' | 'number'
  localization: false | { defaultLocale: string; locales: ExportedLocale[] }
  collections: ExportedCollection[]
  globals: ExportedGlobal[]
}
