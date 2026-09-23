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
