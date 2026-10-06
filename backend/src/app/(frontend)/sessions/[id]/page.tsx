import Link from 'next/link'
import { notFound } from 'next/navigation'

import { SessionDetail } from '@/components/SessionDetail'
import { SiteHeader } from '@/components/SiteHeader'
import { hasRole } from '@/access/roles'
import { getPayloadClient, requireUser } from '@/lib/auth'

type Props = {
  params: Promise<{ id: string }>
}

export default async function SessionPage({ params }: Props) {
  const { id } = await params
  const user = await requireUser(`/sessions/${id}`)
  const payload = await getPayloadClient()

  let session
  try {
    session = await payload.findByID({
      collection: 'workout-sessions',
      id,
      depth: 2,
      user,
      overrideAccess: false,
    })
  } catch {
    notFound()
  }

  if (!session) notFound()

  const backHref = hasRole(user, 'trainee') ? '/programs' : '/dashboard'

  return (
    <>
      <SiteHeader user={user} />
      <main className="wrap" style={{ padding: '2rem 0 4rem' }}>
        <p className="muted" style={{ marginTop: 0 }}>
          <Link href={backHref}>← Recent sessions</Link>
        </p>
        <h1 className="page-title">Session</h1>
        <p className="page-lead">What was planned, and what was actually logged.</p>
        <div className="panel">
          <SessionDetail session={session} />
        </div>
      </main>
    </>
  )
}
