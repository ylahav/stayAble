import Link from 'next/link'

import { hasRole, isStaff, type AuthedUser } from '@/access/roles'

import { LogoutButton } from './LogoutButton'

type Props = {
  user: AuthedUser | null
  current?: 'home' | 'login' | 'dashboard' | 'programs' | 'profile' | 'import' | 'exercises' | 'backup'
}

export function SiteHeader({ user, current }: Props) {
  return (
    <header>
      <div className="floor-tape" />
      <div className="wrap site-header">
        <Link className="brand" href="/">
          StayAble
        </Link>
        <nav className="nav" aria-label="Primary">
          {!user && (
            <Link href="/login" aria-current={current === 'login' ? 'page' : undefined}>
              Log in
            </Link>
          )}
          {user && isStaff(user) && (
            <Link href="/dashboard" aria-current={current === 'dashboard' ? 'page' : undefined}>
              Dashboard
            </Link>
          )}
          {user && hasRole(user, 'athlete') && (
            <Link href="/programs" aria-current={current === 'programs' ? 'page' : undefined}>
              Programs
            </Link>
          )}
          {user && isStaff(user) && (
            <Link href="/exercises" aria-current={current === 'exercises' ? 'page' : undefined}>
              Exercises
            </Link>
          )}
          {user && (
            <Link href="/profile" aria-current={current === 'profile' ? 'page' : undefined}>
              Profile
            </Link>
          )}
          {user && hasRole(user, 'admin') && <a href="/admin">Admin</a>}
          {user && <LogoutButton />}
        </nav>
      </div>
    </header>
  )
}
