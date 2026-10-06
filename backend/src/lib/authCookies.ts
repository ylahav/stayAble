import type { NextResponse } from 'next/server'

import { publicServerURL } from './publicOrigin'

const TOKEN = 'payload-token'

function cookieDomain(): string | undefined {
  const origin = publicServerURL()
  if (!origin) return undefined
  try {
    const host = new URL(origin).hostname
    if (!host || host === 'localhost') return undefined
    return host
  } catch {
    return undefined
  }
}

export function expireAuthCookies(response: NextResponse) {
  const domain = cookieDomain()
  const variants: Array<{ secure: boolean; domain?: string }> = [
    { secure: true },
    { secure: false },
  ]
  if (domain) {
    variants.push({ secure: true, domain }, { secure: false, domain })
  }
  for (const variant of variants) {
    response.cookies.set({
      name: TOKEN,
      value: '',
      path: '/',
      maxAge: 0,
      expires: new Date(0),
      sameSite: 'lax',
      httpOnly: true,
      secure: variant.secure,
      ...(variant.domain ? { domain: variant.domain } : {}),
    })
  }
  response.cookies.delete(TOKEN)
}
