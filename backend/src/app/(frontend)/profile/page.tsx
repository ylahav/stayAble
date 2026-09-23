import { SiteHeader } from '@/components/SiteHeader'
import { getPayloadClient, requireUser } from '@/lib/auth'

import { PasswordForm, ProfileForm } from './ProfileForms'

type Props = {
  searchParams: Promise<{ saved?: string; password?: string }>
}

export default async function ProfilePage({ searchParams }: Props) {
  const user = await requireUser('/profile')
  const payload = await getPayloadClient()
  const profile = await payload.findByID({
    collection: 'users',
    id: user.id,
    user,
    overrideAccess: false,
  })
  const params = await searchParams

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
      </main>
    </>
  )
}
