import type { Access, FieldAccess } from 'payload'

export type Role = 'athlete' | 'trainer' | 'admin'

export type AuthedUser = {
  id: string
  email?: string | null
  name?: string | null
  roles?: Role[] | null
}

export function hasRole(user: AuthedUser | null | undefined, role: Role): boolean {
  return Boolean(user?.roles?.includes(role))
}

export function isAdmin(user: AuthedUser | null | undefined): boolean {
  return hasRole(user, 'admin')
}

export function isTrainer(user: AuthedUser | null | undefined): boolean {
  return hasRole(user, 'trainer')
}

export function isStaff(user: AuthedUser | null | undefined): boolean {
  return isTrainer(user) || isAdmin(user)
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
