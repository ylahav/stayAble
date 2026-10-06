import type { Access, FieldAccess } from 'payload'

export type Role = 'trainee' | 'instructor' | 'admin'

export type AuthedUser = {
  id: string
  email?: string | null
  name?: string | null
  roles?: Array<Role | 'athlete' | 'trainer'> | null
}

const roleAliases: Record<string, Role> = {
  trainee: 'trainee',
  instructor: 'instructor',
  admin: 'admin',
  athlete: 'trainee',
  trainer: 'instructor',
}

export function canonicalizeRole(value: unknown): Role | null {
  if (typeof value !== 'string') return null
  return roleAliases[value] ?? null
}

export function canonicalizeRoles(roles: unknown): Role[] {
  if (!Array.isArray(roles)) return []
  const next = new Set<Role>()
  for (const role of roles) {
    const canon = canonicalizeRole(role)
    if (canon) next.add(canon)
  }
  return [...next]
}

export function rolesChanged(current: unknown, next: Role[]): boolean {
  const prev = canonicalizeRoles(current)
  if (prev.length !== next.length) return true
  return next.some((role) => !prev.includes(role))
}

/** True when stored role strings still need rewriting to canonical values. */
export function storedRolesNeedRewrite(current: unknown, next: Role[]): boolean {
  if (!Array.isArray(current)) return next.length > 0
  const raw = current.filter((role): role is string => typeof role === 'string')
  if (raw.length !== next.length) return true
  const rawSet = new Set(raw)
  return next.some((role) => !rawSet.has(role))
}

export function hasRole(user: AuthedUser | null | undefined, role: Role): boolean {
  return canonicalizeRoles(user?.roles).includes(role)
}

export function isAdmin(user: AuthedUser | null | undefined): boolean {
  return hasRole(user, 'admin')
}

export function isInstructor(user: AuthedUser | null | undefined): boolean {
  return hasRole(user, 'instructor')
}

export function isStaff(user: AuthedUser | null | undefined): boolean {
  return isInstructor(user) || isAdmin(user)
}

export const anyone: Access = () => true

export const authenticated: Access = ({ req: { user } }) => Boolean(user)

export const adminOnly: Access = ({ req: { user } }) => isAdmin(user as AuthedUser)

export const staffOnly: Access = ({ req: { user } }) => isStaff(user as AuthedUser)

export const adminField: FieldAccess = ({ req: { user } }) => isAdmin(user as AuthedUser)

export const selfOrStaff: Access = ({ req: { user } }) => {
  if (!user) return false
  if (isStaff(user as AuthedUser)) return true
  return { id: { equals: user.id } }
}
