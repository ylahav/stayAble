'use client'

import { useEffect, useId, useMemo, useRef, useState } from 'react'

import {
  formatScanDelta,
  formatScanValue,
  formatScanWhen,
  previousScan,
  SCAN_METRICS,
  scanDelta,
  scansForTrainee,
  type BodyScan,
} from '@/lib/bodyScan'

type Props = {
  scans: BodyScan[]
  previewCount?: number
  showTrainee?: boolean
  empty: string
}

export function BodyScanList({ scans, previewCount = 12, showTrainee = true, empty }: Props) {
  const [openId, setOpenId] = useState<string | null>(null)
  const rows = scans.slice(0, previewCount)
  const open = scans.find((scan) => scan.id === openId) ?? null
  const history = useMemo(
    () => (open ? scansForTrainee(scans, open.traineeId) : []),
    [open, scans],
  )

  return (
    <>
      <table className="table">
        <thead>
          <tr>
            {showTrainee ? <th>Trainee</th> : null}
            <th>When</th>
            <th>Weight</th>
            <th>Fat</th>
            <th>Muscle</th>
            <th>
              <span className="visually-hidden">Open</span>
            </th>
          </tr>
        </thead>
        <tbody>
          {rows.length === 0 && (
            <tr>
              <td colSpan={showTrainee ? 6 : 5} className="muted">
                {empty}
              </td>
            </tr>
          )}
          {rows.map((scan) => (
            <tr
              key={scan.id}
              className="row-open"
              tabIndex={0}
              role="button"
              aria-label={`Open scan from ${formatScanWhen(scan.measuredAt)}`}
              onClick={() => setOpenId(scan.id)}
              onKeyDown={(event) => {
                if (event.key === 'Enter' || event.key === ' ') {
                  event.preventDefault()
                  setOpenId(scan.id)
                }
              }}
            >
              {showTrainee ? <td>{scan.traineeName || scan.traineeId}</td> : null}
              <td>{formatScanWhen(scan.measuredAt)}</td>
              <td>{formatScanValue(scan.weightKg, ' kg')}</td>
              <td>{formatScanValue(scan.bodyFatPercent, ' %')}</td>
              <td>{formatScanValue(scan.muscleMassKg, ' kg')}</td>
              <td className="muted">Open</td>
            </tr>
          ))}
        </tbody>
      </table>
      {open ? (
        <BodyScanDialog scan={open} history={history} onClose={() => setOpenId(null)} />
      ) : null}
    </>
  )
}

function BodyScanDialog({
  scan,
  history,
  onClose,
}: {
  scan: BodyScan
  history: BodyScan[]
  onClose: () => void
}) {
  const dialog = useRef<HTMLDialogElement>(null)
  const compareLabel = useId()
  const others = history.filter((item) => item.id !== scan.id)
  const [compareId, setCompareId] = useState(
    () => previousScan(history, scan.id)?.id ?? others[0]?.id ?? '',
  )
  const compare = others.find((item) => item.id === compareId) ?? null

  useEffect(() => {
    const node = dialog.current
    if (!node) return
    if (!node.open) node.showModal()
    return () => {
      if (node.open) node.close()
    }
  }, [])

  return (
    <dialog
      ref={dialog}
      className="sheet"
      onClose={onClose}
      onClick={(event) => {
        if (event.target === dialog.current) onClose()
      }}
    >
      <div className="stack">
        <div className="page-head" style={{ marginBottom: 0 }}>
          <div>
            <h2 className="page-title" style={{ fontSize: '1.55rem' }}>
              {scan.traineeName || 'Trainee'}
            </h2>
            <p className="page-lead">
              {formatScanWhen(scan.measuredAt)}
              {scan.source === 'mytanita-pdf' ? ' · MyTanita' : ''}
              {scan.filename ? ` · ${scan.filename}` : ''}
            </p>
          </div>
          <button className="btn btn-ghost" type="button" onClick={onClose}>
            Close
          </button>
        </div>

        <div className="stat-row" style={{ marginBottom: 0 }}>
          <div className="stat">
            <b>{formatScanValue(scan.weightKg, ' kg')}</b>
            <span className="muted">Weight</span>
          </div>
          <div className="stat">
            <b>{formatScanValue(scan.bodyFatPercent, ' %')}</b>
            <span className="muted">Body fat</span>
          </div>
          <div className="stat">
            <b>{formatScanValue(scan.muscleMassKg, ' kg')}</b>
            <span className="muted">Muscle</span>
          </div>
          <div className="stat">
            <b>{formatScanValue(scan.bmi)}</b>
            <span className="muted">BMI</span>
          </div>
        </div>

        {others.length > 0 ? (
          <label htmlFor={compareLabel}>
            Compare with another scan for this trainee
            <select
              id={compareLabel}
              value={compareId}
              onChange={(event) => setCompareId(event.target.value)}
            >
              {others.map((item) => (
                <option key={item.id} value={item.id}>
                  {formatScanWhen(item.measuredAt)}
                  {item.weightKg != null ? ` · ${formatScanValue(item.weightKg, ' kg')}` : ''}
                </option>
              ))}
            </select>
          </label>
        ) : (
          <p className="muted" style={{ margin: 0 }}>
            This is the only stored scan for this trainee. Import another date to compare.
          </p>
        )}

        <table className="table">
          <thead>
            <tr>
              <th>Measure</th>
              <th>This scan</th>
              {compare ? <th>Other</th> : null}
              {compare ? <th>Change</th> : null}
            </tr>
          </thead>
          <tbody>
            {SCAN_METRICS.map((metric) => {
              const current = scan[metric.key]
              const other = compare ? compare[metric.key] : null
              const change = compare ? scanDelta(asNumber(current), asNumber(other)) : null
              if (current == null && other == null) return null
              return (
                <tr key={metric.key}>
                  <td>{metric.label}</td>
                  <td>{formatScanValue(asNumber(current), metric.suffix)}</td>
                  {compare ? <td>{formatScanValue(asNumber(other), metric.suffix)}</td> : null}
                  {compare ? (
                    <td className={change == null || change === 0 ? 'muted' : change > 0 ? 'delta-up' : 'delta-down'}>
                      {formatScanDelta(change, metric.suffix)}
                    </td>
                  ) : null}
                </tr>
              )
            })}
          </tbody>
        </table>

        <p className="muted" style={{ margin: 0 }}>
          {scan.heightCm != null ? `${scan.heightCm} cm` : 'Height not stored'}
          {scan.age != null ? ` · age ${scan.age}` : ''}
          {scan.sourceUserId ? ` · Tanita ${scan.sourceUserId}` : ''}
          {scan.bmrKj != null ? ` · ${scan.bmrKj} kJ` : ''}. Comparison uses StayAble
          history, not the graph printed on the PDF.
        </p>
      </div>
    </dialog>
  )
}

function asNumber(value: BodyScan[keyof BodyScan]): number | null {
  return typeof value === 'number' ? value : null
}
