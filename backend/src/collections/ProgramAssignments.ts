import type { CollectionConfig } from 'payload'

import { athleteIdsForTrainer } from '../access/linkedAthletes'
import { hasRole, isAdmin, isStaff, type AuthedUser } from '../access/roles'
import { athleteIn, selfAssigned, selfOrIn } from '../access/where'
import { adminTitleField, clientIdField, deletedField, ensureClientId, nestedClientIdField } from '../fields/sync'
import { joinTitle, labelForProgram, labelForUser } from '../lib/adminTitle'

export const ProgramAssignments: CollectionConfig = {
  slug: 'program-assignments',
  admin: {
    defaultColumns: ['athlete', 'program', 'scheduleType', 'active', 'startDate', 'updatedAt'],
    description:
      'Gives a trainee a program. Set when they train here (weekly, daily, or custom). Leave refinements empty to use the program defaults, or override sets, reps, duration, and load for this person only.',
    useAsTitle: 'adminTitle',
  },
  access: {
    create: ({ req: { user } }) => Boolean(user),
    delete: ({ req: { user } }) => isAdmin(user as AuthedUser),
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
    update: async ({ req }) => {
      const user = req.user as AuthedUser | null
      if (!user) return false
      if (isAdmin(user)) return true
      if (hasRole(user, 'instructor')) {
        const ids = await athleteIdsForTrainer(req.payload, user.id)
        return athleteIn(ids)
      }
      return selfAssigned(user.id)
    },
  },
  fields: [
    clientIdField,
    adminTitleField,
    deletedField,
    {
      name: 'program',
      type: 'relationship',
      relationTo: 'programs',
      required: true,
      admin: { description: 'The exercise collection this trainee will follow.' },
    },
    { name: 'athlete', type: 'relationship', relationTo: 'users', required: true, label: 'Trainee' },
    { name: 'assignedBy', type: 'relationship', relationTo: 'users', required: true },
    {
      name: 'scheduleType',
      type: 'select',
      defaultValue: 'weekly',
      options: [
        { label: 'Daily', value: 'daily' },
        { label: 'Weekly', value: 'weekly' },
        { label: 'Custom', value: 'custom' },
      ],
      required: true,
      admin: { description: 'When this trainee trains. Specific to this person, not the program.' },
    },
    { name: 'startDate', type: 'date' },
    { name: 'endDate', type: 'date' },
    { name: 'active', type: 'checkbox', defaultValue: true },
    {
      name: 'scheduleDays',
      type: 'array',
      admin: {
        description:
          'Which days this trainee trains. Weekly uses weekday (1 = Monday). Custom uses a date. Daily can list every weekday or be left empty.',
      },
      fields: [
        nestedClientIdField,
        { name: 'weekday', type: 'number', max: 7, min: 1, admin: { description: '1 = Monday … 7 = Sunday' } },
        { name: 'date', type: 'date' },
      ],
    },
    {
      name: 'refinements',
      type: 'array',
      admin: {
        description:
          'Optional per-exercise overrides for this trainee. Match programExerciseClientId to the slug of a slot on the program. Leave a field empty to keep the program default.',
      },
      fields: [
        {
          name: 'programExerciseClientId',
          type: 'text',
          required: true,
          admin: { description: 'Slug of the exercise slot on the program' },
        },
        { name: 'sets', type: 'number' },
        { name: 'repetitions', type: 'number' },
        { name: 'duration', type: 'number', admin: { description: 'Seconds' } },
        { name: 'loadKg', type: 'number', admin: { description: 'Kilograms' } },
        { name: 'rest', type: 'number', admin: { description: 'Seconds' } },
        { name: 'notes', type: 'text' },
      ],
    },
  ],
  hooks: {
    beforeChange: [
      async ({ data, operation, originalDoc, req }) => {
        if (operation === 'update' && originalDoc && typeof originalDoc.clientId === 'string') {
          data.clientId = originalDoc.clientId
        } else {
          data.clientId = ensureClientId(data.clientId)
        }
        if (Array.isArray(data.scheduleDays)) {
          data.scheduleDays = data.scheduleDays.map((row: Record<string, unknown>) => ({
            ...row,
            clientId: ensureClientId(row.clientId),
          }))
        }
        if (operation === 'create' && req.user) {
          data.assignedBy = data.assignedBy ?? req.user.id
          if (!isStaff(req.user as AuthedUser)) {
            data.athlete = req.user.id
            data.assignedBy = req.user.id
          }
        }
        const source = { ...originalDoc, ...data }
        data.adminTitle = joinTitle(
          await labelForProgram(req.payload, source.program),
          await labelForUser(req.payload, source.athlete),
        )
        return data
      },
    ],
    afterRead: [
      async ({ doc, req }) => {
        doc.adminTitle = joinTitle(
          await labelForProgram(req.payload, doc.program),
          await labelForUser(req.payload, doc.athlete),
        )
        return doc
      },
    ],
  },
  timestamps: true,
}
