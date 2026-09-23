import { NextResponse } from 'next/server'

import { isAdmin } from '@/access/roles'
import { getCurrentUser, getPayloadClient } from '@/lib/auth'
import { exportStayAblePack } from '@/lib/pack'

export async function GET() {
  const user = await getCurrentUser()
  if (!user || !isAdmin(user)) {
    return NextResponse.json({ error: 'Admin only.' }, { status: 403 })
  }

  const payload = await getPayloadClient()
  const pack = await exportStayAblePack(payload)
  const stamp = pack.exportedAt.slice(0, 10)
  return new NextResponse(JSON.stringify(pack, null, 2), {
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Content-Disposition': `attachment; filename="stayable-${stamp}.json"`,
    },
  })
}
