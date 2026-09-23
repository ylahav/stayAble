import { withPayload } from '@payloadcms/next/withPayload'
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  experimental: {
    serverActions: {
      bodySizeLimit: '50mb',
    },
  },
  async redirects() {
    return [
      {
        source: '/exercises/import',
        destination: '/import-exercises',
        permanent: false,
      },
      {
        source: '/admin/exercises/import',
        destination: '/import-exercises',
        permanent: false,
      },
      {
        source: '/backup',
        destination: '/admin/backup',
        permanent: false,
      },
      {
        source: '/import-firebase',
        destination: '/admin/backup',
        permanent: false,
      },
      {
        source: '/import-ygym',
        destination: '/admin/backup',
        permanent: false,
      },
    ]
  },
}

export default withPayload(nextConfig)
