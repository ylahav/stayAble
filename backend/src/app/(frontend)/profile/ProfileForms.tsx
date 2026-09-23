'use client'

import { useState } from 'react'

import { changePassword, updateProfile } from './actions'

type ProfileValues = {
  name: string
  email: string
  sex: string | null
  age: number | null
  weightKg: number | null
  level: string | null
  conditionNotes: string | null
  trainingVenue: string | null
  preferredUnits: string | null
}

export function ProfileForm({
  values,
  saved,
}: {
  values: ProfileValues
  saved: boolean
}) {
  const [error, setError] = useState<string | null>(null)

  return (
    <form
      className="form"
      action={async (formData) => {
        const result = await updateProfile(formData)
        if (result.error) {
          setError(result.error)
          return
        }
        window.location.href = '/profile?saved=1'
      }}
    >
      <label>
        Name
        <input name="name" type="text" required defaultValue={values.name} autoComplete="name" />
      </label>
      <label>
        Email
        <input type="email" value={values.email} disabled readOnly />
      </label>
      <label>
        Sex
        <select name="sex" defaultValue={values.sex ?? ''}>
          <option value="">Select</option>
          <option value="female">Female</option>
          <option value="male">Male</option>
          <option value="other">Other</option>
          <option value="unspecified">Prefer not to say</option>
        </select>
      </label>
      <label>
        Age
        <input
          name="age"
          type="number"
          min={10}
          max={120}
          step={1}
          defaultValue={values.age ?? ''}
        />
      </label>
      <label>
        Weight (kg)
        <input
          name="weightKg"
          type="number"
          min={20}
          max={400}
          step={0.5}
          defaultValue={values.weightKg ?? ''}
        />
      </label>
      <label>
        Level
        <select name="level" defaultValue={values.level ?? 'beginner'}>
          <option value="beginner">Beginner</option>
          <option value="returning">Returning</option>
          <option value="intermediate">Intermediate</option>
          <option value="advanced">Advanced</option>
        </select>
      </label>
      <label>
        Where you train
        <select name="trainingVenue" defaultValue={values.trainingVenue ?? 'both'}>
          <option value="home">Home</option>
          <option value="gym">Gym</option>
          <option value="both">Home and gym</option>
        </select>
      </label>
      <label>
        Units
        <select name="preferredUnits" defaultValue={values.preferredUnits ?? 'kg'}>
          <option value="kg">Kilograms</option>
          <option value="lbs">Pounds</option>
        </select>
      </label>
      <label>
        Condition
        <textarea
          name="conditionNotes"
          defaultValue={values.conditionNotes ?? ''}
          placeholder="Knees, lower back, pregnancy, or anything a program should respect"
        />
      </label>
      {error && <p className="error">{error}</p>}
      {saved && !error && <p className="ok">Profile saved.</p>}
      <button className="btn" type="submit">
        Save profile
      </button>
    </form>
  )
}

export function PasswordForm({ changed }: { changed: boolean }) {
  const [error, setError] = useState<string | null>(null)

  return (
    <form
      className="form"
      action={async (formData) => {
        const result = await changePassword(formData)
        if (result.error) {
          setError(result.error)
          return
        }
        window.location.href = '/profile?password=1'
      }}
    >
      <label>
        Current password
        <input
          name="currentPassword"
          type="password"
          required
          autoComplete="current-password"
        />
      </label>
      <label>
        New password
        <input
          name="newPassword"
          type="password"
          required
          minLength={8}
          autoComplete="new-password"
        />
      </label>
      <label>
        Confirm new password
        <input
          name="confirmPassword"
          type="password"
          required
          minLength={8}
          autoComplete="new-password"
        />
      </label>
      {error && <p className="error">{error}</p>}
      {changed && !error && <p className="ok">Password updated.</p>}
      <button className="btn" type="submit">
        Change password
      </button>
    </form>
  )
}
