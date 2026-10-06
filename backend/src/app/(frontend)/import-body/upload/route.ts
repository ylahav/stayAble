import { headers } from 'next/headers'
import { NextResponse } from 'next/server'

import { getCurrentUser, getPayloadClient } from '@/lib/auth'
import { importTanitaForTrainee } from '@/lib/importTanita'
import { publicRedirect } from '@/lib/publicOrigin'

export const runtime = 'nodejs'
export const dynamic = 'force-dynamic'

export async function POST(request: Request) {
  const dest = publicRedirect(request, '/import-body')
  const user = (await getCurrentUser(request.headers)) ?? (await getCurrentUser(await headers()))
  if (!user) {
    dest.searchParams.set('error', 'Session was not sent with the upload. Refresh and try again.')
    return NextResponse.redirect(dest, 303)
  }

  let form: FormData
  try {
    form = await request.formData()
  } catch {
    dest.searchParams.set('error', 'Could not read the upload.')
    return NextResponse.redirect(dest, 303)
  }

  const file = form.get('file')
  if (!file || typeof file !== 'object' || typeof (file as Blob).arrayBuffer !== 'function') {
    dest.searchParams.set('error', 'Drop a MyTanita PDF first.')
    return NextResponse.redirect(dest, 303)
  }
  const blob = file as Blob & { name?: string }
  if (blob.size === 0) {
    dest.searchParams.set('error', 'Drop a MyTanita PDF first.')
    return NextResponse.redirect(dest, 303)
  }

  const payload = await getPayloadClient()
  const result = await importTanitaForTrainee({
    payload,
    user,
    athleteId: String(form.get('athleteId') ?? ''),
    filename: blob.name || 'scan.pdf',
    buffer: Buffer.from(await blob.arrayBuffer()),
  })

  if (result.error) {
    dest.searchParams.set('error', result.error.slice(0, 240))
    return NextResponse.redirect(dest, 303)
  }

  dest.searchParams.set('saved', result.updated ? 'updated' : '1')
  if (result.athleteName) dest.searchParams.set('name', result.athleteName)
  const values = result.values
  if (values?.measuredAt) dest.searchParams.set('when', values.measuredAt)
  if (values?.weightKg != null) dest.searchParams.set('weight', String(values.weightKg))
  if (values?.bodyFatPercent != null) dest.searchParams.set('fat', String(values.bodyFatPercent))
  if (values?.muscleMassKg != null) dest.searchParams.set('muscle', String(values.muscleMassKg))
  if (values?.bmi != null) dest.searchParams.set('bmi', String(values.bmi))
  return NextResponse.redirect(dest, 303)
}
