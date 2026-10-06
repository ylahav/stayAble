'use client'

import { useFormStatus } from 'react-dom'
import { useState } from 'react'

type Option = { id: string; label: string }

export function ImportBodyForm({
  athletes,
  notice,
}: {
  athletes: Option[]
  notice?: { error?: string; saved?: string; name?: string; when?: string; weight?: string; fat?: string; muscle?: string; bmi?: string }
}) {
  const [over, setOver] = useState(false)
  const [fileName, setFileName] = useState('')

  if (athletes.length === 0) {
    return <p className="muted">Invite and accept a trainee first, then import their scan.</p>
  }

  return (
    <form className="stack" action="/import-body/upload" method="post" encType="multipart/form-data">
      <label>
        Trainee
        <select name="athleteId" required defaultValue={athletes[0].id}>
          {athletes.map((row) => (
            <option key={row.id} value={row.id}>
              {row.label}
            </option>
          ))}
        </select>
      </label>
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
          const input = event.currentTarget.querySelector('input[type="file"]')
          const file = event.dataTransfer.files[0]
          if (file && input instanceof HTMLInputElement) {
            const transfer = new DataTransfer()
            transfer.items.add(file)
            input.files = transfer.files
            setFileName(file.name)
          }
        }}
      >
        <p style={{ margin: 0 }}>
          Drop a MyTanita PDF here. Only the current reading is stored, with the date printed on
          the report.
        </p>
        <label className="muted" style={{ fontWeight: 500 }}>
          Choose PDF
          <input
            type="file"
            name="file"
            accept="application/pdf,.pdf"
            required
            onChange={(event) => setFileName(event.target.files?.[0]?.name ?? '')}
          />
        </label>
        {fileName ? <p className="muted">{fileName}</p> : null}
      </div>
      {notice?.error ? <p className="error">{notice.error}</p> : null}
      {notice?.saved ? (
        <div className="stack">
          <p className="ok">
            {notice.saved === 'updated' ? 'Updated' : 'Saved'} {notice.name || 'trainee'}
            {notice.when ? ` for ${new Date(notice.when).toISOString().slice(0, 16).replace('T', ' ')}` : ''}
          </p>
          <div className="stat-row">
            {metric('Weight', notice.weight, ' kg')}
            {metric('Body fat', notice.fat, ' %')}
            {metric('Muscle', notice.muscle, ' kg')}
            {metric('BMI', notice.bmi)}
          </div>
        </div>
      ) : null}
      <SubmitButton />
    </form>
  )
}

function SubmitButton() {
  const { pending } = useFormStatus()
  return (
    <button className="btn" type="submit" disabled={pending}>
      {pending ? 'Importing…' : 'Import to trainee'}
    </button>
  )
}

function metric(label: string, value?: string, suffix = '') {
  if (value == null || value === '') return null
  const n = Number(value)
  return (
    <div className="stat">
      <b>
        {Number.isFinite(n) && !Number.isInteger(n) ? n.toFixed(2) : value}
        {suffix}
      </b>
      <span className="muted">{label}</span>
    </div>
  )
}
