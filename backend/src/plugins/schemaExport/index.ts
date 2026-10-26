// Vendored from payload_flutter (packages/payload_schema_export).
// Replace with the npm package once payload-schema-export is published;
// until then, copy changes across from that repo rather than editing here.
import type { Config, PayloadRequest, Plugin } from 'payload'

import { buildSchema } from './serialize'

export { buildSchema } from './serialize'
export * from './types'

export type SchemaExportOptions = {
  /** Mounted under the API route, so the default serves `/api/_schema`. */
  path?: string
  /**
   * Who may read the schema. Field names, relations and option lists are
   * a map of your data model, so the default is any signed-in user.
   */
  access?: (args: { req: PayloadRequest }) => boolean | Promise<boolean>
  /** Turn the endpoint off (in one environment, say) without removing the plugin. */
  enabled?: boolean
}

export const schemaExport =
  (options: SchemaExportOptions = {}): Plugin =>
  (incoming: Config): Config => {
    if (options.enabled === false) return incoming

    const access = options.access ?? (({ req }) => Boolean(req.user))

    return {
      ...incoming,
      endpoints: [
        ...(incoming.endpoints ?? []),
        {
          path: options.path ?? '/_schema',
          method: 'get',
          handler: async (req) => {
            if (!(await access({ req }))) {
              return Response.json({ errors: [{ message: 'Unauthorized' }] }, { status: 401 })
            }
            // req.payload.config is the *sanitized* config: auth, upload,
            // timestamp and draft fields have already been added, which
            // is exactly what a client sees over the REST API.
            return Response.json(buildSchema(req.payload.config))
          },
        },
      ],
    }
  }
