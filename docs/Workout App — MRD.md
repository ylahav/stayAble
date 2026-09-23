# Workout App — MRD

**Product:** StayAble (Hebrew: יכולת)  
**Version:** 0.5  
**Date:** 11 September 2026  
**Platform:** Mobile + Desktop + web (Payload site)  
**Target framework:** Flutter (athlete app) + Next/Payload (accounts, trainer dashboard, admin)  
**Status:** Local app in use; Payload site is login, trainer dashboard, athlete performance, and admin

---

## 1. Project Overview

The application is a workout/training application that allows people to:

1. Browse a library of exercises.
2. Have a personalized training program (home, gym, or mixed).
3. Follow daily or weekly workouts.
4. Record what they actually accomplished.
5. Review their workout history and progress.
6. Use the **same account on phone and desktop**, with data kept in sync.
7. Work as an **athlete**, a **trainer**, or both. (Role name in data; the product is everyday exercise, not competitive sport.)

The application supports **home (often no equipment)** and **gym / mixed** programs. Equipment is already on the exercise entity.

Local-first remains mandatory: workouts must work offline. Remote storage is the shared source of truth **between devices and between trainer and athlete**, not a replacement for the on-device database.

**Chosen remote platform (see §18):** a dedicated [Payload CMS](https://payloadcms.com) app on the existing self-hosted stack (Mongo + reverse proxy), with Drift/SQLite as the offline cache. The Payload **website** is the shared login and the trainer/athlete/admin web surfaces. Athletes still train in Flutter; the web `/programs` page is performance, not the live workout player.

---

# 2. Main Concepts

The application is based on these primary entities:

```text
Account (auth identity)
    │
    └── User profile
            │
            ├── roles: athlete and/or trainer
            ├── Program assignments
            └── Workout Sessions
                     └── Workout Result

Exercise
    │
    ├── Program (owned by a user, often a trainer)
    │      └── flat list of exercises
    └── used in Workout Session results

Trainer ↔ Athlete (coaching relationship)
    │
    ├── assigned programs (schedule + optional refinements)
    └── dashboard (read athlete sessions/results)
```

### Planned vs. Actual

A fundamental distinction must be maintained:

**Program + assignment = what the user is supposed to do** (template, schedule, optional refinements)

**Workout Session / Result = what the user actually did**

Example:

```text
PROGRAM

Squat
2 sets × 12 repetitions


ACTUAL

Squat
Set 1 → 12 repetitions
Set 2 → 10 repetitions
```

---

# 3. Exercise Library

## 3.1 Purpose

The exercise library contains all exercises that can be used in training programs.

Each exercise should have a photo and detailed instructions.

## 3.2 Exercise Entity

```text
Exercise
├── id
├── name
├── description
├── instructions
├── photo
├── category
├── difficulty
├── duration
├── repetitions
├── targetMuscles
├── equipment
├── venue            home | gym | both
├── gymNumber        optional station number
├── active
├── createdAt
└── updatedAt
```

## 3.3 Exercise Categories

Initial categories:

- Warm-up
- Mobility
- Strength
- Cardio
- Stretching
- Cool-down

The category system should be extensible.

## 3.4 Difficulty

Initial values:

```text
beginner
intermediate
advanced
```

## 3.5 Equipment

Each exercise has an equipment kind. Home programs often use `none`; gym / mixed programs use machines, cables, and so on.

```text
none
mat
resistanceBand
dumbbells
chair
machine
barbell
cable
kettlebell
bench
```

## 3.6 Exercise Display

The exercise detail screen should contain:

- Exercise photo
- Exercise name
- Description
- How to perform
- Difficulty
- Target muscles
- Duration / repetitions
- Equipment
- Safety notes
- Optional video in the future

Example:

```text
┌─────────────────────────────┐
│                             │
│        EXERCISE PHOTO       │
│                             │
└─────────────────────────────┘

SQUAT
סקווט

Difficulty: Beginner

How to perform

1. Stand with feet approximately
   shoulder-width apart.
2. Push the hips backwards.
3. Bend the knees.
4. Return to standing.

Target muscles:
Quadriceps, Glutes, Hamstrings

Equipment:
None
```

---

# 4. Users, Accounts, and Roles

## 4.1 Purpose

A person signs in with one **account** and may use that account on several devices. Each account has a **profile**. The same person may train (athlete) and also coach others (trainer). Authentication is required so data can leave the device safely.

## 4.2 Account vs profile

```text
Account                          User profile
├── authUserId (Payload users)   ├── id  (= authUserId)
├── email                        ├── name
├── emailVerified                ├── photo
└── lastSignInAt                 ├── birthDate
                                 ├── gender
                                 ├── fitnessLevel
                                 ├── goals
                                 ├── language
                                 ├── roles[]          athlete, trainer
                                 ├── active
                                 ├── createdAt
                                 └── updatedAt
```

Email lives on the account (Auth). The profile holds workout-facing fields. Do not keep a second password in the app database.

## 4.3 User Entity

```text
User
├── id
├── name
├── email
├── photo
├── birthDate
├── gender
├── fitnessLevel
├── goals
├── language
├── roles
├── active
├── createdAt
└── updatedAt
```

## 4.4 Fitness Level

```text
beginner
intermediate
advanced
```

## 4.5 Goals

Initial goals:

- General fitness
- Strength
- Mobility
- Cardio
- Weight management

The system should support multiple goals per user.

## 4.6 Language

The application supports localization. **עב / EN** is available on every Flutter screen (including workout, exercise details, and program preview). Hebrew uses RTL.

Initial languages:

```text
Hebrew
English
```

## 4.7 Roles

Roles are not mutually exclusive. A trainer who also follows a program is both.

| Role | Meaning |
|------|---------|
| **athlete** | Follows assigned or self-made programs; logs sessions; sees own history and athlete dashboard. Default for new accounts. |
| **trainer** | Manages a roster of athletes; creates/assigns programs; sees a trainer dashboard over those athletes. Opt-in (upgrade in profile or invite). |

Platform operator (app owner) is out of band for now; not a product role in the client.

### Permissions

```text
                         Athlete     Trainer (on linked athletes)
Exercise library (read)     ✓              ✓
Own sessions (CRUD)         ✓              —
Other athlete sessions      —              read
Create own program          ✓              ✓
Assign program to self      ✓              ✓
Assign program to client    —              ✓
Invite / unlink client      —              ✓
Edit global exercise catalog (seeded)  —   —  (later: trainer-owned extras)
```

Athletes never see another athlete’s results unless they are the trainer in an **active** coaching relationship.

## 4.8 Coaching relationship

```text
TrainerClient
├── id
├── trainerId
├── athleteId
├── status          invited | active | declined | ended
├── invitedAt
├── acceptedAt
└── endedAt
```

Invite flow: trainer sends email or in-app invite → athlete accepts → `active`. Either party may end the link. Ending does not delete historical sessions; the trainer loses **new** read access.

## 4.9 Devices

```text
Device
├── id
├── userId
├── platform        android | ios | windows | macos | web
├── displayName
├── lastSeenAt
└── lastSyncAt
```

Used for “in progress on Phone” and conflict hints, not as a security boundary. Auth tokens are the security boundary.

An in-progress `WorkoutSession` should record `activeDeviceId`. Another device of the same user may **resume** it (take over) after a short warning, rather than forking two live sessions for the same program day.

---

# 5. Training Programs

## 5.1 Purpose

A training program is a **reusable list of exercises** (home, gym, or mixed). It is not tied to an athlete or a calendar.

When they train is set on the **assignment**.

## 5.2 Program Entity

A program is **owned** by whoever created it (`owner`). Ownership is not the same as “who follows it”.

```text
TrainingProgram
├── id
├── ownerUserId
├── name
├── description
├── venue          home | gym | mixed
├── active
├── exercises[]    sets, reps, duration, load, rest
├── createdAt
└── updatedAt
```

Admin may **edit or delete a program after it has been executed**. Past sessions keep logged sets. Delete removes assignments; session history stays.

## 5.2.1 Program assignment

```text
ProgramAssignment
├── id
├── programId
├── athleteId
├── assignedByUserId
├── scheduleType     daily | weekly | custom
├── scheduleDays[]
├── refinements[]    optional per-exercise overrides
├── startDate
├── endDate
├── active
├── createdAt
└── updatedAt
```

- Self-serve: athlete owns the program and has one assignment to themselves.
- Trainer-managed: trainer owns the program and assigns it to one or more athletes.
- An athlete may have **more than one active assignment** (for example home and gym at the same time).

Copy-on-assign is allowed later if a trainer needs to customize per athlete without changing the template. Refinements on the assignment cover per-person sets/reps/duration/load without copying the program.

## 5.3 Schedule Types

Initial options:

```text
daily
weekly
custom
```

## 5.4 Program Day (local)

The Flutter app **synthesizes** program days from the assignment schedule × the program exercise list. Payload does not store a day split on the program template.

```text
ProgramDay (local)
├── id
├── programId
├── date
├── weekday
├── title
└── description
```

For a repeating weekly assignment:

```text
Monday
Wednesday
Friday
```

---

# 6. Program Exercise

The same exercise may be used differently in different programs.

Therefore, default exercise settings belong to the **program**. Per-athlete overrides belong to the **assignment** (`refinements`).

```text
ProgramExercise
├── id
├── programDayId     local synthesized day
├── exerciseId
├── order
├── sets
├── repetitions
├── duration
├── loadKg
├── rest
└── notes
```

Example:

```text
Program:

Squat
2 sets
12 repetitions
30 sec rest
```

Another program may contain:

```text
Squat
3 sets
15 repetitions
45 sec rest
```

Both reference the same `Exercise`.

---

# 7. Actual Workout / Achievement

## 7.1 Purpose

The application must record what the user actually accomplished.

The preferred terminology is:

**Workout Session**

rather than simply "Achievement".

## 7.2 Workout Session

```text
WorkoutSession
├── id
├── userId
├── programDayId
├── startedAt
├── completedAt
├── duration
├── status
├── notes
├── activeDeviceId
├── updatedAt
└── exercises
```

## 7.3 Workout Status

```text
planned
started
completed
partiallyCompleted
skipped
cancelled
```

---

# 8. Workout Result

Each exercise performed during a workout gets its own result.

```text
WorkoutExerciseResult
├── id
├── workoutSessionId
├── exerciseId
├── plannedSets
├── actualSets
├── plannedRepetitions
├── actualRepetitions
├── plannedDuration
├── actualDuration
├── completed
└── notes
```

Example:

```text
Planned:

Squat
2 × 12


Actual:

Set 1 → 12
Set 2 → 10

Completed: Yes
```

---

# 9. Main User Screens

## 9.1 Home

The home screen should immediately show what the user needs to do today. Language toggle (עב / EN) is on this screen and on every other Flutter screen.

```text
HOME

Good morning

Today's workout

Full Body
20 minutes

8 exercises

[ START WORKOUT ]

-----------------------

This week

3 workouts
61 minutes
92% completion
```

---

## 9.2 Exercise Library

```text
EXERCISES

[ Search ]

Categories:

All
Mobility
Strength
Cardio
Stretching
Cool-down

┌────────────┐
│   PHOTO    │
│            │
└────────────┘
Squat
Strength
Beginner
```

---

## 9.3 Exercise Details

```text
PHOTO

Squat

Beginner

Description

How to perform

1. ...
2. ...
3. ...

Target muscles

Quadriceps
Glutes
Hamstrings

Equipment

None
```

---

# 10. Training Program Screen

An athlete may have more than one active assignment (for example a home program and a gym program). The screen lists them; each has its own schedule and exercise list.

```text
MY PROGRAM

Home — 20-Minute Full Body     Mon / Wed / Fri
Gym — Strength machines        Tue / Thu

-----------------------

Friday — Full Body (home)

1. Warm-up
2. Squat
3. Wall Push-up
4. Reverse Lunge
5. Glute Bridge
6. Cardio
7. Cool-down

[ START ]
```

---

# 11. Interactive Workout

The workout is interactive rather than a static list.

**Home** venue: exercises stay in list order.

**Gym / mixed** venue: order is not forced. The athlete picks a remaining exercise, completes it, and that exercise cannot be selected again. Back from an exercise returns to the day’s list and does **not** end the session. **End workout** saves a partial.

Reps and load can be typed on the keyboard or adjusted with +/−.

Example (home, sequential):

```text
FULL BODY

Exercise 2 / 8

SQUAT

        12 reps

        [ START ]

```

For timed exercises:

```text
MARCH IN PLACE

       00:24

████████████░░░░

       [ DONE ]
```

After completion:

```text
How did you do?

12 repetitions

○ Easy
● Good
○ Difficult

[ CONTINUE ]
```

---

# 12. Workout History

The user should be able to see previous workouts.

```text
HISTORY

28 Aug
Full Body
✓ Completed
20 minutes

26 Aug
Mobility
✓ Completed
15 minutes

24 Aug
Full Body
80% completed
18 minutes
```

---

# 13. Progress

The application provides week and month stats on Home. Richer progress (personal records, trends) can come later.

```text
MY PROGRESS

This week

Workouts       3
Workout time   61 min
Exercises      18
Completion     92%

This month

Workouts       12
Total time     4h 05m
```

Future statistics may include:

- Workout frequency
- Completion rate
- Exercise frequency
- Training duration
- Personal records
- Progress over time

---

# 14. Trainer, Athlete, and Dashboards

Trainer and athlete are first-class. Dashboards sit on synced data. Athletes train in Flutter; trainers work on the Payload site (`/dashboard`). Admin may edit or delete a program after it has been trained.

```text
Trainer
  ├── roster (TrainerClient)
  ├── program templates (owned programs)
  ├── assign → ProgramAssignment (more than one may stay active)
  └── dashboard (roster, programs, sessions of linked athletes)

Athlete
  ├── own profile and devices
  ├── active assignment(s) (self or trainer; home and gym together is allowed)
  ├── workout sessions / results
  └── dashboard (own progress on /programs)
```

## 14.1 Trainer screens

### Roster

```text
CLIENTS                         [ Invite ]

Active  4    Invited  1

┌─────────────────────────────────────┐
│ Dana Cohen              This week 3/3│
│ Full Body · last session yesterday  │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│ Alex Levi               This week 1/3│
│ Full Body · missed Friday           │
└─────────────────────────────────────┘
```

Invite: email of an existing account, or a link that creates an athlete account.

### Client detail (trainer)

```text
DANA COHEN                    [ Unlink ]

Program: Full Body (Mon/Wed/Fri)
Assigned 12 Aug 2026

This week     3 workouts · 58 min · 96%
This month   11 workouts

Recent sessions
  Wed  Full Body   completed   19 min
  Mon  Full Body   completed   21 min
  Fri  Full Body   partial     12 min   ← tap for set-level results
```

Trainer may add or change assignments. More than one assignment may stay active (home and gym). Trainer does **not** log sets on behalf of the athlete (no proxy workout). Notes from the trainer on a session are a later addition.

### Assign program

```text
ASSIGN PROGRAM

Client: Alex Levi
Program: [ Full Body 20 min ▼ ]
Start:   [ 01 Sep 2026 ]

May stay active alongside other assignments (for example gym).
```

## 14.2 Dashboards

Dashboards are **read models** over sessions and assignments. They do not replace Home, Program, or History.

### Athlete dashboard

Extends today’s Home / Progress:

```text
MY DASHBOARD

Streak        4 weeks with ≥ 2 sessions
This week     2 / 3 planned   40 min
This month    8 sessions      2h 51m

Planned vs actual (this week)
  Squat          2×12 planned · 12, 10 actual
  Incline push-up  2×10 · completed

[ History ]
```

Phone: a tab or a section on Home. Desktop: wider layout, same data.

### Trainer dashboard

Default landing when `roles` includes trainer (toggle athlete/trainer mode in the app bar if both).

```text
TRAINER DASHBOARD          Week of 25 Aug

Roster            4 active
Trained today     2 / 4
At risk           1  (missed last 2 planned days)
Completion        78% of planned sessions this week

Needs attention
  Alex Levi   missed Friday · 1/3 this week

Who trained today
  Dana Cohen   Full Body   completed 19 min
  You          Full Body   completed 20 min
```

Desktop is the primary trainer surface (roster + tables). Phone must still show roster, one client, and the same week summary.

## 14.3 Roles on the web (shared login)

Roles can be combined on one account. One login on the Payload site; after sign-in the person only sees the surfaces their roles allow.

| Role | Web route | Job |
|------|-----------|-----|
| *(signed out)* | `/` | Intro to the site + **Log in** |
| all signed-in | `/login` | Shared email/password form |
| **admin** | `/admin` | Payload Admin (users, catalog, raw data) |
| **trainer** | `/dashboard` | Roster, invite, assign (multiple may stay active), edit/delete programs (admin delete), read sessions |
| **athlete** | `/programs` | Own assignments and performance (planned vs actual) |

```text
/  intro + [ Log in ]
        │
        ▼
/login  (shared)
        │
        ├── admin   → /admin
        ├── trainer → /dashboard
        └── athlete → /programs
```

If several roles are set, the header links to every allowed surface. Default landing: trainer → `/dashboard`, else athlete → `/programs`, else admin → `/admin`.

Flutter remains the place athletes **do** the workout. `/programs` does not replace the player.

## 14.4 Flutter mode switch

If the account has both athlete and trainer in the mobile/desktop app:

```text
App bar:  [ Athlete | Trainer ]
```

Athlete mode: Home / Exercises / Program / History.  
Trainer mode can later mirror `/dashboard`. Exercise library is shared.

---

# 15. MVP Scope

## 15.1 Phase 0 — local athlete loop (shipped)

Essential athlete loop. Sign-in and sync are in Phase 1.

### Exercises

- [x] Exercise list
- [x] Exercise photo
- [x] Exercise details
- [x] Categories
- [x] Difficulty

### Users

- [x] Language
- [ ] User profile (beyond language)
- [ ] Fitness level (stored, limited UI)
- [ ] Goals (stored, limited UI)

### Programs

- [x] Daily / weekly workout from assignment schedule × program list
- [x] Home, gym, and mixed venues
- [x] Exercises within a workout, sets, reps, duration, load, rest
- [ ] Create program in the Flutter app (trainers create in Admin / dashboard)
- [x] Assign program to another user (trainer dashboard)

### Workout

- [x] Start workout
- [x] Home: list order; gym / mixed: pick remaining exercises
- [x] Back from an exercise returns to the day’s list (does not end the session)
- [x] Timer
- [x] Repetition and load tracking (type or +/−)
- [x] Complete exercise / workout (including partial and resume)

### History

- [x] Completed workouts
- [x] Partial workouts
- [x] Workout duration
- [x] Exercise results

## 15.2 Phase 1 — accounts and device sync

- [x] Sign in (email) in Flutter and on the Payload site
- [x] Sign out
- [x] Same account on phone and desktop
- [x] Push/pull catalog, programs, assignments, sessions
- [x] Offline workout; sync when back online
- [ ] Session takeover if two devices open the same workout
- [x] Enable trainer / admin roles on an account (Admin)

## 15.3 Phase 2 — trainer roster and dashboards

- [x] Invite athlete / accept invite
- [x] Trainer dashboard: roster, invite, assign, recent sessions
- [x] Assign program to a client (multiple assignments may stay active)
- [x] Edit / delete a program after it has been trained (Admin; dashboard list)
- [x] Athlete performance on `/programs` (planned vs actual)
- [ ] Flutter athlete dashboard beyond Home week stats (streak, month, planned vs actual)
- [ ] Athlete | Trainer mode switch in Flutter
- [x] Desktop-usable trainer layout (`/dashboard`)

---

# 16. Future Features

Not in the current product, but the architecture should allow:

- Exercise videos
- Voice instructions
- Notifications and reminders
- Apple Health / Google Health Connect
- Wearable and heart-rate data
- AI-generated training programs
- Progress-based program adaptation
- Exercise substitutions
- Richer equipment filters (venue home / gym / mixed is already on the program)
- Exercise ratings / difficulty feedback
- Trainer notes on a session
- Per-athlete program copies (fork from template)
- Teams / gyms (many trainers, shared roster)
- Web client as a first-class athlete app (desktop Flutter is enough at first)

Trainer accounts, roster, dashboards, and cloud sync are in use (§4, §14, §18). Remaining items above are later work.

---

# 17. Technology

## Frontend

**Flutter**

Target platforms:

```text
Android
iOS
Windows
macOS
```

Web support may be added later.

## Architecture

The application should use a layered architecture:

```text
┌───────────────────────────────┐
│             UI                │
│        Flutter Widgets        │
├───────────────────────────────┤
│        Presentation           │
│       State Management        │
├───────────────────────────────┤
│          Domain               │
│     Business Rules / Models   │
├───────────────────────────────┤
│          Data                 │
│ Repository / Database / API   │
└───────────────────────────────┘
```

---

# 18. Data Storage and Sync

## 18.1 Local (required, already in use)

```text
SQLite / Drift
```

The repository layer hides the database. Workouts, timers, and history must work with **no network**.

## 18.2 Remote — decision

**Use a dedicated Payload CMS app** on the existing self-hosted host (same reverse proxy and Mongo **process**, **separate Mongo database** `stayable`). Do not merge collections into an existing marketing/CMS Payload.

| Piece | Product | Role |
|-------|---------|------|
| Database | **MongoDB** (`stayable`) | Users, coaching links, programs, assignments, sessions (sets nested) |
| Auth | **Payload auth** on `users` | Email/password; JWT for Flutter |
| Files | **Payload uploads** (optional) | Profile photos later; seeded exercise art stays in the app bundle |
| API | **Payload REST** `/api` | Flutter pull/push when online |
| Web | **Next pages on this Payload app** | `/` intro, `/login` shared, `/dashboard` trainer, `/programs` athlete, `/admin` admin only |

Implementation lives in this repo under `backend/`.

### Why Payload (not full self-hosted Supabase)

- The host already runs Payload + Mongo. A second Payload site is the same ops model (Node, env, TLS, backups).
- Full self-hosted Supabase is a second stack (Postgres + many containers, 4–8 GB RAM) next to Payload — not “sharing the host.”
- Auth, REST, access control, and an admin UI are included. Trainer roster and assignment can ship as Admin before Flutter trainer screens exist.
- Flutter uses HTTPS + `Authorization: JWT …` (desktop-safe). No privileged server key in the app.

### Alternatives considered

```text
Supabase Cloud Free
  Fine if we did not already operate a host. Pause-after-idle and a second
  vendor. Not needed while Payload is on the same box.

Self-hosted Supabase
  Correct SQL/RLS story; too heavy beside existing Payload + Mongo.

Firebase / Appwrite
  Extra platform; worse fit than a CMS we already run.
```

## 18.3 Architecture

```text
Same VPS / same proxy
├── existing Payload sites     (other Mongo DBs)
└── StayAble (backend/)         Mongo DB stayable
        ▲
        │ HTTPS + JWT
Flutter (Android / iOS / Windows / macOS)
        │
        └── Drift (SQLite)     ← UI always reads this
```

Sync direction:

```text
Online:   local changes queued → REST create/update → pull since updatedAt → apply to Drift
Offline:  queue writes locally; Admin freshness is “last sync”
Login:    pull profile, assignments, programs, sessions
Logout:   wipe local user data (keep bundled exercise seed)
```

## 18.4 What syncs

| Data | Sync | Notes |
|------|------|--------|
| Exercise catalog | Yes | Seeded ids such as `ex-squat`; new rows get an automatic `clientId` |
| User profile | Yes | Same person as Payload `users` |
| Programs + exercise list | Yes | Template only (no athlete, no schedule) |
| Program assignments | Yes | Schedule + optional refinements |
| Trainer–client links | Yes | |
| Workout sessions | Yes | Nested exercise results and sets in one document |
| UI language, local timers | No | Device-only |

Every synced document needs `clientId`, `updatedAt`, and `deleted` (soft delete) so pull can converge. **Admin does not edit `clientId`**; it is generated on create. Admin document titles use names (program / athlete, and so on), not `clientId`.

## 18.5 Access control (Payload)

Enforced in collection `access` functions (and Admin `admin` access). Not only in Dart.

```text
users:              self read/write; trainers read linked athletes
trainer-clients:    trainer or athlete on the row;
                    trainer creates invites; athlete sets status to active
programs:           owner full access; assigned athletes read
assignments:        athlete reads own; trainer of that athlete read/write
sessions:           athlete full access on own athlete field;
                    trainer read if active trainer-client
exercises:          authenticated read; trainer/admin write
Admin UI (/admin):  admin role only
/dashboard:         trainer role
/programs:          athlete role
```

## 18.6 Sync conflicts

- **Last write wins** on a document (`updatedAt`, then `clientId`).
- One live session per program day: `activeDeviceId` + takeover prompt.
- Trainer edits an assignment while the athlete is mid-workout: session stays on the program snapshot already started; new assignment applies to the **next** planned day.
- Trainer or admin **edits the program template** after sessions exist: live list updates on the next pull; existing sessions keep the exercises they started with.
- Admin **deletes a program**: assignments are removed; session history remains (program pointer cleared).

---

# 19. Internationalization

The application supports Hebrew and English. All user-visible strings are localized. **עב / EN** is on every Flutter screen; Hebrew uses RTL.

Example:

```text
English:
Start Workout

Hebrew:
התחל אימון
```

The data model should also support multilingual exercise content.

Example:

```text
Exercise
├── name
│   ├── en
│   └── he
│
├── description
│   ├── en
│   └── he
│
└── instructions
    ├── en
    └── he
```

The UI must correctly support **RTL** when Hebrew is selected.

---

# 20. Initial Data Example

The original 20-minute workout is a **flat program list** (`venue: home`) plus an **assignment** (who / which days). Flutter synthesizes “today’s day” from that.

```text
Program (20-Minute Home Workout, venue home)
├── March in Place              60 sec
├── Shoulder Rolls              60 sec
├── Cat-Cow                     60 sec
├── World's Greatest Stretch    60 sec
├── Squat                       2 × 12
├── Incline Push-up             2 × 10
├── Reverse Lunge               2 × 10
├── Glute Bridge                2 × 12
├── Plank                       2 × 30 sec
├── Cardio                      6 min
└── Cool-down                   2 min

Assignment
├── athlete + schedule (e.g. Mon / Wed / Fri)
└── optional refinements
```

---

# 21. Core Requirement

The most important design principle is:

> **The Exercise Library, Training Program, and Actual Workout History must be separate entities.**

This allows:

```text
Exercise
   ↓
can be used by many programs
   ↓
Program
   ↓
can be assigned to many users
   ↓
User performs program
   ↓
Workout Session
   ↓
Actual Results
```

This separation will make the application much easier to extend later.

Cloud and roles do not collapse these layers. A trainer assigns a **Program**; the athlete still produces **Workout Sessions** and **Results**.

---

# 22. MVP Success Criteria

The MVP is considered successful when a user can:

1. Open the application.
2. See today's workout.
3. View each exercise and its photo/instructions.
4. Start the workout.
5. Follow the exercises (home: list order; gym / mixed: pick remaining exercises).
6. Use timers where required.
7. Record repetitions/sets.
8. Finish the workout.
9. See what was actually completed.
10. Return later and view the workout history.

Phase 1 is successful when the same person can finish a workout on the phone, open the desktop app signed in, and see that session in History without re-entering it.

Phase 2 is successful when a trainer can invite an athlete, assign a program, and see on a dashboard whether that athlete completed this week’s planned sessions — without accessing athletes they do not coach.

---

# 23. Implementation notes

- Keep reading UI state from **Drift**. Payload is a sync adapter behind `StayAbleRepository`, not a second source of truth in widgets.
- New local columns/tables as needed: `roles`, `clientId` maps, `TrainerClient`, `ProgramAssignment`, `ownerUserId`, `activeDeviceId`, `deleted` / `updatedAt`.
- Flutter: `http` to `{PAYLOAD_URL}/api`, JWT from `POST /api/users/login`. Never ship a Payload secret in the app.
- Auth UI: sign-in / register / forgot password; Hebrew + English; RTL.
- Trainer Admin: `backend/` Payload Admin. Flutter trainer mode can come later on the same API.
- Flutter app version in the UI is read from `pubspec.yaml` (`version:`). Restart after changing it (not only hot reload).
- `clientId` is generated on create; Admin titles use names, not ids.
- Code: `backend/` in this repo. Deploy as its own site (`gym.` hostname or `/gym`), Mongo database `stayable`.
- Dashboard: invite, assign (multiple programs may stay active), edit/delete programs, recent sessions.

---

## Next Step

1. Remaining Phase 1/2: session takeover across devices; richer athlete dashboard in Flutter; trainer mode in the app if `/dashboard` is not enough.
2. Keep Admin and `/dashboard` as the place to create, assign, edit, and delete programs.