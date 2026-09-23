import type { CollectionConfig } from 'payload'

import { authenticated, staffOnly } from '../access/roles'
import { withCatalogTransfer } from '../lib/catalogEndpoints'
import { stripLoopbackOrigin } from '../lib/publicOrigin'

export const Media: CollectionConfig = withCatalogTransfer({
  slug: 'media',
  admin: {
    defaultColumns: ['filename', 'alt', 'updatedAt'],
    useAsTitle: 'filename',
    components: {
      beforeListTable: ['/components/admin/CatalogTransfer'],
    },
  },
  access: {
    create: staffOnly,
    delete: staffOnly,
    read: authenticated,
    update: staffOnly,
  },
  fields: [
    { name: 'alt', type: 'text', required: true },
    {
      name: 'clientId',
      type: 'text',
      admin: { description: 'Matches an exercise clientId when this is a catalog photo.' },
      index: true,
    },
  ],
  upload: {
    mimeTypes: ['image/png', 'image/jpeg', 'image/webp'],
    staticDir: 'media',
  },
  hooks: {
    afterRead: [
      ({ doc }) => {
        if (typeof doc.url === 'string') {
          doc.url = stripLoopbackOrigin(doc.url)
        }
        if (typeof doc.thumbnailURL === 'string') {
          doc.thumbnailURL = stripLoopbackOrigin(doc.thumbnailURL)
        }
        return doc
      },
    ],
  },
}, 'media')
