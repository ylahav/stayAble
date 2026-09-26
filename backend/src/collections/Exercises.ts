import type { CollectionConfig } from 'payload'

import { authenticated, staffOnly } from '../access/roles'
import { withCatalogTransfer } from '../lib/catalogEndpoints'
import { adminTitleField, clientIdField, deletedField, localizedTextFields } from '../fields/sync'
import { exerciseName } from '../lib/adminTitle'
import { stripLoopbackOrigin } from '../lib/publicOrigin'

export const Exercises: CollectionConfig = withCatalogTransfer({
  slug: 'exercises',
  admin: {
    defaultColumns: ['image', 'adminTitle', 'workoutType', 'venue', 'gymNumber', 'category'],
    useAsTitle: 'adminTitle',
    description:
      'Exercise library. Seeded rows keep ids like ex-squat. New rows get a client id automatically.',
    components: {
      beforeListTable: ['/components/admin/CatalogTransfer'],
    },
  },
  access: {
    create: staffOnly,
    delete: staffOnly,
    read: authenticated,
    update: staffOnly,
  },
  fields: [
    clientIdField,
    adminTitleField,
    deletedField,
    { name: 'name', type: 'group', fields: localizedTextFields },
    { name: 'description', type: 'group', fields: localizedTextFields },
    { name: 'instructions', type: 'group', fields: localizedTextFields },
    { name: 'safetyNotes', type: 'group', fields: localizedTextFields },
    {
      name: 'image',
      type: 'upload',
      relationTo: 'media',
    },
    {
      name: 'photoPath',
      type: 'text',
      admin: {
        description: 'Flutter asset path, e.g. assets/exercises/ex-squat.png',
      },
    },
    {
      name: 'category',
      type: 'select',
      options: [
        { label: 'Warm-up', value: 'warmUp' },
        { label: 'Mobility', value: 'mobility' },
        { label: 'Strength', value: 'strength' },
        { label: 'Cardio', value: 'cardio' },
        { label: 'Stretching', value: 'stretching' },
        { label: 'Cool-down', value: 'coolDown' },
      ],
      required: true,
    },
    {
      name: 'difficulty',
      type: 'select',
      options: [
        { label: 'Beginner', value: 'beginner' },
        { label: 'Intermediate', value: 'intermediate' },
        { label: 'Advanced', value: 'advanced' },
      ],
      required: true,
    },
    {
      name: 'venue',
      type: 'select',
      defaultValue: 'both',
      options: [
        { label: 'Home', value: 'home' },
        { label: 'Gym', value: 'gym' },
        { label: 'Home and gym', value: 'both' },
      ],
      required: true,
      admin: {
        description: 'Where this exercise can be performed',
      },
    },
    {
      name: 'workoutType',
      type: 'select',
      defaultValue: 'strength',
      options: [
        { label: 'Strength / hypertrophy', value: 'strength' },
        { label: 'Aerobic', value: 'aerobic' },
        { label: 'HIIT', value: 'hiit' },
        { label: 'Functional', value: 'functional' },
      ],
      required: true,
      admin: {
        description:
          'Main training style: resistance, cardio endurance, intervals, or everyday movement.',
      },
    },
    {
      name: 'gymNumber',
      type: 'number',
      min: 1,
      admin: {
        description: 'Optional machine number in the gymnastics room',
      },
    },
    { name: 'duration', type: 'number' },
    { name: 'repetitions', type: 'number' },
    { name: 'targetMuscles', type: 'text', hasMany: true },
    {
      name: 'equipment',
      type: 'select',
      defaultValue: 'none',
      options: [
        { label: 'None', value: 'none' },
        { label: 'Mat', value: 'mat' },
        { label: 'Resistance band', value: 'resistanceBand' },
        { label: 'Dumbbells', value: 'dumbbells' },
        { label: 'Chair', value: 'chair' },
        { label: 'Machine', value: 'machine' },
        { label: 'Barbell', value: 'barbell' },
        { label: 'Cable', value: 'cable' },
        { label: 'Kettlebell', value: 'kettlebell' },
        { label: 'Bench', value: 'bench' },
      ],
    },
    { name: 'active', type: 'checkbox', defaultValue: true },
  ],
  hooks: {
    beforeChange: [
      ({ data, originalDoc }) => {
        data.adminTitle =
          exerciseName(data.name) ||
          exerciseName(originalDoc?.name) ||
          (typeof originalDoc?.adminTitle === 'string' ? originalDoc.adminTitle : '') ||
          (typeof data.clientId === 'string' ? data.clientId : '')
        return data
      },
    ],
    afterRead: [
      ({ doc }) => {
        if (typeof doc.photoPath === 'string') {
          doc.photoPath = stripLoopbackOrigin(doc.photoPath)
        }
        doc.adminTitle = exerciseName(doc.name) || doc.clientId
        return doc
      },
    ],
  },
  timestamps: true,
}, 'exercises')
