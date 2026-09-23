# Docs

- [Workout App — MRD](Workout%20App%20%E2%80%94%20MRD.md) — requirements, data model, screens, roles, dashboards, and Payload sync
- [Deployment](Deployment.md) — Payload host + pointing the Flutter app at it
- [Backend (Payload)](../backend/README.md) — Mongo API, trainer dashboard, and admin
- Home workout PDFs in this folder — original routine and data-model notes

App overview and how to run: [../README.md](../README.md)

The product name is **StayAble** (Hebrew: **יכולת**). The Dart package, Mongo database, and most internal ids use `stayable`.

## Current product (as built)

- **Program** = reusable exercise list (home, gym, or mixed). No athlete, no calendar.
- **Assignment** = who follows it, when they train (daily / weekly / custom), optional prescription overrides. More than one assignment can be active (home and gym together).
- **Session** = what they actually did. Independent of later edits to the template.
- Gym / mixed sessions: pick remaining exercises in any order. Home sessions: list order. Back from an exercise returns to the day’s list; **End workout** saves a partial.
- Admin may edit or delete a program after sessions exist. Past sessions keep logged sets.
- Admin document titles use names (for example program / athlete), not `clientId`. New `clientId` values are generated automatically.
- Hebrew / English (עב / EN) on every Flutter screen. Version footer reads `pubspec.yaml`.
