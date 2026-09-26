import path from 'path'
import { fileURLToPath } from 'url'

import { mongooseAdapter } from '@payloadcms/db-mongodb'
import { lexicalEditor } from '@payloadcms/richtext-lexical'
import { backupPlugin } from '@yairl/payload-db-backup-restore'
import { buildConfig } from 'payload'
import sharp from 'sharp'

import { isAdmin, type AuthedUser } from './access/roles'
import { Exercises } from './collections/Exercises'
import { Media } from './collections/Media'
import { ProgramAssignments } from './collections/ProgramAssignments'
import { Programs } from './collections/Programs'
import { TrainerClients } from './collections/TrainerClients'
import { Users } from './collections/Users'
import { WorkoutSessions } from './collections/WorkoutSessions'
import { seedExerciseCatalog } from './seed/exercises'
import { seedDefaultProgram } from './seed/program'
import { seedCompletedSession } from './seed/sessions'
import { publicCatalogRootEndpoints } from './lib/catalogEndpoints'
import { configuredOrigins, publicServerURL } from './lib/publicOrigin'

const filename = fileURLToPath(import.meta.url)
const dirname = path.dirname(filename)

function requirePayloadSecret(): string {
  const secret = process.env.PAYLOAD_SECRET?.trim() ?? ''
  const placeholders = new Set([
    '',
    'dev-only-change-me',
    'change-me',
    'change-me-to-a-long-random-string',
  ])
  if (placeholders.has(secret) || secret.length < 16) {
    throw new Error(
      'PAYLOAD_SECRET must be a long random string (16+ characters). Copy backend/.env.example to backend/.env and set it.',
    )
  }
  return secret
}

const serverURL = publicServerURL()
const cors =
  configuredOrigins().length > 0
      ? configuredOrigins()
      : ['http://localhost:3000']

export default buildConfig({
  admin: {
    importMap: {
      baseDir: path.resolve(dirname),
    },
    meta: {
      titleSuffix: '— StayAble',
    },
    user: Users.slug,
  },
  collections: [
    Users,
    Media,
    Exercises,
    Programs,
    ProgramAssignments,
    TrainerClients,
    WorkoutSessions,
  ],
  cors,
  csrf: cors,
  endpoints: publicCatalogRootEndpoints(),
  db: mongooseAdapter({
    url: process.env.DATABASE_URI || '',
  }),
  editor: lexicalEditor(),
  graphQL: {
    disable: true,
  },
  plugins: [
    backupPlugin({
      access: (req) => isAdmin(req.user as AuthedUser),
    }),
  ],
  onInit: async (payload) => {
    const email = process.env.PAYLOAD_ADMIN_EMAIL
    const password = process.env.PAYLOAD_ADMIN_PASSWORD
    const emailLooksValid = Boolean(email && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))

    if (email && password && !emailLooksValid) {
      payload.logger.warn(
        `PAYLOAD_ADMIN_EMAIL "${email}" is not a valid address (e.g. admin@example.com). Skipping admin seed.`,
      )
    } else if (emailLooksValid && email && password) {
      const existing = await payload.find({
        collection: 'users',
        limit: 1,
        pagination: false,
        where: { email: { equals: email } },
      })
      if (existing.totalDocs === 0) {
        await payload.create({
          collection: 'users',
          overrideAccess: true,
          data: {
            active: true,
            email,
            goals: [],
            language: 'en',
            level: 'beginner',
            name: 'Admin',
            password,
            roles: ['admin', 'trainer', 'athlete'],
          },
        })
        payload.logger.info(`Created initial admin user ${email}`)
      } else {
        const user = existing.docs[0]
        const roles = new Set(user.roles ?? [])
        if (!roles.has('admin')) {
          roles.add('admin')
          await payload.update({
            collection: 'users',
            id: user.id,
            overrideAccess: true,
            data: { roles: [...roles] },
          })
          payload.logger.info(`Granted admin role to ${email}`)
        }
      }
    }

    try {
      await seedExerciseCatalog(payload)
      await seedDefaultProgram(payload)
      await seedCompletedSession(payload)
    } catch (err) {
      payload.logger.error({ err }, 'Seed failed')
    }
  },
  secret: requirePayloadSecret(),
  ...(serverURL ? { serverURL } : {}),
  sharp,
  typescript: {
    outputFile: path.resolve(dirname, 'payload-types.ts'),
  },
})
