import { BodyScanList } from '@/components/BodyScanList'
import { SiteHeader } from '@/components/SiteHeader'
import { getPayloadClient, requireUser } from '@/lib/auth'
import { bodyScanFromDoc } from '@/lib/bodyScan'

import { PasswordForm, ProfileForm } from './ProfileForms'

type Props = {
  searchParams: Promise<{ saved?: string; password?: string }>
}

export default async function ProfilePage({ searchParams }: Props) {
  const user = await requireUser('/profile')
  const payload = await getPayloadClient()
  const [profile, measurements] = await Promise.all([
    payload.findByID({
      collection: 'users',
      id: user.id,
      user,
      overrideAccess: false,
    }),
    payload.find({
      collection: 'body-measurements',
      depth: 0,
      limit: 80,
      pagination: false,
      sort: '-measuredAt',
      user,
      overrideAccess: false,
      where: {
        and: [{ athlete: { equals: user.id } }, { deleted: { not_equals: true } }],
      },
    }),
  ])
  const params = await searchParams
  const latest = measurements.docs[0]
  const scans = measurements.docs.map((row) => bodyScanFromDoc(row, profile.name || 'You'))

  return (
    <>
      <SiteHeader user={user} current="profile" />
      <main className="wrap" style={{ padding: '2rem 0 4rem' }}>
        <h1 className="page-title">Profile</h1>
        <p className="page-lead">
          Sex, age, weight, level, where you train, and condition are what a program is built from.
        </p>

        <div className="grid-2">
          <section className="panel stack">
            <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
              You
            </h2>
            <ProfileForm
              saved={params.saved === '1'}
              values={{
                name: profile.name,
                email: profile.email,
                sex: profile.sex ?? null,
                age: profile.age ?? null,
                weightKg: profile.weightKg ?? null,
                level: profile.level ?? profile.fitnessLevel ?? 'beginner',
                conditionNotes: profile.conditionNotes ?? null,
                trainingVenue: profile.trainingVenue ?? 'both',
                preferredUnits: profile.preferredUnits ?? 'kg',
              }}
            />
          </section>
          <section className="panel stack">
            <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
              Password
            </h2>
            <PasswordForm changed={params.password === '1'} />
          </section>
        </div>

        <section className="panel" style={{ marginTop: '1.5rem' }}>
          <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
            Body composition
          </h2>
          {latest ? (
            <>
              <p className="muted">
                Latest scan {new Date(latest.measuredAt).toLocaleString()}
                {latest.source === 'mytanita-pdf' ? ' · MyTanita' : ''}.
              </p>
              <div className="stat-row">
                <div className="stat">
                  <b>{latest.weightKg != null ? `${latest.weightKg} kg` : '—'}</b>
                  <span className="muted">Weight</span>
                </div>
                <div className="stat">
                  <b>{latest.bodyFatPercent != null ? `${latest.bodyFatPercent} %` : '—'}</b>
                  <span className="muted">Body fat</span>
                </div>
                <div className="stat">
                  <b>{latest.muscleMassKg != null ? `${latest.muscleMassKg} kg` : '—'}</b>
                  <span className="muted">Muscle</span>
                </div>
                <div className="stat">
                  <b>{latest.bmi ?? '—'}</b>
                  <span className="muted">BMI</span>
                </div>
                <div className="stat">
                  <b>{latest.bodyWaterPercent != null ? `${latest.bodyWaterPercent} %` : '—'}</b>
                  <span className="muted">Water</span>
                </div>
                <div className="stat">
                  <b>{latest.bmrKcal != null ? `${latest.bmrKcal} kcal` : '—'}</b>
                  <span className="muted">BMR</span>
                </div>
              </div>
              <p className="muted">Open a date for the full scan, and compare it with another stored date.</p>
              <BodyScanList
                scans={scans}
                showTrainee={false}
                empty="No imported scans yet. An instructor can add a MyTanita PDF."
              />
            </>
          ) : (
            <p className="muted">No imported scans yet. An instructor can add a MyTanita PDF.</p>
          )}
        </section>
      </main>
    </>
  )
}
