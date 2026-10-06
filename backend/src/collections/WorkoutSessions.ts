import type { CollectionConfig } from 'payload'

import { athleteIdsForTrainer } from '../access/linkedAthletes'
import { hasRole, isAdmin, isStaff, type AuthedUser } from '../access/roles'
import { selfOrIn } from '../access/where'
import { adminTitleField, clientIdField, deletedField, ensureClientId, nestedClientIdField } from '../fields/sync'
import { formatAdminDate, joinTitle, labelForProgram, labelForUser } from '../lib/adminTitle'

export const WorkoutSessions: CollectionConfig = {
  slug: 'workout-sessions',
  admin: {
    defaultColumns: ['adminTitle', 'athlete', 'status', 'startedAt', 'totalVolumeKg', 'updatedAt'],
    useAsTitle: 'adminTitle',
  },
  access: {
    create: ({ req: { user } }) => Boolean(user),
    delete: ({ req: { user } }) => {
      if (!user) return false
      if (isAdmin(user as AuthedUser)) return true
      return { athlete: { equals: user.id } }
    },
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
    update: ({ req: { user } }) => {
      if (!user) return false
      if (isAdmin(user as AuthedUser)) return true
      return { athlete: { equals: user.id } }
    },
  },
  fields: [
    clientIdField,
    adminTitleField,
    deletedField,
    { name: 'athlete', type: 'relationship', relationTo: 'users', required: true, label: 'Trainee' },
    { name: 'program', type: 'relationship', relationTo: 'programs' },
    { name: 'programDayClientId', type: 'text' },
    { name: 'startedAt', type: 'date', required: true },
    { name: 'completedAt', type: 'date' },
    { name: 'duration', type: 'number' },
    {
      name: 'status',
      type: 'select',
      defaultValue: 'started',
      options: [
        { label: 'Planned', value: 'planned' },
        { label: 'Started', value: 'started' },
        { label: 'Completed', value: 'completed' },
        { label: 'Partially completed', value: 'partiallyCompleted' },
        { label: 'Skipped', value: 'skipped' },
        { label: 'Cancelled', value: 'cancelled' },
      ],
      required: true,
    },
    { name: 'notes', type: 'textarea' },
    {
      name: 'totalVolumeKg',
      type: 'number',
      admin: { description: 'Sets × reps × kilograms' },
    },
    { name: 'activeDeviceId', type: 'text' },
    {
      name: 'exercises',
      type: 'array',
      fields: [
        nestedClientIdField,
        { name: 'exercise', type: 'relationship', relationTo: 'exercises', required: true },
        { name: 'programExerciseClientId', type: 'text' },
        { name: 'sortOrder', type: 'number', required: true },
        { name: 'plannedSets', type: 'number', required: true },
        { name: 'actualSets', type: 'number', defaultValue: 0 },
        { name: 'plannedRepetitions', type: 'number' },
        { name: 'actualRepetitions', type: 'number' },
        { name: 'plannedDuration', type: 'number' },
        { name: 'actualDuration', type: 'number' },
        { name: 'completed', type: 'checkbox', defaultValue: false },
        {
          name: 'effort',
          type: 'select',
          options: [
            { label: 'Easy', value: 'easy' },
            { label: 'Good', value: 'good' },
            { label: 'Difficult', value: 'difficult' },
          ],
        },
        { name: 'notes', type: 'text' },
        {
          name: 'personalRecord',
          type: 'checkbox',
          defaultValue: false,
          admin: { description: 'Personal record on this exercise' },
        },
        {
          name: 'sets',
          type: 'array',
          fields: [
            nestedClientIdField,
            { name: 'setNumber', type: 'number', required: true },
            { name: 'plannedReps', type: 'number' },
            { name: 'actualReps', type: 'number' },
            { name: 'plannedDuration', type: 'number' },
            { name: 'actualDuration', type: 'number' },
            { name: 'plannedLoadKg', type: 'number' },
            { name: 'actualLoadKg', type: 'number' },
            { name: 'completed', type: 'checkbox', defaultValue: false },
          ],
        },
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
        if (Array.isArray(data.exercises)) {
          data.exercises = data.exercises.map((row: Record<string, unknown>) => {
            const sets = Array.isArray(row.sets)
              ? row.sets.map((set: Record<string, unknown>) => ({
                  ...set,
                  clientId: ensureClientId(set.clientId),
                }))
              : row.sets
            return {
              ...row,
              clientId: ensureClientId(row.clientId),
              sets,
            }
          })
        }
        if (req.user && !isStaff(req.user as AuthedUser)) {
          data.athlete = req.user.id
        } else if (operation === 'create' && req.user && !data.athlete) {
          data.athlete = req.user.id
        }
        const source = { ...originalDoc, ...data }
        data.adminTitle = joinTitle(
          await labelForUser(req.payload, source.athlete),
          await labelForProgram(req.payload, source.program),
          formatAdminDate(source.startedAt),
        )
        return data
      },
    ],
    afterRead: [
      async ({ doc, req }) => {
        doc.adminTitle = joinTitle(
          await labelForUser(req.payload, doc.athlete),
          await labelForProgram(req.payload, doc.program),
          formatAdminDate(doc.startedAt),
        )
        return doc
      },
    ],
  },
  timestamps: true,
}
