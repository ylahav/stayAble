import Link from 'next/link'

import { SiteHeader } from '@/components/SiteHeader'
import { requireRoles, getPayloadClient } from '@/lib/auth'
import {
  minutesFromSeconds,
  relName,
  relVenue,
  scheduleTypeLabel,
  sessionStatusLabel,
  startOfWeek,
  venueLabel,
} from '@/lib/relations'

import { AcceptInvites } from './AcceptInvites'

export default async function ProgramsPage() {
  const user = await requireRoles(['trainee'])
  const payload = await getPayloadClient()

  const [assignments, sessions, invites] = await Promise.all([
    payload.find({
      collection: 'program-assignments',
      depth: 1,
      limit: 20,
      sort: '-updatedAt',
      user,
      overrideAccess: false,
      where: { athlete: { equals: user.id } },
    }),
    payload.find({
      collection: 'workout-sessions',
      depth: 1,
      limit: 40,
      sort: '-startedAt',
      user,
      overrideAccess: false,
      where: { athlete: { equals: user.id } },
    }),
    payload.find({
      collection: 'trainer-clients',
      depth: 1,
      limit: 20,
      user,
      overrideAccess: false,
      where: {
        and: [{ athlete: { equals: user.id } }, { status: { equals: 'invited' } }],
      },
    }),
  ])

  const weekStart = startOfWeek()
  const thisWeek = sessions.docs.filter((row) => new Date(row.startedAt) >= weekStart)
  const completed = thisWeek.filter((row) => row.status === 'completed').length
  const minutes = thisWeek.reduce(
    (sum, row) => sum + Math.round((row.duration ?? 0) / 60),
    0,
  )
  const active = assignments.docs.filter((row) => row.active)

  return (
    <>
      <SiteHeader user={user} current="programs" />
      <main className="wrap" style={{ padding: '2rem 0 4rem' }}>
        <h1 className="page-title">Programs</h1>
        <p className="page-lead">
          Programs you follow, and what you actually logged. Home and gymnastics-room programs
          both show here. Do the workout in the StayAble app.
        </p>

        <AcceptInvites count={invites.docs.length} />

        <div className="stat-row">
          <div className="stat">
            <b>{thisWeek.length}</b>
            <span className="muted">Sessions this week</span>
          </div>
          <div className="stat">
            <b>{completed}</b>
            <span className="muted">Completed</span>
          </div>
          <div className="stat">
            <b>{minutes}</b>
            <span className="muted">Minutes</span>
          </div>
        </div>

        <section className="panel" style={{ marginBottom: '1.25rem' }}>
          <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
            {active.length === 1 ? 'Current program' : 'Current programs'}
          </h2>
          {active.length === 0 ? (
            <p className="muted">No active assignment yet.</p>
          ) : (
            <ul style={{ margin: 0, paddingInlineStart: '1.2rem' }}>
              {active.map((row) => {
                const schedule = scheduleTypeLabel(row.scheduleType)
                return (
                <li key={row.id}>
                  {relName(row.program) || 'Assigned program'}
                  {relVenue(row.program) ? (
                    <span className="muted"> · {venueLabel(relVenue(row.program))}</span>
                  ) : null}
                  {schedule ? <span className="muted"> · {schedule}</span> : null}
                  {row.startDate ? (
                    <span className="muted"> · from {new Date(row.startDate).toLocaleDateString()}</span>
                  ) : null}
                </li>
                )
              })}
            </ul>
          )}
        </section>

        <section className="panel">
          <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
            Recent sessions
          </h2>
          <table className="table">
            <thead>
              <tr>
                <th>When</th>
                <th>Where</th>
                <th>Status</th>
                <th>Minutes</th>
                <th>kg</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {sessions.docs.length === 0 && (
                <tr>
                  <td colSpan={6} className="muted">
                    No sessions synced yet.
                  </td>
                </tr>
              )}
              {sessions.docs.map((row) => {
                return (
                  <tr key={row.id}>
                    <td>{new Date(row.startedAt).toLocaleString()}</td>
                    <td>{venueLabel(relVenue(row.program))}</td>
                    <td>{sessionStatusLabel(row.status)}</td>
                    <td>{minutesFromSeconds(row.duration)}</td>
                    <td>{row.totalVolumeKg ?? '—'}</td>
                    <td>
                      <Link href={`/sessions/${row.id}`}>What you did</Link>
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </section>
      </main>
    </>
  )
}
