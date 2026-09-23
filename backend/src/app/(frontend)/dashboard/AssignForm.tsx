'use client'

import { useState } from 'react'

import { assignProgram } from './actions'

type Option = { id: string; label: string }

const weekdays = [
  { value: 1, label: 'Mon' },
  { value: 2, label: 'Tue' },
  { value: 3, label: 'Wed' },
  { value: 4, label: 'Thu' },
  { value: 5, label: 'Fri' },
  { value: 6, label: 'Sat' },
  { value: 7, label: 'Sun' },
] as const

export function AssignForm({
  athletes,
  programs,
}: {
  athletes: Option[]
  programs: Option[]
}) {
  const [error, setError] = useState<string | null>(null)
  const [ok, setOk] = useState(false)
  const [scheduleType, setScheduleType] = useState<'daily' | 'weekly' | 'custom'>('weekly')

  if (athletes.length === 0 || programs.length === 0) {
    return (
      <p className="muted">
        You need an accepted client and a program you own before you can assign.
      </p>
    )
  }

  return (
    <form
      className="form"
      action={async (formData) => {
        setOk(false)
        const result = await assignProgram(formData)
        setError(result.error ?? null)
        setOk(!result.error)
      }}
    >
      <p className="muted" style={{ margin: 0 }}>
        A program is a reusable list of exercises. Assigning it sets when this client trains. Home
        and gym programs can both stay assigned. Refine sets, reps, duration, or load on the
        assignment in Admin.
      </p>
      <label>
        Client
        <select name="athleteId" required defaultValue={athletes[0].id}>
          {athletes.map((row) => (
            <option key={row.id} value={row.id}>
              {row.label}
            </option>
          ))}
        </select>
      </label>
      <label>
        Program
        <select name="programId" required defaultValue={programs[0].id}>
          {programs.map((row) => (
            <option key={row.id} value={row.id}>
              {row.label}
            </option>
          ))}
        </select>
      </label>
      <label>
        When they train
        <select
          name="scheduleType"
          required
          value={scheduleType}
          onChange={(event) =>
            setScheduleType(event.target.value as 'daily' | 'weekly' | 'custom')
          }
        >
          <option value="weekly">Weekly</option>
          <option value="daily">Daily</option>
          <option value="custom">Custom dates</option>
        </select>
      </label>
      {scheduleType === 'weekly' ? (
        <fieldset style={{ border: 0, padding: 0, margin: 0 }}>
          <legend className="muted" style={{ marginBottom: '0.4rem' }}>
            Weekdays
          </legend>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.6rem' }}>
            {weekdays.map((day) => (
              <label key={day.value} style={{ display: 'flex', gap: '0.3rem', alignItems: 'center' }}>
                <input
                  type="checkbox"
                  name="weekday"
                  value={day.value}
                  defaultChecked={day.value === 1 || day.value === 3 || day.value === 5}
                />
                {day.label}
              </label>
            ))}
          </div>
        </fieldset>
      ) : null}
      {scheduleType === 'custom' ? (
        <p className="muted" style={{ margin: 0 }}>
          After assign, add specific dates on the assignment in Admin.
        </p>
      ) : null}
      <label>
        Start
        <input name="startDate" type="date" />
      </label>
      {error && <p className="error">{error}</p>}
      {ok && (
        <p className="muted">
          Assignment updated. Other programs for this athlete stay active. An in-progress workout
          is left as-is.
        </p>
      )}
      <button className="btn" type="submit">
        Assign program
      </button>
    </form>
  )
}
