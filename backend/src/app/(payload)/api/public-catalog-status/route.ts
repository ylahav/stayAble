import { getPayloadClient } from '@/lib/auth'
import { loadPublicCatalogStatus } from '@/lib/catalogEndpoints'

export async function GET() {
  const payload = await getPayloadClient()
  return Response.json(await loadPublicCatalogStatus(payload))
}
