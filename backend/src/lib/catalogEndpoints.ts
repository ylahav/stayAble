import type { CollectionConfig, Endpoint, Payload, PayloadRequest } from 'payload'

import {
  catalogFilename,
  exportCatalogPack,
  importCatalogPack,
  parseCatalogPack,
  type CatalogCollection,
} from '@/lib/catalogPack'

function jsonError(error: string, status: number) {
  return Response.json({ error }, { status })
}

async function readJson(req: PayloadRequest): Promise<unknown> {
  if (typeof req.json === 'function') return req.json()
  return req.data ?? {}
}

function exportHandler(collection: CatalogCollection): Endpoint['handler'] {
  return async (req: PayloadRequest) => {
    let body: { ids?: unknown; where?: unknown } = {}
    try {
      body = ((await readJson(req)) as { ids?: unknown; where?: unknown }) ?? {}
    } catch {
      return jsonError('Request body must be JSON.', 400)
    }
    const result = await exportCatalogPack(req, collection, body)
    if (result.error || !result.pack) {
      return jsonError(result.error || 'Export failed.', result.status ?? 400)
    }
    const filename = catalogFilename(collection, result.pack.exportedAt)
    return new Response(JSON.stringify(result.pack, null, 2), {
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Content-Disposition': `attachment; filename="${filename}"`,
      },
    })
  }
}

function importHandler(): Endpoint['handler'] {
  return async (req: PayloadRequest) => {
    let raw = ''
    try {
      const body = (await readJson(req)) as { pack?: unknown; json?: unknown }
      if (typeof body?.json === 'string') raw = body.json
      else if (body?.pack) raw = JSON.stringify(body.pack)
      else raw = JSON.stringify(body)
    } catch {
      return jsonError('Request body must be JSON.', 400)
    }
    const parsed = parseCatalogPack(raw)
    if (parsed.error || !parsed.pack) {
      return jsonError(parsed.error || 'Import failed.', 400)
    }
    const result = await importCatalogPack(req, parsed.pack)
    if (result.error || !result.counts) {
      return jsonError(result.error || 'Import failed.', result.status ?? 400)
    }
    return Response.json({ counts: result.counts })
  }
}

const publicCatalogWhere = {
  and: [{ active: { equals: true } }, { deleted: { not_equals: true } }],
}

export async function loadPublicCatalog(payload: Payload) {
  const result = await payload.find({
    collection: 'exercises',
    depth: 1,
    limit: 300,
    overrideAccess: true,
    pagination: false,
    sort: 'clientId',
    where: publicCatalogWhere,
  })
  return { docs: result.docs }
}

export async function loadPublicCatalogStatus(payload: Payload) {
  const result = await payload.find({
    collection: 'exercises',
    depth: 0,
    limit: 300,
    overrideAccess: true,
    pagination: false,
    sort: 'clientId',
    where: publicCatalogWhere,
  })
  const ids: string[] = []
  let updatedAt: string | null = null
  for (const doc of result.docs) {
    if (typeof doc.clientId !== 'string' || doc.clientId.length === 0) continue
    ids.push(doc.clientId)
    const stamp = typeof doc.updatedAt === 'string' ? doc.updatedAt : null
    if (stamp && (!updatedAt || stamp > updatedAt)) updatedAt = stamp
  }
  return { count: ids.length, updatedAt, ids }
}

export function publicCatalogHandler(): Endpoint['handler'] {
  return async (req: PayloadRequest) => Response.json(await loadPublicCatalog(req.payload))
}

export function publicCatalogStatusHandler(): Endpoint['handler'] {
  return async (req: PayloadRequest) => Response.json(await loadPublicCatalogStatus(req.payload))
}

export function publicCatalogRootEndpoints(): Endpoint[] {
  return [
    { path: '/public-catalog', method: 'get', handler: publicCatalogHandler() },
    {
      path: '/public-catalog-status',
      method: 'get',
      handler: publicCatalogStatusHandler(),
    },
  ]
}

export function catalogEndpoints(collection: CatalogCollection): Endpoint[] {
  const endpoints: Endpoint[] = [
    { path: '/catalog-export', method: 'post', handler: exportHandler(collection) },
    { path: '/catalog-import', method: 'post', handler: importHandler() },
  ]
  if (collection === 'exercises') {
    endpoints.push(
      { path: '/public-catalog', method: 'get', handler: publicCatalogHandler() },
      {
        path: '/public-catalog-status',
        method: 'get',
        handler: publicCatalogStatusHandler(),
      },
    )
  }
  return endpoints
}

export function withCatalogTransfer(config: CollectionConfig, collection: CatalogCollection): CollectionConfig {
  return {
    ...config,
    endpoints: [...(Array.isArray(config.endpoints) ? config.endpoints : []), ...catalogEndpoints(collection)],
  }
}
