const LOOPBACK = new Set(['localhost', '127.0.0.1', '::1'])

export function configuredOrigins(): string[] {
  const raw = [process.env.PAYLOAD_PUBLIC_URL, process.env.NEXT_PUBLIC_SERVER_URL, process.env.PAYLOAD_CORS]
    .filter(Boolean)
    .join(',')
  return [
    ...new Set(
      raw
        .split(',')
        .map((origin) => origin.trim().replace(/\/$/, ''))
        .filter(Boolean),
    ),
  ]
}

/** Public origin for cookies/admin. Loopback is omitted so media URLs stay relative. */
export function publicServerURL(): string | undefined {
  for (const origin of configuredOrigins()) {
    try {
      const url = new URL(origin)
      if (!LOOPBACK.has(url.hostname)) return origin
    } catch {
      // skip invalid
    }
  }
  return undefined
}

function firstHeader(value: string | null): string {
  return value?.split(',')[0]?.trim() ?? ''
}

function isLoopbackHost(host: string): boolean {
  const name = host.split(':')[0]?.toLowerCase() ?? ''
  return LOOPBACK.has(name)
}

/** Browser-facing origin. PAYLOAD_PUBLIC_URL wins so redirects never use localhost:3040. */
export function publicRequestOrigin(request: Request): string {
  const configured = publicServerURL()
  if (configured) return configured
  const forwardedHost = firstHeader(request.headers.get('x-forwarded-host'))
  const forwardedProto = firstHeader(request.headers.get('x-forwarded-proto'))
  if (forwardedHost && !isLoopbackHost(forwardedHost)) {
    return `${forwardedProto || 'https'}://${forwardedHost}`
  }
  const host = firstHeader(request.headers.get('host'))
  if (host && !isLoopbackHost(host)) {
    return `${forwardedProto || new URL(request.url).protocol.replace(':', '')}://${host}`
  }
  return new URL(request.url).origin
}

export function publicRedirect(request: Request, path: string): URL {
  return new URL(path, `${publicRequestOrigin(request)}/`)
}

/** Turn http://localhost:3040/api/media/file/x.jpeg into /api/media/file/x.jpeg */
export function stripLoopbackOrigin(url: string): string {
  const trimmed = url.trim()
  if (!/^https?:\/\//i.test(trimmed)) return trimmed
  try {
    const parsed = new URL(trimmed)
    if (LOOPBACK.has(parsed.hostname)) {
      return `${parsed.pathname}${parsed.search}`
    }
  } catch {
    return trimmed
  }
  return trimmed
}
