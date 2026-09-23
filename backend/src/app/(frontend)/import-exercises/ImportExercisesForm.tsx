'use client'

import { useState } from 'react'

import { importExercises, type ImportExercisesResult } from './actions'

export function ImportExercisesForm() {
  const [text, setText] = useState('')
  const [over, setOver] = useState(false)
  const [pending, setPending] = useState(false)
  const [result, setResult] = useState<ImportExercisesResult | null>(null)

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
        void importExercises(text)
          .then((next) => {
            setResult(next)
            if (next.imported.length > 0 && !next.error) setText('')
          })
          .catch(() => {
            setResult({ error: 'Import failed.', imported: [], skipped: [] })
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
        <p style={{ margin: 0 }}>Drop a .json file here, or paste below.</p>
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
          placeholder='{ "clientId": "ex-hip-hinge", "name": { "en": "...", "he": "..." }, ... }'
          style={{ minHeight: '16rem', fontFamily: 'ui-monospace, monospace', fontSize: '0.88rem' }}
        />
      </label>
      {result?.error && <p className="error">{result.error}</p>}
      {result && result.imported.length > 0 && (
        <p className="ok">
          Imported inactive: {result.imported.join(', ')}. Review in Admin → Exercises, then turn
          Active on.
        </p>
      )}
      {result && result.skipped.length > 0 && (
        <ul className="muted" style={{ margin: 0, paddingInlineStart: '1.2rem' }}>
          {result.skipped.map((row) => (
            <li key={`${row.clientId}-${row.reason}`}>
              {row.clientId}: {row.reason}
            </li>
          ))}
        </ul>
      )}
      <button className="btn" type="submit" disabled={pending || !text.trim()}>
        {pending ? 'Importing…' : 'Import inactive'}
      </button>
    </form>
  )
}
