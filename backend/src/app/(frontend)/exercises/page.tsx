import Link from 'next/link'
import { redirect } from 'next/navigation'

import { isAdmin, isStaff } from '@/access/roles'
import { SiteHeader } from '@/components/SiteHeader'
import { defaultPathFor, getCurrentUser, getPayloadClient } from '@/lib/auth'
import { mediaUrl } from '@/lib/relations'

const venueLabel: Record<string, string> = {
  home: 'Home',
  gym: 'Gym',
  both: 'Home + gym',
}

const workoutTypeLabel: Record<string, string> = {
  strength: 'Strength',
  aerobic: 'Aerobic',
  hiit: 'HIIT',
  functional: 'Functional',
}

export default async function ExercisesPage() {
  const user = await getCurrentUser()
  if (!user) redirect('/login?next=/exercises')
  if (!isStaff(user)) redirect(defaultPathFor(user))

  const payload = await getPayloadClient()
  const result = await payload.find({
    collection: 'exercises',
    depth: 1,
    limit: 200,
    pagination: false,
    sort: 'clientId',
    user,
    overrideAccess: false,
  })
  const rows = [...result.docs].sort((a, b) => {
    const aGym = a.gymNumber ?? Number.POSITIVE_INFINITY
    const bGym = b.gymNumber ?? Number.POSITIVE_INFINITY
    if (aGym !== bGym) return aGym - bGym
    if (Boolean(a.active) !== Boolean(b.active)) return a.active ? 1 : -1
    return (a.name?.en ?? a.clientId ?? '').localeCompare(b.name?.en ?? b.clientId ?? '')
  })

  return (
    <>
      <SiteHeader user={user} current="exercises" />
      <main className="wrap" style={{ padding: '2rem 0 4rem' }}>
        <div className="page-head">
          <div>
            <h1 className="page-title">Exercises</h1>
            <p className="page-lead">
              Catalog for home and the gymnastics room. Inactive rows stay hidden from athletes until you review them.
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

        <section className="panel">
          <table className="table">
            <thead>
              <tr>
                <th>Photo</th>
                <th>Name</th>
                <th>#</th>
                <th>Where</th>
                <th>Type</th>
                <th>Level</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {rows.length === 0 && (
                <tr>
                  <td colSpan={7} className="muted">
                    No exercises yet. Import JSON to add drafts.
                  </td>
                </tr>
              )}
              {rows.map((row) => (
                <tr key={row.id}>
                  <td>
                    {mediaUrl(row.image) ? (
                      <img
                        className="table-photo"
                        src={mediaUrl(row.image) ?? ''}
                        alt={row.name?.en || row.name?.he || ''}
                      />
                    ) : (
                      <span className="muted">—</span>
                    )}
                  </td>
                  <td>{row.name?.en || row.name?.he || '—'}</td>
                  <td className="muted">{row.gymNumber ?? '—'}</td>
                  <td>{venueLabel[row.venue ?? 'both']}</td>
                  <td>{workoutTypeLabel[row.workoutType ?? 'strength']}</td>
                  <td>{row.difficulty}</td>
                  <td>
                    <span className="pill">{row.active ? 'Active' : 'Inactive'}</span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      </main>
    </>
  )
}
