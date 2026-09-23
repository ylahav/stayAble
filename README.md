# StayAble

Keep your body able — for life. A training app for **home and gym**. Built with Flutter for Android, iOS, Windows, and macOS. A trainer assigns a program; the person who trains follows it in the app.

Hebrew name on the device: **יכולת**.

You can browse exercises, follow one or more assigned programs, run an interactive workout (timers, reps, load, rest), and review what you actually did — separate from what was planned.

Product spec: [docs/Workout App — MRD.md](docs/Workout%20App%20%E2%80%94%20MRD.md)

## Features

- **Home** — today’s session (or rest day), week stats, and resume for an in-progress workout
- **Exercises** — searchable library with categories, photos, bilingual instructions
- **Program** — assigned programs (home, gym, or mixed). Tap an exercise for description and how-to
- **Live workout** — timers, reps, load (type or +/−), rest, effort. **Home** stays in list order. **Gym / mixed** — pick the next remaining exercise; finished ones stay on the list but cannot be started again. Back returns to that list without ending the session; **End workout** saves a partial
- **History** — completed and partial sessions; tap to continue a started or partial workout
- **Hebrew and English** with RTL when Hebrew is selected (עב / EN on every screen)
- **Version** — footer reads `version:` from `pubspec.yaml`

Planned vs actual stays separate: **Exercise → Program (template) → Assignment (who / when) → Workout session → Results**.

The in-app role for the person who trains is **athlete** (data model). The product is everyday exercise at your age and level, not competitive sport.

## Run

Requires [Flutter](https://docs.flutter.dev/get-started/install) 3.47+ (Dart 3.13).

The app opens on **Log in**. Set **Backend site** to your Payload origin (local: `http://localhost:3000`). Only accounts with the **athlete** role can continue. Finished workouts are stored on that site.

```bash
flutter pub get
flutter run -d windows
```

App version in the UI comes from `pubspec.yaml` (`version: 1.0.1` or `1.0.1+4`). After changing it, do a full restart (not only hot reload) so the bundled file updates.

Phone APK (arm64; copy via USB or Drive, not a messenger):

```bash
flutter build apk --release --target-platform android-arm64 --dart-define=PAYLOAD_URL=https://gym.yourdomain.com
```

Install `build/app/outputs/flutter-apk/app-release.apk`. Keep the `+N` in `version:` higher than any build already on the device.

Production deploy (Payload host + app URL): [docs/Deployment.md](docs/Deployment.md).

```bash
flutter test
flutter gen-l10n                 # after editing lib/l10n/*.arb
dart run build_runner build      # after changing Drift tables
```

## Architecture

```
lib/
  domain/          entities and repository interfaces
  data/            Drift database, mappers, seed, Payload sync
  presentation/    screens and Riverpod notifiers
  core/            theme, router, shared widgets
  l10n/            English and Hebrew strings
```

State: **Riverpod**. Navigation: **go_router**. Storage: local **Drift / SQLite** (UI always reads this). Remote API and trainer dashboard: **Payload CMS** in [`backend/`](backend/README.md) — see the [MRD](docs/Workout%20App%20%E2%80%94%20MRD.md) (§4, §5, §14, §18).

## Backend (Payload)

Login, trainer dashboard, admin, and session sync live in [`backend/`](backend/README.md). Flutter still works offline after the catalog has been pulled.

```bash
cd backend
cp .env.example .env
pnpm install
pnpm dev
```

Admin can **edit or delete a program after it has been trained**. Past sessions keep what was logged. Delete removes assignments; session history stays.

## License

Source: [ylahav/stayAble](https://github.com/ylahav/stayAble).
