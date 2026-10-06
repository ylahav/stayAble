import type { CollectionConfig } from 'payload'

import { athleteIdsForTrainer } from '../access/linkedAthletes'
import { hasRole, isAdmin, staffOnly, type AuthedUser } from '../access/roles'
import { selfOrIn } from '../access/where'
import { adminTitleField, deletedField } from '../fields/sync'
import { formatAdminDate, joinTitle, labelForUser } from '../lib/adminTitle'

export const BodyMeasurements: CollectionConfig = {
  slug: 'body-measurements',
  admin: {
    defaultColumns: ['adminTitle', 'athlete', 'measuredAt', 'weightKg', 'bodyFatPercent'],
    useAsTitle: 'adminTitle',
    description: 'Dated body composition snapshots (MyTanita PDF import). Not workout history.',
  },
  access: {
    create: staffOnly,
    delete: staffOnly,
    read: async ({ req }) => {
      const user = req.user as AuthedUser | null
      if (!user) return false
      if (isAdmin(user)) return true
      if (hasRole(user, 'instructor')) {
        const ids = await athleteIdsForTrainer(req.payload, user.id)
        return selfOrIn('athlete', user.id, ids)
      }
      return { athlete: { equals: user.id } }
    },
    update: staffOnly,
  },
  fields: [
    adminTitleField,
    deletedField,
    { name: 'athlete', type: 'relationship', relationTo: 'users', required: true, label: 'Trainee' },
    {
      name: 'measuredAt',
      type: 'date',
      required: true,
      admin: {
        date: { pickerAppearance: 'dayAndTime' },
        description: 'Date and time printed on the scan, not the import time.',
      },
    },
    {
      name: 'source',
      type: 'select',
      defaultValue: 'mytanita-pdf',
      options: [
        { label: 'MyTanita PDF', value: 'mytanita-pdf' },
        { label: 'Manual', value: 'manual' },
      ],
      required: true,
    },
    { name: 'sourceUserId', type: 'text', admin: { description: 'ID printed on the Tanita report' } },
    { name: 'filename', type: 'text' },
    { name: 'heightCm', type: 'number' },
    { name: 'age', type: 'number', min: 10, max: 120 },
    { name: 'weightKg', type: 'number' },
    { name: 'bmi', type: 'number' },
    { name: 'bodyFatPercent', type: 'number' },
    { name: 'fatMassKg', type: 'number' },
    { name: 'fatFreeMassKg', type: 'number' },
    { name: 'muscleMassKg', type: 'number' },
    { name: 'boneMassKg', type: 'number' },
    { name: 'proteinKg', type: 'number' },
    { name: 'bodyWaterPercent', type: 'number' },
    { name: 'bodyWaterKg', type: 'number' },
    { name: 'bmrKcal', type: 'number' },
    { name: 'bmrKj', type: 'number' },
    { name: 'metabolicAge', type: 'number' },
    { name: 'visceralFat', type: 'number' },
    { name: 'raw', type: 'json', admin: { description: 'Parsed snapshot as imported' } },
  ],
  hooks: {
    beforeChange: [
      async ({ data, originalDoc, req }) => {
        const source = { ...originalDoc, ...data }
        data.adminTitle = joinTitle(
          await labelForUser(req.payload, source.athlete),
          formatAdminDate(source.measuredAt),
          source.weightKg != null ? `${source.weightKg} kg` : '',
        )
        return data
      },
    ],
    afterRead: [
      async ({ doc, req }) => {
        doc.adminTitle = joinTitle(
          await labelForUser(req.payload, doc.athlete),
          formatAdminDate(doc.measuredAt),
          doc.weightKg != null ? `${doc.weightKg} kg` : '',
        )
        return doc
      },
    ],
  },
  timestamps: true,
}
