import { headers } from 'next/headers'
import { redirect } from 'next/navigation'
import { getPayload } from 'payload'

import { hasRole, type AuthedUser, type Role } from '@/access/roles'
import config from '@payload-config'

export async function getCurrentUser(from?: Headers): Promise<AuthedUser | null> {
  const payload = await getPayload({ config })
  const { user } = await payload.auth({ headers: from ?? (await headers()) })
  if (!user) return null
  return user as AuthedUser
}

export function defaultPathFor(user: AuthedUser): string {
  if (hasRole(user, 'instructor')) return '/dashboard'
  if (hasRole(user, 'trainee')) return '/programs'
  if (hasRole(user, 'admin')) return '/admin'
  return '/'
}

export async function requireUser(next = '/profile'): Promise<AuthedUser> {
  const user = await getCurrentUser()
  if (!user) redirect(`/login?next=${encodeURIComponent(next)}`)
  return user
}

export async function requireRoles(roles: Role[]): Promise<AuthedUser> {
  const user = await getCurrentUser()
  if (!user) redirect(`/login?next=${encodeURIComponent(rolesPath(roles[0]))}`)
  if (!roles.some((role) => hasRole(user, role))) {
    redirect(defaultPathFor(user))
  }
  return user
}

function rolesPath(role: Role): string {
  if (role === 'instructor') return '/dashboard'
  if (role === 'trainee') return '/programs'
  return '/admin'
}

export async function getPayloadClient() {
  return getPayload({ config })
}
