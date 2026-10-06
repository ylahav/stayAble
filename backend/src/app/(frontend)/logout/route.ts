import { NextResponse } from 'next/server'

import { expireAuthCookies } from '@/lib/authCookies'
import { publicRedirect } from '@/lib/publicOrigin'

export const runtime = 'nodejs'
export const dynamic = 'force-dynamic'

function logoutResponse(request: Request) {
  const response = NextResponse.redirect(publicRedirect(request, '/login'), 303)
  response.headers.set('Cache-Control', 'no-store')
  expireAuthCookies(response)
  return response
}

export async function GET(request: Request) {
  return logoutResponse(request)
}

export async function POST(request: Request) {
  return logoutResponse(request)
}
