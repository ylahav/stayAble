import type { CollectionConfig } from 'payload'

import { hasRole, isAdmin, type AuthedUser } from '../access/roles'
import { eitherParty } from '../access/where'
import { adminTitleField, clientIdField, deletedField, ensureClientId } from '../fields/sync'
import { joinTitle, labelForUser } from '../lib/adminTitle'

export const TrainerClients: CollectionConfig = {
  slug: 'trainer-clients',
  labels: {
    plural: 'Coaching links',
    singular: 'Coaching link',
  },
  admin: {
    defaultColumns: ['trainer', 'athlete', 'status', 'updatedAt'],
    useAsTitle: 'adminTitle',
  },
  access: {
    create: ({ req: { user } }) => hasRole(user as AuthedUser, 'trainer') || isAdmin(user as AuthedUser),
    delete: ({ req: { user } }) => isAdmin(user as AuthedUser),
    read: ({ req: { user } }) => {
      if (!user) return false
      if (isAdmin(user as AuthedUser)) return true
      return eitherParty(String(user.id))
    },
    update: ({ req: { user } }) => {
      if (!user) return false
      if (isAdmin(user as AuthedUser)) return true
      return eitherParty(String(user.id))
    },
  },
  fields: [
    clientIdField,
    adminTitleField,
    deletedField,
    { name: 'trainer', type: 'relationship', relationTo: 'users', required: true },
    { name: 'athlete', type: 'relationship', relationTo: 'users', required: true },
    {
      name: 'status',
      type: 'select',
      defaultValue: 'invited',
      options: [
        { label: 'Invited', value: 'invited' },
        { label: 'Active', value: 'active' },
        { label: 'Declined', value: 'declined' },
        { label: 'Ended', value: 'ended' },
      ],
      required: true,
    },
    { name: 'invitedAt', type: 'date' },
    { name: 'acceptedAt', type: 'date' },
    { name: 'endedAt', type: 'date' },
  ],
  hooks: {
    beforeChange: [
      async ({ data, operation, originalDoc, req }) => {
        const user = req.user as AuthedUser | null

        if (operation === 'create') {
          data.clientId = ensureClientId(data.clientId)
          if (user && !isAdmin(user) && !data.trainer) {
            data.trainer = user.id
          }
          if (user && !isAdmin(user) && !data.status) {
            data.status = 'invited'
          }
          data.invitedAt = data.invitedAt ?? new Date().toISOString()
        }

        if (operation === 'update' && originalDoc && typeof originalDoc.clientId === 'string') {
          data.clientId = originalDoc.clientId
        }

        if (operation === 'update' && user && !isAdmin(user) && originalDoc) {
          const athleteId =
            typeof originalDoc.athlete === 'string' ? originalDoc.athlete : originalDoc.athlete?.id
          const trainerId =
            typeof originalDoc.trainer === 'string' ? originalDoc.trainer : originalDoc.trainer?.id

          if (athleteId === user.id && data.status === 'active') {
            data.acceptedAt = data.acceptedAt ?? new Date().toISOString()
          }
          if (
            (athleteId === user.id || trainerId === user.id) &&
            (data.status === 'ended' || data.status === 'declined')
          ) {
            data.endedAt = data.endedAt ?? new Date().toISOString()
          }
          if (athleteId === user.id && !hasRole(user, 'trainer')) {
            data.trainer = trainerId
            data.athlete = athleteId
          }
        }

        const source = { ...originalDoc, ...data }
        data.adminTitle = joinTitle(
          await labelForUser(req.payload, source.athlete),
          await labelForUser(req.payload, source.trainer),
        )
        return data
      },
    ],
    afterRead: [
      async ({ doc, req }) => {
        doc.adminTitle = joinTitle(
          await labelForUser(req.payload, doc.athlete),
          await labelForUser(req.payload, doc.trainer),
        )
        return doc
      },
    ],
  },
  timestamps: true,
}
