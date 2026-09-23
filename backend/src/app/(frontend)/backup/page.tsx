import Link from 'next/link'
import { redirect } from 'next/navigation'

import { isAdmin } from '@/access/roles'
import { SiteHeader } from '@/components/SiteHeader'
import { defaultPathFor, getCurrentUser } from '@/lib/auth'

import { ImportBackupForm } from './ImportBackupForm'

export default async function BackupPage() {
  const user = await getCurrentUser()
  if (!user) redirect('/login?next=/backup')
  if (!isAdmin(user)) redirect(defaultPathFor(user))

  return (
    <>
      <SiteHeader user={user} current="backup" />
      <main className="wrap" style={{ padding: '2rem 0 4rem' }}>
        <div className="page-head">
          <div>
            <h1 className="page-title">Backup</h1>
            <p className="page-lead">
              Download this site’s users, exercises, programs, sessions, and photos as one JSON
              file. Import that file on another machine (or keep it as a backup). Passwords are
              never exported; new users get <code>IMPORT_DEFAULT_PASSWORD</code>.
            </p>
          </div>
          <a className="btn" href="/backup/export">
            Download backup
          </a>
        </div>
        <section className="panel" style={{ maxWidth: '44rem' }}>
          <h2 className="page-title" style={{ fontSize: '1.4rem' }}>
            Import
          </h2>
          <p className="muted">
            Upserts by email (users) and client id (everything else). Photos in the pack replace
            matching media.
          </p>
          <ImportBackupForm />
        </section>
        <p className="muted" style={{ marginTop: '1.5rem' }}>
          <Link href="/dashboard">← Dashboard</Link>
        </p>
      </main>
    </>
  )
}
