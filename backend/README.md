# StayAble API (Payload)

Remote backend for the Flutter app: **auth, REST, trainer dashboard, performance pages, and admin**.

People train in Flutter. This site is the shared login and the web surfaces. Deploy as its **own site** next to your other Payload apps — same Mongo **process**, **different database** (`stayable`).

Product rules: [docs/Workout App — MRD.md](../docs/Workout%20App%20%E2%80%94%20MRD.md) §18.

## Collections

| Slug | Purpose |
|------|---------|
| `users` | Auth. Roles: `athlete` (default), `trainer`, `admin` (combinable). Only **admin** opens `/admin` or creates accounts. No public sign-up. |
| `media` | Exercise photos (seeded from `assets/exercises`). Signed-in read only. |
| `exercises` | Catalog (seeded on boot). `image` points at `media`. |
| `programs` | Reusable exercise list (`venue`: home / gym / mixed). No athlete or schedule. |
| `program-assignments` | Who follows which program, when they train, optional per-exercise refinements. |
| `trainer-clients` | Invite / active / ended coaching link. |
| `workout-sessions` | Actual work. Nested exercise results and sets. |

`clientId` is a stable id for the Flutter app. **Admin does not type it** — it is set on create and then read-only. Seeded rows keep ids such as `ex-squat`. Nested slots (program exercises, schedule days, session sets) get an id the same way.

Admin list/edit titles use a readable **admin title** (exercise name; program / athlete; athlete / trainer; athlete / program / date), not the `clientId`.

Programs may be **edited or deleted after sessions exist**. Past sessions keep logged sets. Delete unlinks assignments and clears the program pointer on sessions, then removes the template.

Every synced document has `clientId`, `deleted`, and Payload `updatedAt`.

## Run locally

Needs Node 20+, [pnpm](https://pnpm.io) 11+, and Mongo. Settings live in `pnpm-workspace.yaml` (`allowBuilds`, `trustLockfile`).

```bash
cp .env.example .env
# set PAYLOAD_SECRET (required, 16+ random chars) and PAYLOAD_ADMIN_PASSWORD
docker compose up -d          # optional if Mongo is not already running
pnpm install
pnpm dev
```

- Home: http://localhost:3000/  
- Login (shared): http://localhost:3000/login  
- Trainer / admin dashboard: http://localhost:3000/dashboard  
- Athlete performance: http://localhost:3000/programs  
- Admin (admin role only): http://localhost:3000/admin  
- REST: `POST /api/users/login` then `Authorization: JWT <token>`  
- First boot creates `PAYLOAD_ADMIN_EMAIL` if that user does not exist.

Dashboard: invite, assign (home and gym can both stay active), **program list with Edit / Delete**, recent sessions.

## Flutter

```http
POST /api/users/login
{ "email": "...", "password": "..." }

GET /api/workout-sessions?where[updatedAt][greater_than]=...
Authorization: JWT <token>
```

Do not put `PAYLOAD_SECRET` in the app.

## Deploy on the existing host

Step-by-step: [../docs/Deployment.md](../docs/Deployment.md).

1. New site / hostname (recommended: `gym.yourdomain.com`) or a path behind the same proxy.
2. `DATABASE_URI` → existing Mongo, database name **`stayable`** (not the marketing CMS DB).
3. `NEXT_PUBLIC_SERVER_URL` and `PAYLOAD_CORS` → that public origin.
4. Persist `backend/media/` and `.env`. Same Node/process manager pattern you already use for Payload.
5. In the Flutter app, set **Backend site** to that origin, then log in as an athlete.

## Promote a trainer

In `/admin`, edit the user → add role `trainer`. They then use `/dashboard`, not Admin.
