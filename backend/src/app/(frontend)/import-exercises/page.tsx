import Link from 'next/link'
import { redirect } from 'next/navigation'

import { isStaff } from '@/access/roles'
import { SiteHeader } from '@/components/SiteHeader'
import { defaultPathFor, getCurrentUser } from '@/lib/auth'

import { ImportExercisesForm } from './ImportExercisesForm'

export default async function ImportExercisesPage() {
  const user = await getCurrentUser()
  if (!user) redirect('/login?next=/import-exercises')
  if (!isStaff(user)) redirect(defaultPathFor(user))

  return (
    <>
      <SiteHeader user={user} current="exercises" />
      <main className="wrap" style={{ padding: '2rem 0 4rem' }}>
        <div className="page-head">
          <div>
            <h1 className="page-title">Import exercises</h1>
            <p className="page-lead">
              Paste or drop the JSON from Gemini, Claude, GPT, or Copilot. Everything is saved{' '}
              <strong>inactive</strong> so you can check cues and Hebrew before athletes see it.
            </p>
          </div>
          <Link className="btn btn-ghost" href="/exercises">
            Back to exercises
          </Link>
        </div>
        <section className="panel" style={{ maxWidth: '44rem' }}>
          <ImportExercisesForm />
        </section>
      </main>
    </>
  )
}
