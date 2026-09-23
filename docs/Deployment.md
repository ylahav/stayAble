# Deploy StayAble

Two pieces: the **Payload site** (`backend/`) on your existing host, and the **Flutter app** pointing at that site.

Never put `PAYLOAD_SECRET` in the Flutter app. Athletes log in with email/password; the app stores the JWT in the platform keychain / encrypted storage.

## 1. Payload site

Use a **new hostname** (recommended: `gym.yourdomain.com`) or a path such as `/gym`. Use the Mongo process you already run, with a **dedicated database** named `stayable`. Do not reuse a marketing CMS database.

### Environment

Copy `backend/.env.example` to `backend/.env` on the server and set:

| Variable | Production value |
|---|---|
| `DATABASE_URI` | `mongodb://127.0.0.1:27017/stayable` (or your Mongo URL + auth) |
| `PAYLOAD_SECRET` | long random string |
| `PAYLOAD_ADMIN_EMAIL` | first admin, created on first boot if missing |
| `PAYLOAD_ADMIN_PASSWORD` | strong password |
| `PROGRAM_OWNER_EMAIL` | athlete who owns the seeded 20-minute program |
| `NEXT_PUBLIC_SERVER_URL` | public origin, e.g. `https://gym.yourdomain.com` (**https**, no trailing slash). Must match the URL in the browser. Rebuild after changing this. |
| `PAYLOAD_CORS` | extra browser origins, comma-separated. The public URL above is always included. |

Native Android / iOS / Windows apps do **not** need CORS. Browsers do.

### Build and run

Needs Node 20+ and pnpm 11+. Same process-manager pattern as your other Payload apps (systemd, pm2, etc.).

```bash
cd backend
pnpm install --frozen-lockfile
pnpm build
pnpm start
```

`pnpm start` listens on port **3000**. Put HTTPS in front with the reverse proxy you already use (Caddy, nginx, Traefik). Forward to `127.0.0.1:3000`. Persist:

- `backend/.env`
- `backend/media/` (exercise photos)

### PM2

Do **not** run `pm2 start pnpm --name "gym" -- pnpm start`. PM2 treats `pnpm` as a file and looks for `ecosystem.config.js`.

The config file must exist **on the server**. Pull or copy it, then start from the **repo root** (the folder that contains `backend/`):

```bash
cd /path/to/stayAble
ls ecosystem.config.cjs backend/package.json
pnpm --dir backend build
pm2 start ecosystem.config.cjs
pm2 save
```

If that file is not on the server yet, start Next directly from `backend/` (no ecosystem file needed):

```bash
cd /path/to/stayAble/backend
pm2 start ./node_modules/next/dist/bin/next --name gym --interpreter node -- start --port 3000
pm2 save
```

Useful later:

```bash
pm2 restart gym
pm2 logs gym
pm2 status
```

If the site must use another port, edit `args` in `ecosystem.config.cjs` (`start --port 3001`) and point the proxy there.

First boot seeds exercises, the 20-minute program, and (if that email exists) a sample completed session.

### Check

- `https://gym.yourdomain.com/` — intro
- `https://gym.yourdomain.com/login` — shared login
- `https://gym.yourdomain.com/admin` — admin role only
- `POST https://gym.yourdomain.com/api/users/login` with `{ "email", "password" }` returns a `token`

Promote a trainer in Admin: add role `trainer`. They use `/dashboard` (invite, assign, program list with Edit / Delete, recent sessions).

### Admin login fails after deploy

`/admin` is **admin role only**. `/login` is the shared site login (athletes/trainers).

1. **`NEXT_PUBLIC_SERVER_URL` must be the HTTPS origin you actually open**  
   Example: `https://gym.yourdomain.com` — not `http://localhost:3000`, not a trailing slash, not `www` if the cert is on the apex (or the reverse).  
   Then **rebuild** (`pnpm build`) and restart. `NEXT_PUBLIC_*` is baked in at build time.

2. **`PAYLOAD_CORS` must include that same origin** (or rely on the config, which now always adds `NEXT_PUBLIC_SERVER_URL`):
   ```env
   NEXT_PUBLIC_SERVER_URL=https://gym.yourdomain.com
   PAYLOAD_CORS=https://gym.yourdomain.com,http://localhost:3000
   ```

3. **The account needs role `admin`.**  
   Set `PAYLOAD_ADMIN_EMAIL` to that user’s email and restart once. First boot creates the user; later boots grant `admin` if it is missing.  
   The account in `PAYLOAD_ADMIN_EMAIL` can use `/admin` only after that role is on the user.

4. **Proxy must pass HTTPS through to Node.** Forward `Host` and `X-Forwarded-Proto` (Caddy/nginx usually do). If cookies are `Secure` but you open `http://`, login will bounce.

5. Keep `PAYLOAD_SECRET` stable. Changing it invalidates all sessions.

Quick check from the server:

```bash
curl -sS -X POST https://gym.yourdomain.com/api/users/login \
  -H "Content-Type: application/json" \
  -d '{"email":"you@example.com","password":"..."}'
```

A JSON `token` + `user.roles` including `"admin"` means credentials are fine and the remaining issue is cookies/CSRF/`serverURL`. No token means wrong email/password or the user is in a different Mongo database.

## 2. Flutter app

The UI always reads local Drift. After login, finished workouts are **pushed** to `{backend}/api/workout-sessions`.

The in-app version label is `pubspec.yaml` `version:` (for example `1.0.1` or `1.0.1+4`). Restart the app after changing it.

### Point the app at the site

1. Open the app.
2. On **Log in**, set **Backend site** to the public origin (`https://gym.yourdomain.com`) — no trailing slash.
3. Sign in as an **athlete**.
4. Later: Home → settings gear → change the address if the host moves.

The address is stored on the device. Changing it signs you out so the next login hits the new site.

Local defaults (only if you leave the field empty): Windows/macOS `http://localhost:3000`, Android emulator `http://10.0.2.2:3000`.

### Sideload an APK (phone)

Build a **phone** APK (arm64), not the 3-ABI universal file. Copy it with USB or Drive — messengers often truncate a 100MB+ file and the phone then says the APK is invalid.

```bash
flutter build apk --release --target-platform android-arm64 --dart-define=PAYLOAD_URL=https://gym.yourdomain.com
```

Install `build/app/outputs/flutter-apk/app-release.apk`.

`pubspec.yaml` must use `version: x.y.z+N` with **N higher than any build already on the phone**. A lower or missing `+N` is a downgrade; many phones report that as an invalid package. Uninstall the old app first if you are unsure.

### Optional compile-time default

```bash
flutter run --dart-define=PAYLOAD_URL=https://gym.yourdomain.com
```

The in-app field still overrides this after the user saves.

Use **HTTPS** in production. Release Android builds block cleartext HTTP; debug/profile builds still allow it for LAN testing. iOS local networking is enabled for localhost only.

### What gets stored remotely

- Login / current user
- Workout sessions (planned vs actual sets, reps, duration, effort) when a workout is finished or saved as partial
- Existing local history is uploaded after a successful login

## 3. Typical first production pass

1. Create Mongo database `stayable`.
2. Deploy `backend/` behind HTTPS with the env table above.
3. Log in on the web as the athlete (or create the account).
4. Install / run Flutter, enter the site URL, log in as that athlete.
5. Finish a workout in the app; confirm it on `/programs` and in Admin → Workout sessions.
