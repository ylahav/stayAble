import Link from 'next/link'

import { isAdmin, isStaff } from '@/access/roles'
import { SiteHeader } from '@/components/SiteHeader'
import { defaultPathFor, getCurrentUser, getPayloadClient } from '@/lib/auth'
import { relEmail, relId, relName } from '@/lib/relations'
import { redirect } from 'next/navigation'

import { BodyScanList } from '@/components/BodyScanList'
import { bodyScanFromDoc } from '@/lib/bodyScan'

import { ImportBodyForm } from './ImportBodyForm'

export const dynamic = 'force-dynamic'

type Props = {
  searchParams: Promise<{
    error?: string
    saved?: string
    name?: string
    when?: string
    weight?: string
    fat?: string
    muscle?: string
    bmi?: string
  }>
}

export default async function ImportBodyPage({ searchParams }: Props) {
  const user = await getCurrentUser()
  if (!user) redirect('/login?next=/import-body')
  if (!isStaff(user)) redirect(defaultPathFor(user))

  const payload = await getPayloadClient()
  const athletes = isAdmin(user)
    ? await payload.find({
        collection: 'users',
        depth: 0,
        limit: 200,
        pagination: false,
        sort: 'name',
        user,
        overrideAccess: false,
        where: {
          or: [{ roles: { contains: 'trainee' } }, { roles: { contains: 'athlete' } }],
        },
      })
    : await payload.find({
        collection: 'trainer-clients',
        depth: 1,
        limit: 200,
        pagination: false,
        user,
        overrideAccess: false,
        where: {
          and: [{ trainer: { equals: user.id } }, { status: { equals: 'active' } }],
        },
      })

  const options = isAdmin(user)
    ? athletes.docs.map((row) => {
        const person = row as { id: string; name?: string | null; email?: string | null }
        return { id: person.id, label: person.name || person.email || person.id }
      })
    : athletes.docs.map((row) => {
        const athlete = (row as { athlete?: unknown }).athlete
        const id = relId(athlete)
        return { id, label: relName(athlete) || relEmail(athlete) || id }
      })

  const recent = await payload.find({
    collection: 'body-measurements',
    depth: 1,
    limit: 80,
    pagination: false,
    sort: '-measuredAt',
    user,
    overrideAccess: false,
    where: { deleted: { not_equals: true } },
  })
  const scans = recent.docs.map((row) => bodyScanFromDoc(row))
  const notice = await searchParams

  return (
    <>
      <SiteHeader user={user} current="import-body" />
      <main className="wrap" style={{ padding: '2rem 0 4rem' }}>
        <div className="page-head">
          <div>
            <h1 className="page-title">Import body data</h1>
            <p className="page-lead">
              Attach a MyTanita PDF to one trainee. The current reading is stored with the date
              on the report. The history graph on the PDF is ignored.
            </p>
          </div>
          <Link className="btn btn-ghost" href="/dashboard">
            Back to dashboard
          </Link>
        </div>
        <div className="grid-2">
          <section className="panel stack">
            <ImportBodyForm
              athletes={options}
              notice={{
                error: notice.error,
                saved: notice.saved,
                name: notice.name,
                when: notice.when,
                weight: notice.weight,
                fat: notice.fat,
                muscle: notice.muscle,
                bmi: notice.bmi,
              }}
            />
          </section>
          <section className="panel">
            <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
              Recent imports
            </h2>
            <p className="muted">Open a row for the full scan, and compare dates for that trainee.</p>
            <BodyScanList
              scans={scans}
              empty="None yet."
            />
          </section>
        </div>
      </main>
    </>
  )
}
