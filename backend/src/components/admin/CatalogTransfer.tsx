'use client'

import { useRef, useState } from 'react'

import {
  Button,
  toast,
  useAuth,
  useConfig,
  useListQuery,
  useSelection,
} from '@payloadcms/ui'

type Props = {
  collectionSlug?: string
}

type CatalogCounts = {
  media: { created: number; updated: number; skipped: number }
  exercises: { created: number; updated: number; skipped: number }
  programs: { created: number; updated: number; skipped: number }
  warnings?: string[]
}

function summarize(counts: CatalogCounts): string {
  const parts = [
    counts.media.created + counts.media.updated > 0
      ? `media ${counts.media.created}/${counts.media.updated}`
      : null,
    counts.exercises.created + counts.exercises.updated > 0
      ? `exercises ${counts.exercises.created}/${counts.exercises.updated}`
      : null,
    counts.programs.created + counts.programs.updated > 0
      ? `programs ${counts.programs.created}/${counts.programs.updated}`
      : null,
  ].filter(Boolean)
  const skipped =
    counts.media.skipped + counts.exercises.skipped + counts.programs.skipped
  const summary = parts.length > 0 ? parts.join(' · ') : 'Nothing new'
  return skipped > 0 ? `${summary} · skipped ${skipped}` : summary
}

export default function CatalogTransfer({ collectionSlug }: Props) {
  const fileRef = useRef<HTMLInputElement>(null)
  const [busy, setBusy] = useState<'export' | 'import' | null>(null)
  const { token } = useAuth()
  const { config } = useConfig()
  const { collectionSlug: listSlug, query } = useListQuery()
  const { count, selectAll, selectedIDs } = useSelection()
  const slug = collectionSlug || listSlug

  if (!slug) return null

  const api = `${config.serverURL || ''}${config.routes.api}/${slug}`
  const headers: HeadersInit = {
    'Content-Type': 'application/json',
    ...(token ? { Authorization: `JWT ${token}` } : {}),
  }

  async function exportSelected() {
    if (!count) {
      toast.error('Select one or more rows to export.')
      return
    }
    setBusy('export')
    try {
      const payload =
        selectAll === 'allAvailable'
          ? { where: query?.where ?? {} }
          : { ids: selectedIDs }
      const response = await fetch(`${api}/catalog-export`, {
        method: 'POST',
        credentials: 'include',
        headers,
        body: JSON.stringify(payload),
      })
      if (!response.ok) {
        const body = (await response.json().catch(() => null)) as { error?: string } | null
        throw new Error(body?.error || 'Export failed.')
      }
      const blob = await response.blob()
      const name =
        response.headers.get('Content-Disposition')?.match(/filename="([^"]+)"/)?.[1] ||
        `stayable-${slug}.json`
      const url = URL.createObjectURL(blob)
      const link = document.createElement('a')
      link.href = url
      link.download = name
      document.body.appendChild(link)
      link.click()
      link.remove()
      URL.revokeObjectURL(url)
      toast.success(`Exported ${count} ${slug}`)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Export failed.')
    } finally {
      setBusy(null)
    }
  }

  async function importFile(file: File) {
    setBusy('import')
    try {
      const json = await file.text()
      const response = await fetch(`${api}/catalog-import`, {
        method: 'POST',
        credentials: 'include',
        headers,
        body: JSON.stringify({ json }),
      })
      const body = (await response.json().catch(() => null)) as
        | { error?: string; counts?: CatalogCounts }
        | null
      if (!response.ok || !body?.counts) {
        throw new Error(body?.error || 'Import failed.')
      }
      toast.success(summarize(body.counts))
      if (body.counts.warnings?.length) {
        toast.message(body.counts.warnings.slice(0, 3).join(' '))
      }
      window.location.reload()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Import failed.')
    } finally {
      setBusy(null)
      if (fileRef.current) fileRef.current.value = ''
    }
  }

  return (
    <div
      style={{
        display: 'flex',
        flexWrap: 'wrap',
        gap: 8,
        alignItems: 'center',
        margin: '0 0 12px',
      }}
    >
      <Button
        buttonStyle="secondary"
        disabled={busy !== null || !count}
        onClick={() => void exportSelected()}
        size="small"
        tooltip={
          count
            ? `Export ${count} selected, including related photos`
            : 'Select one or more rows, then export'
        }
        type="button"
      >
        {busy === 'export' ? 'Exporting…' : 'Export selected'}
      </Button>
      <Button
        buttonStyle="secondary"
        disabled={busy !== null}
        onClick={() => fileRef.current?.click()}
        size="small"
        tooltip="Import a StayAble catalog JSON, including images"
        type="button"
      >
        {busy === 'import' ? 'Importing…' : 'Import'}
      </Button>
      <input
        accept="application/json,.json"
        hidden
        onChange={(event) => {
          const file = event.target.files?.[0]
          if (file) void importFile(file)
        }}
        ref={fileRef}
        type="file"
      />
    </div>
  )
}
