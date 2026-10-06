import Link from 'next/link'

import { SiteHeader } from '@/components/SiteHeader'
import { defaultPathFor, getCurrentUser } from '@/lib/auth'

export default async function HomePage() {
  const user = await getCurrentUser()

  return (
    <>
      <SiteHeader user={user} current="home" />
      <main className="wrap hero">
        <h1>StayAble — keep your body able.</h1>
        <p className="lede">
          A home-or-gym practice: follow a program, log what you really did, and let an instructor
          assign the next block. Not a new body. The same one, for years. This site is where you
          sign in; workouts happen in the app.
        </p>
        {user ? (
          <Link className="btn" href={defaultPathFor(user)}>
            Continue
          </Link>
        ) : (
          <Link className="btn" href="/login">
            Log in
          </Link>
        )}
      </main>
    </>
  )
}
