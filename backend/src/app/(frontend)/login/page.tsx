import { redirect } from 'next/navigation'

import { SiteHeader } from '@/components/SiteHeader'
import { defaultPathFor, getCurrentUser } from '@/lib/auth'

import { LoginForm } from './LoginForm'

type Props = {
  searchParams: Promise<{ next?: string }>
}

export default async function LoginPage({ searchParams }: Props) {
  const user = await getCurrentUser()
  const { next } = await searchParams
  const nextPath = safeNext(next)

  if (user) redirect(nextPath === '/login' ? defaultPathFor(user) : nextPath)

  return (
    <>
      <SiteHeader user={null} current="login" />
      <main className="wrap" style={{ padding: '3rem 0 4rem' }}>
        <h1 className="page-title">Log in</h1>
        <p className="page-lead">Same account for instructor dashboard, trainee programs, and admin.</p>
        <div className="panel">
          <LoginForm nextPath={nextPath} />
        </div>
      </main>
    </>
  )
}

function safeNext(value?: string): string {
  if (!value || !value.startsWith('/') || value.startsWith('//')) return '/'
  return value
}
