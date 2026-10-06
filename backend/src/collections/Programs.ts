import type { CollectionConfig } from 'payload'

import { athleteIdsForTrainer } from '../access/linkedAthletes'
import { hasRole, isAdmin, isStaff, type AuthedUser } from '../access/roles'
import { ownerOrIds } from '../access/where'
import { detachProgramUsage } from '../lib/programCleanup'
import { withCatalogTransfer } from '../lib/catalogEndpoints'
import { clientIdField, deletedField, ensureClientId, nestedClientIdField } from '../fields/sync'

export const Programs: CollectionConfig = withCatalogTransfer({
  slug: 'programs',
  admin: {
    defaultColumns: ['clientId', 'name', 'owner', 'venue', 'active', 'updatedAt'],
    description:
      'Reusable collection of exercises. You can edit or delete a program after trainees have trained it. Past sessions keep what they logged. Delete removes assignments; session history stays.',
    useAsTitle: 'name',
    components: {
      beforeListTable: ['/components/admin/CatalogTransfer'],
    },
  },
  access: {
    create: ({ req: { user } }) => Boolean(user),
    delete: ({ req: { user } }) => {
      if (!user) return false
      if (isAdmin(user as AuthedUser)) return true
      return { owner: { equals: user.id } }
    },
    read: async ({ req }) => {
      const user = req.user as AuthedUser | null
      if (!user) return false
      if (isAdmin(user)) return true

      const assigned = await req.payload.find({
        collection: 'program-assignments',
        depth: 0,
        limit: 200,
        overrideAccess: true,
        pagination: false,
        where: {
          and: [{ athlete: { equals: user.id } }, { active: { equals: true } }],
        },
      })
      const assignedProgramIds = assigned.docs.map((doc) => {
        const program = doc.program
        return typeof program === 'string' ? program : program.id
      })

      if (hasRole(user, 'instructor')) {
        const athleteIds = await athleteIdsForTrainer(req.payload, user.id)
        const clientAssigned = await req.payload.find({
          collection: 'program-assignments',
          depth: 0,
          limit: 500,
          overrideAccess: true,
          pagination: false,
          where: {
            and: [{ athlete: { in: athleteIds } }, { active: { equals: true } }],
          },
        })
        const clientProgramIds = clientAssigned.docs.map((doc) => {
          const program = doc.program
          return typeof program === 'string' ? program : program.id
        })
        return ownerOrIds(user.id, [...assignedProgramIds, ...clientProgramIds])
      }

      return ownerOrIds(user.id, assignedProgramIds)
    },
    update: ({ req: { user } }) => {
      if (!user) return false
      if (isAdmin(user as AuthedUser)) return true
      return { owner: { equals: user.id } }
    },
  },
  fields: [
    clientIdField,
    deletedField,
    {
      name: 'owner',
      type: 'relationship',
      relationTo: 'users',
      required: true,
      admin: { description: 'Who created this template, usually an instructor. Not the trainee who follows it.' },
    },
    { name: 'name', type: 'text', required: true },
    { name: 'description', type: 'textarea' },
    { name: 'active', type: 'checkbox', defaultValue: true },
    {
      name: 'venue',
      type: 'select',
      defaultValue: 'home',
      options: [
        { label: 'Home', value: 'home' },
        { label: 'Gym', value: 'gym' },
        { label: 'Mixed', value: 'mixed' },
      ],
      required: true,
      admin: { description: 'Home, gymnastics room, or both in one program' },
    },
    {
      name: 'exercises',
      type: 'array',
      labels: { singular: 'Exercise', plural: 'Exercises' },
      admin: {
        description: 'The workout as a single list. When a trainee trains is set on the assignment.',
      },
      fields: [
        nestedClientIdField,
        {
          name: 'exercise',
          type: 'relationship',
          relationTo: 'exercises',
          required: true,
        },
        { name: 'sortOrder', type: 'number', required: true },
        { name: 'sets', type: 'number', required: true },
        { name: 'repetitions', type: 'number' },
        { name: 'duration', type: 'number', admin: { description: 'Seconds' } },
        { name: 'loadKg', type: 'number', admin: { description: 'Planned load in kilograms' } },
        { name: 'rest', type: 'number', defaultValue: 0, admin: { description: 'Seconds' } },
        { name: 'notes', type: 'text' },
      ],
    },
  ],
  hooks: {
    beforeDelete: [
      async ({ id, req }) => {
        await detachProgramUsage(req.payload, String(id))
      },
    ],
    beforeChange: [
      ({ data, operation, originalDoc, req }) => {
        if (operation === 'update' && originalDoc && typeof originalDoc.clientId === 'string') {
          data.clientId = originalDoc.clientId
        } else {
          data.clientId = ensureClientId(data.clientId)
        }
        if (Array.isArray(data.exercises)) {
          data.exercises = data.exercises.map((row: Record<string, unknown>, index: number) => ({
            ...row,
            clientId: ensureClientId(row.clientId),
            sortOrder: typeof row.sortOrder === 'number' ? row.sortOrder : index + 1,
          }))
        }
        if (operation === 'create' && req.user && !data.owner) {
          data.owner = req.user.id
        }
        if (operation === 'create' && !isStaff(req.user as AuthedUser) && req.user) {
          data.owner = req.user.id
        }
        return data
      },
    ],
  },
  timestamps: true,
}, 'programs')
