'use client'

import { useState } from 'react'

import { importBackupPack, type ImportBackupResult } from './actions'

export function ImportBackupForm() {
  const [text, setText] = useState('')
  const [over, setOver] = useState(false)
  const [pending, setPending] = useState(false)
  const [result, setResult] = useState<ImportBackupResult | null>(null)

  async function onFile(file: File) {
    setText(await file.text())
    setResult(null)
  }

  return (
    <form
      className="stack"
      onSubmit={(event) => {
        event.preventDefault()
        setPending(true)
        void importBackupPack(text)
          .then((next) => {
            setResult(next)
            if (next.counts && !next.error) setText('')
          })
          .catch(() => {
            setResult({ error: 'Import failed.' })
          })
          .finally(() => setPending(false))
      }}
    >
      <div
        className={`dropzone${over ? ' dropzone-over' : ''}`}
        onDragOver={(event) => {
          event.preventDefault()
          setOver(true)
        }}
        onDragLeave={() => setOver(false)}
        onDrop={(event) => {
          event.preventDefault()
          setOver(false)
          const file = event.dataTransfer.files[0]
          if (file) void onFile(file)
        }}
      >
        <p style={{ margin: 0 }}>Drop a StayAble backup .json here, or paste below.</p>
        <label className="muted" style={{ fontWeight: 500 }}>
          Choose file
          <input
            type="file"
            accept="application/json,.json"
            onChange={(event) => {
              const file = event.target.files?.[0]
              if (file) void onFile(file)
              event.target.value = ''
            }}
          />
        </label>
      </div>
      <label>
        JSON
        <textarea
          value={text}
          onChange={(event) => {
            setText(event.target.value)
            setResult(null)
          }}
          spellCheck={false}
          placeholder='{ "kind": "stayable-pack", "version": 1, ... }'
          style={{ minHeight: '12rem', fontFamily: 'ui-monospace, monospace', fontSize: '0.88rem' }}
        />
      </label>
      {result?.error && <p className="error">{result.error}</p>}
      {result?.counts && (
        <p className="ok">
          Users {result.counts.users.created}/{result.counts.users.updated} · exercises{' '}
          {result.counts.exercises.created}/{result.counts.exercises.updated} · programs{' '}
          {result.counts.programs.created}/{result.counts.programs.updated} · sessions{' '}
          {result.counts.sessions.created}/{result.counts.sessions.updated} (created/updated)
        </p>
      )}
      {result?.counts?.warnings?.length ? (
        <p className="muted">{result.counts.warnings.join(' ')}</p>
      ) : null}
      <button className="btn" type="submit" disabled={pending || !text.trim()}>
        {pending ? 'Importing…' : 'Import backup'}
      </button>
    </form>
  )
}
