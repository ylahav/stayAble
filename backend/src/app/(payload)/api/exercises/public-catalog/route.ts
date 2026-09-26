import { getPayloadClient } from '@/lib/auth'
import { loadPublicCatalog } from '@/lib/catalogEndpoints'

export async function GET() {
  const payload = await getPayloadClient()
  return Response.json(await loadPublicCatalog(payload))
}
