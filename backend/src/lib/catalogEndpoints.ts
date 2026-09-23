import type { CollectionConfig, Endpoint, PayloadRequest } from 'payload'

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

export function catalogEndpoints(collection: CatalogCollection): Endpoint[] {
  return [
    { path: '/catalog-export', method: 'post', handler: exportHandler(collection) },
    { path: '/catalog-import', method: 'post', handler: importHandler() },
  ]
}

export function withCatalogTransfer(config: CollectionConfig, collection: CatalogCollection): CollectionConfig {
  return {
    ...config,
    endpoints: [...(Array.isArray(config.endpoints) ? config.endpoints : []), ...catalogEndpoints(collection)],
  }
}
