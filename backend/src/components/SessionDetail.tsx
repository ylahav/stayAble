import type { WorkoutSession } from '@/payload-types'
import {
  effortLabel,
  exerciseImageUrl,
  exerciseName,
  formatSeconds,
  minutesFromSeconds,
  relName,
  relVenue,
  sessionStatusLabel,
  venueLabel,
  vs,
} from '@/lib/relations'

export function SessionDetail({ session }: { session: WorkoutSession }) {
  const exercises = [...(session.exercises ?? [])].sort(
    (a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0),
  )

  return (
    <>
      <div className="stat-row">
        <div className="stat">
          <b>{sessionStatusLabel(session.status)}</b>
          <span className="muted">Status</span>
        </div>
        <div className="stat">
          <b>{minutesFromSeconds(session.duration)}</b>
          <span className="muted">Minutes</span>
        </div>
        <div className="stat">
          <b>{session.totalVolumeKg != null ? session.totalVolumeKg : '—'}</b>
          <span className="muted">Volume kg</span>
        </div>
        <div className="stat">
          <b>
            {exercises.filter((item) => item.completed).length}/{exercises.length}
          </b>
          <span className="muted">Exercises done</span>
        </div>
      </div>

      <p className="muted" style={{ marginTop: 0 }}>
        {new Date(session.startedAt).toLocaleString()}
        {session.completedAt
          ? ` → ${new Date(session.completedAt).toLocaleString()}`
          : null}
        {relName(session.program) ? ` · ${relName(session.program)}` : null}
        {relVenue(session.program) ? ` · ${venueLabel(relVenue(session.program))}` : null}
      </p>
      {session.notes ? <p>{session.notes}</p> : null}

      {exercises.length === 0 ? (
        <p className="muted">No exercise results on this session yet.</p>
      ) : (
        <div className="stack">
          {exercises.map((item) => {
            const sets = [...(item.sets ?? [])].sort(
              (a, b) => a.setNumber - b.setNumber,
            )
            const timed = (item.plannedDuration ?? item.actualDuration ?? 0) > 0
            const photo = exerciseImageUrl(item.exercise)
            return (
              <article className="exercise-block" key={item.id ?? item.clientId}>
                <header className="exercise-head">
                  {photo ? <img className="exercise-thumb" src={photo} alt="" /> : null}
                  <h3>{exerciseName(item.exercise) || 'Exercise'}</h3>
                  <span className="pill">{item.completed ? 'Done' : 'Open'}</span>
                  {item.personalRecord ? <span className="pill">PR</span> : null}
                </header>
                <p className="muted" style={{ margin: '0 0 0.75rem' }}>
                  Sets {vs(item.actualSets, item.plannedSets)}
                  {timed
                    ? ` · Time ${formatSeconds(item.actualDuration)} / ${formatSeconds(item.plannedDuration)}`
                    : ` · Reps ${vs(item.actualRepetitions, item.plannedRepetitions)}`}
                  {` · Effort ${effortLabel(item.effort)}`}
                </p>
                {item.notes ? <p style={{ marginTop: 0 }}>{item.notes}</p> : null}
                {sets.length > 0 && (
                  <table className="table set-table">
                    <thead>
                      <tr>
                        <th>Set</th>
                        <th>{timed ? 'Seconds' : 'Reps'}</th>
                        <th>kg</th>
                        <th>Done</th>
                      </tr>
                    </thead>
                    <tbody>
                      {sets.map((set) => (
                        <tr key={set.id ?? set.clientId}>
                          <td>{set.setNumber}</td>
                          <td>
                            {timed
                              ? `${formatSeconds(set.actualDuration)} / ${formatSeconds(set.plannedDuration)}`
                              : vs(set.actualReps, set.plannedReps)}
                          </td>
                          <td>{vs(set.actualLoadKg, set.plannedLoadKg)}</td>
                          <td>{set.completed ? 'Yes' : 'No'}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}
              </article>
            )
          })}
        </div>
      )}
    </>
  )
}
