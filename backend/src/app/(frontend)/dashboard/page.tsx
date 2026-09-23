import Link from 'next/link'

import { SiteHeader } from '@/components/SiteHeader'
import { isAdmin } from '@/access/roles'
import { requireRoles, getPayloadClient } from '@/lib/auth'
import {
  minutesFromSeconds,
  relEmail,
  relId,
  relName,
  relSelect,
  relVenue,
  scheduleTypeLabel,
  sessionStatusLabel,
  startOfWeek,
  venueLabel,
} from '@/lib/relations'

import { AssignForm } from './AssignForm'
import { DeleteProgramButton } from './DeleteProgramButton'
import { InviteForm } from './InviteForm'

export default async function DashboardPage() {
  const user = await requireRoles(['trainer', 'admin'])
  const payload = await getPayloadClient()

  const [links, programs, sessions] = await Promise.all([
    payload.find({
      collection: 'trainer-clients',
      depth: 1,
      limit: 100,
      sort: '-updatedAt',
      user,
      overrideAccess: false,
      where: { trainer: { equals: user.id } },
    }),
    payload.find({
      collection: 'programs',
      depth: 0,
      limit: 100,
      sort: 'name',
      user,
      overrideAccess: false,
      where: {
        and: [
          { deleted: { not_equals: true } },
          ...(isAdmin(user) ? [] : [{ owner: { equals: user.id } }]),
        ],
      },
    }),
    payload.find({
      collection: 'workout-sessions',
      depth: 1,
      limit: 20,
      sort: '-startedAt',
      user,
      overrideAccess: false,
    }),
  ])

  const assignments = await payload.find({
    collection: 'program-assignments',
    depth: 1,
    limit: 100,
    user,
    overrideAccess: false,
    where: { active: { equals: true } },
  })

  const assignmentByAthlete = new Map<
    string,
    { id: string; name: string; venue: string; schedule: string }[]
  >()
  for (const row of assignments.docs) {
    const athleteId = relId(row.athlete)
    const list = assignmentByAthlete.get(athleteId) ?? []
    list.push({
      id: row.id,
      name: relName(row.program) || 'Program',
      venue: relVenue(row.program),
      schedule: row.scheduleType ?? '',
    })
    assignmentByAthlete.set(athleteId, list)
  }

  const weekStart = startOfWeek()
  const weekSessions = sessions.docs.filter((row) => new Date(row.startedAt) >= weekStart)
  const trainedThisWeek = new Set(weekSessions.map((row) => relId(row.athlete)))
  const homeThisWeek = weekSessions.filter((row) => relVenue(row.program) === 'home').length
  const gymThisWeek = weekSessions.filter((row) => relVenue(row.program) === 'gym').length
  const mixedThisWeek = weekSessions.filter((row) => relVenue(row.program) === 'mixed').length
  const activeClients = links.docs.filter((row) => row.status === 'active')

  return (
    <>
      <SiteHeader user={user} current="dashboard" />
      <main className="wrap" style={{ padding: '2rem 0 4rem' }}>
        <div className="page-head">
          <div>
            <h1 className="page-title">Dashboard</h1>
            <p className="page-lead">
              Programs are reusable exercise collections. Assign one (or more) to a client, then
              refine when they train and the prescription if needed.
            </p>
          </div>
          <div style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
            <Link className="btn" href="/import-exercises">
              Import exercises
            </Link>
            {isAdmin(user) ? (
              <Link className="btn btn-ghost" href="/admin/backup">
                Backup
              </Link>
            ) : null}
          </div>
        </div>

        <div className="stat-row">
          <div className="stat">
            <b>{activeClients.length}</b>
            <span className="muted">Active clients</span>
          </div>
          <div className="stat">
            <b>{trainedThisWeek.size}</b>
            <span className="muted">Trained this week</span>
          </div>
          <div className="stat">
            <b>
              {homeThisWeek} / {gymThisWeek} / {mixedThisWeek}
            </b>
            <span className="muted">Home / gym / mixed this week</span>
          </div>
          <div className="stat">
            <b>{links.docs.filter((row) => row.status === 'invited').length}</b>
            <span className="muted">Pending invites</span>
          </div>
        </div>

        <div className="panel" style={{ marginBottom: '1.25rem' }}>
          <table className="table">
            <thead>
              <tr>
                <th>Client</th>
                <th>Status</th>
                <th>Trains</th>
                <th>Program</th>
                <th>Where</th>
              </tr>
            </thead>
            <tbody>
              {links.docs.length === 0 && (
                <tr>
                  <td colSpan={5} className="muted">
                    No clients yet. Invite someone with an account.
                  </td>
                </tr>
              )}
              {links.docs.map((row) => {
                const athleteId = relId(row.athlete)
                const assigned = assignmentByAthlete.get(athleteId) ?? []
                return (
                  <tr key={row.id}>
                    <td>
                      {relName(row.athlete) || relEmail(row.athlete) || athleteId}
                      <div className="muted">{relEmail(row.athlete)}</div>
                    </td>
                    <td>
                      <span className="pill">{row.status}</span>
                    </td>
                    <td>
                      <span className="pill">{venueLabel(relSelect(row.athlete, 'trainingVenue'))}</span>
                    </td>
                    <td>
                      {assigned.length === 0
                        ? '—'
                        : assigned.map((item) => (
                            <div key={item.id}>
                              {item.name}
                              {scheduleTypeLabel(item.schedule) ? (
                                <span className="muted"> · {scheduleTypeLabel(item.schedule)}</span>
                              ) : null}
                            </div>
                          ))}
                    </td>
                    <td>
                      {assigned.length === 0 ? (
                        <span className="pill">—</span>
                      ) : (
                        assigned.map((item) => (
                          <span key={item.id} className="pill">
                            {venueLabel(item.venue)}
                          </span>
                        ))
                      )}
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>

        <div className="grid-2">
          <section className="panel stack">
            <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
              Invite
            </h2>
            <InviteForm />
          </section>
          <section className="panel stack">
            <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
              Assign program
            </h2>
            <AssignForm
              athletes={activeClients.map((row) => ({
                id: relId(row.athlete),
                label: `${relName(row.athlete) || relEmail(row.athlete) || relId(row.athlete)} · ${venueLabel(relSelect(row.athlete, 'trainingVenue'))}`,
              }))}
              programs={programs.docs.map((row) => ({
                id: row.id,
                label: `${row.name} · ${venueLabel(row.venue)}`,
              }))}
            />
          </section>
        </div>

        <section style={{ marginTop: '1.5rem' }}>
          <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
            Programs
          </h2>
          <p className="muted">
            Edit the exercise list any time, including after someone has trained it. Delete removes
            the template and its assignments. Logged sessions stay.
          </p>
          <div className="panel">
            <table className="table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Where</th>
                    <th>Id</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {programs.docs.length === 0 && (
                  <tr>
                    <td colSpan={4} className="muted">
                      No programs yet. Create one in Admin.
                    </td>
                  </tr>
                )}
                {programs.docs.map((row) => (
                  <tr key={row.id}>
                    <td>{row.name}</td>
                    <td>
                      <span className="pill">{venueLabel(row.venue)}</span>
                    </td>
                    <td className="muted">{row.clientId}</td>
                    <td>
                      <div style={{ display: 'flex', gap: '0.5rem', justifyContent: 'flex-end' }}>
                        <Link className="btn btn-ghost" href={`/admin/collections/programs/${row.id}`}>
                          Edit
                        </Link>
                        {isAdmin(user) ? (
                          <DeleteProgramButton programId={row.id} name={row.name} />
                        ) : null}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        <section style={{ marginTop: '1.5rem' }}>
          <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
            Recent sessions
          </h2>
          <div className="panel">
            <table className="table">
              <thead>
                <tr>
                  <th>When</th>
                  <th>Athlete</th>
                  <th>Where</th>
                  <th>Status</th>
                  <th>Minutes</th>
                </tr>
              </thead>
              <tbody>
                {sessions.docs.length === 0 && (
                  <tr>
                    <td colSpan={5} className="muted">
                      No sessions yet.
                    </td>
                  </tr>
                )}
                {sessions.docs.map((row) => (
                  <tr key={row.id}>
                    <td>
                      <Link href={`/sessions/${row.id}`}>
                        {new Date(row.startedAt).toLocaleString()}
                      </Link>
                    </td>
                    <td>{relName(row.athlete) || relEmail(row.athlete)}</td>
                    <td>{venueLabel(relVenue(row.program))}</td>
                    <td>{sessionStatusLabel(row.status)}</td>
                    <td>{minutesFromSeconds(row.duration)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </>
  )
}
