import type { CollectionConfig } from 'payload'

import { adminField, adminOnly, hasRole, isAdmin, type AuthedUser } from '../access/roles'
import { athleteIdsForTrainer } from '../access/linkedAthletes'
import { selfOrIn } from '../access/where'

export const Users: CollectionConfig = {
  slug: 'users',
  admin: {
    defaultColumns: ['name', 'email', 'roles', 'trainingVenue', 'updatedAt'],
    useAsTitle: 'name',
  },
  auth: {
    cookies: {
      sameSite: 'Lax',
      secure: (process.env.PAYLOAD_PUBLIC_URL || process.env.NEXT_PUBLIC_SERVER_URL || '').startsWith(
        'https://',
      ),
    },
  },
  access: {
    admin: ({ req: { user } }) => isAdmin(user as AuthedUser),
    create: adminOnly,
    delete: ({ req: { user } }) => isAdmin(user as AuthedUser),
    read: async ({ req }) => {
      const user = req.user as AuthedUser | null
      if (!user) return false
      if (isAdmin(user)) return true
      if (hasRole(user, 'trainer')) {
        const ids = await athleteIdsForTrainer(req.payload, user.id)
        return selfOrIn('id', user.id, ids)
      }
      return { id: { equals: user.id } }
    },
    update: ({ req: { user } }) => {
      if (!user) return false
      if (isAdmin(user as AuthedUser)) return true
      return { id: { equals: user.id } }
    },
  },
  fields: [
    { name: 'name', type: 'text', required: true },
    {
      name: 'roles',
      type: 'select',
      access: {
        create: adminField,
        update: adminField,
      },
      defaultValue: ['athlete'],
      hasMany: true,
      options: [
        { label: 'Athlete', value: 'athlete' },
        { label: 'Trainer', value: 'trainer' },
        { label: 'Admin', value: 'admin' },
      ],
      required: true,
    },
    {
      name: 'photo',
      type: 'text',
      admin: { description: 'URL or local asset path' },
    },
    { name: 'birthDate', type: 'date' },
    {
      name: 'age',
      type: 'number',
      min: 10,
      max: 120,
      admin: { description: 'Years' },
    },
    {
      name: 'weightKg',
      type: 'number',
      min: 20,
      max: 400,
      admin: { description: 'Body weight in kilograms' },
    },
    {
      name: 'sex',
      type: 'select',
      options: [
        { label: 'Female', value: 'female' },
        { label: 'Male', value: 'male' },
        { label: 'Other', value: 'other' },
        { label: 'Prefer not to say', value: 'unspecified' },
      ],
    },
    {
      name: 'level',
      type: 'select',
      defaultValue: 'beginner',
      options: [
        { label: 'Beginner', value: 'beginner' },
        { label: 'Returning', value: 'returning' },
        { label: 'Intermediate', value: 'intermediate' },
        { label: 'Advanced', value: 'advanced' },
      ],
      admin: { description: 'Training level used when generating or adapting a program' },
    },
    {
      name: 'conditionNotes',
      type: 'textarea',
      admin: {
        description: 'Injuries, limitations, pregnancy, or anything a program should respect',
      },
    },
    {
      name: 'trainingVenue',
      type: 'select',
      defaultValue: 'both',
      options: [
        { label: 'Home', value: 'home' },
        { label: 'Gym', value: 'gym' },
        { label: 'Home and gym', value: 'both' },
      ],
      admin: { description: 'Where you usually train' },
    },
    {
      name: 'preferredUnits',
      type: 'select',
      defaultValue: 'kg',
      options: [
        { label: 'Kilograms', value: 'kg' },
        { label: 'Pounds', value: 'lbs' },
      ],
      admin: { description: 'Display units for load' },
    },
    {
      name: 'defaultRestSeconds',
      type: 'number',
      min: 0,
      admin: { description: 'Default rest between sets, in seconds' },
    },
    { name: 'gender', type: 'text', admin: { hidden: true } },
    {
      name: 'fitnessLevel',
      type: 'select',
      admin: { hidden: true },
      options: [
        { label: 'Beginner', value: 'beginner' },
        { label: 'Intermediate', value: 'intermediate' },
        { label: 'Advanced', value: 'advanced' },
      ],
    },
    {
      name: 'goals',
      type: 'select',
      hasMany: true,
      options: [
        { label: 'General fitness', value: 'generalFitness' },
        { label: 'Strength', value: 'strength' },
        { label: 'Mobility', value: 'mobility' },
        { label: 'Cardio', value: 'cardio' },
        { label: 'Weight management', value: 'weightManagement' },
      ],
    },
    {
      name: 'language',
      type: 'select',
      defaultValue: 'en',
      options: [
        { label: 'English', value: 'en' },
        { label: 'Hebrew', value: 'he' },
      ],
      required: true,
    },
    {
      name: 'active',
      type: 'checkbox',
      defaultValue: true,
      access: {
        create: adminField,
        update: adminField,
      },
    },
  ],
  hooks: {
    afterRead: [
      ({ doc }) => {
        if (!doc.level && doc.fitnessLevel) doc.level = doc.fitnessLevel
        if (!doc.sex && typeof doc.gender === 'string') {
          const gender = doc.gender.toLowerCase()
          if (gender === 'female' || gender === 'male' || gender === 'other' || gender === 'unspecified') {
            doc.sex = gender
          }
        }
        return doc
      },
    ],
    beforeChange: [
      ({ data, operation, req }) => {
        const actor = req.user as AuthedUser | undefined
        if (actor && !isAdmin(actor)) {
          delete data.active
          if (operation === 'create') {
            data.roles = ['athlete']
          } else {
            delete data.roles
          }
        }
        if (data.level) {
          data.fitnessLevel =
            data.level === 'intermediate' || data.level === 'advanced' ? data.level : 'beginner'
        } else if (data.fitnessLevel && !data.level) {
          data.level = data.fitnessLevel
        }
        if (data.sex && !data.gender) {
          data.gender = data.sex
        }
        return data
      },
    ],
  },
  timestamps: true,
}
