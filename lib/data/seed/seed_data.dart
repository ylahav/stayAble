import 'package:drift/drift.dart';

import '../../domain/entities/enums.dart';
import '../../domain/entities/localized_text.dart';
import '../db/app_database.dart';

const localUserId = 'user-local';
const programId = 'program-20min';
const dayMonId = 'day-mon';
const dayWedId = 'day-wed';
const dayFriId = 'day-fri';

LocalizedText _t(String en, String he) => LocalizedText(en: en, he: he);

class SeedRunner {
  SeedRunner(this.db);

  final AppDatabase db;

  Future<void> runIfNeeded({String language = 'en'}) async {
    final existing = await db.select(db.users).get();
    if (existing.isEmpty) {
      await _seed(language: language);
    }
    await ensureExercises();
  }

  Future<void> ensureExercises() async {
    final now = DateTime.now();
    for (final exercise in _exercises(now)) {
      final id = exercise.id.value;
      final row = await (db.select(db.exercises)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (row == null) {
        await db.into(db.exercises).insert(exercise);
      } else {
        await (db.update(db.exercises)..where((t) => t.id.equals(id))).write(
          ExercisesCompanion(photo: exercise.photo),
        );
      }
    }
  }

  Future<void> _seed({required String language}) async {
    final now = DateTime.now();

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: localUserId,
            name: 'You',
            email: const Value('athlete@local'),
            fitnessLevel: FitnessLevel.beginner,
            goals: const [FitnessGoal.generalFitness, FitnessGoal.mobility],
            language: language,
            createdAt: now,
            updatedAt: now,
          ),
        );

    for (final exercise in _exercises(now)) {
      await db.into(db.exercises).insert(exercise);
    }

    await db.into(db.trainingPrograms).insert(
          TrainingProgramsCompanion.insert(
            id: programId,
            userId: localUserId,
            name: '20-Minute Home Workout',
            description: 'No-equipment full-body session, three days a week.',
            scheduleType: ScheduleType.weekly,
            createdAt: now,
            updatedAt: now,
          ),
        );

    const days = [
      (dayMonId, 1),
      (dayWedId, 3),
      (dayFriId, 5),
    ];
    for (final day in days) {
      await db.into(db.programDays).insert(
            ProgramDaysCompanion.insert(
              id: day.$1,
              programId: programId,
              weekday: Value(day.$2),
              title: _t('Full Body', 'גוף מלא'),
              description: _t(
                '20-minute home workout',
                'אימון בית של 20 דקות',
              ),
            ),
          );
      await _insertDayExercises(day.$1);
    }
  }

  Future<void> _insertDayExercises(String dayId) async {
    const plan = <_PlanRow>[
      _PlanRow('ex-march', 1, sets: 1, duration: 60, rest: 0),
      _PlanRow('ex-shoulder-rolls', 2, sets: 1, duration: 60, rest: 0),
      _PlanRow('ex-cat-cow', 3, sets: 1, duration: 60, rest: 0),
      _PlanRow('ex-worlds-stretch', 4, sets: 1, duration: 60, rest: 0),
      _PlanRow('ex-squat', 5, sets: 2, reps: 12, rest: 30),
      _PlanRow('ex-incline-pushup', 6, sets: 2, reps: 10, rest: 30),
      _PlanRow('ex-reverse-lunge', 7, sets: 2, reps: 10, rest: 30),
      _PlanRow('ex-glute-bridge', 8, sets: 2, reps: 12, rest: 30),
      _PlanRow('ex-plank', 9, sets: 2, duration: 30, rest: 30),
      _PlanRow('ex-cardio', 10, sets: 1, duration: 360, rest: 0),
      _PlanRow('ex-cooldown', 11, sets: 1, duration: 120, rest: 0),
    ];

    for (final row in plan) {
      await db.into(db.programExercises).insert(
            ProgramExercisesCompanion.insert(
              id: '$dayId-${row.exerciseId}',
              programDayId: dayId,
              exerciseId: row.exerciseId,
              sortOrder: row.order,
              sets: row.sets,
              repetitions: Value(row.reps),
              duration: Value(row.duration),
              rest: Value(row.rest),
            ),
          );
    }
  }
}

class _PlanRow {
  const _PlanRow(
    this.exerciseId,
    this.order, {
    required this.sets,
    this.reps,
    this.duration,
    required this.rest,
  });

  final String exerciseId;
  final int order;
  final int sets;
  final int? reps;
  final int? duration;
  final int rest;
}

List<ExercisesCompanion> _exercises(DateTime now) {
  ExercisesCompanion item({
    required String id,
    required LocalizedText name,
    required LocalizedText description,
    required LocalizedText instructions,
    required ExerciseCategory category,
    required Difficulty difficulty,
    int? duration,
    int? repetitions,
    required List<String> muscles,
    LocalizedText? safety,
    ExerciseVenue venue = ExerciseVenue.both,
    EquipmentKind equipment = EquipmentKind.none,
  }) {
    return ExercisesCompanion.insert(
      id: id,
      name: name,
      description: description,
      instructions: instructions,
      photo: 'assets/exercises/$id.png',
      category: category,
      difficulty: difficulty,
      duration: Value(duration),
      repetitions: Value(repetitions),
      targetMuscles: muscles,
      equipment: equipment,
      venue: Value(venue),
      safetyNotes: safety ??
          _t(
            'Move within a comfortable range. Stop if you feel sharp pain.',
            'הישארו בטווח נוח. עצרו אם מופיע כאב חד.',
          ),
      createdAt: now,
      updatedAt: now,
    );
  }

  return [
    item(
      id: 'ex-march',
      name: _t('March in Place', 'צעידה במקום'),
      description: _t(
        'Easy marching to raise heart rate and warm the joints.',
        'צעידה קלה להעלאת דופק וחימום המפרקים.',
      ),
      instructions: _t(
        '1. Stand tall with feet under the hips.\n'
        '2. Lift the knees alternately to about hip height.\n'
        '3. Swing the arms naturally.\n'
        '4. Keep a steady, easy pace for the full minute.',
        '1. עמדו זקוף, רגליים מתחת לירכיים.\n'
        '2. הרימו ברכיים לסירוגין עד גובה הירך בערך.\n'
        '3. נענעו את הידיים באופן טבעי.\n'
        '4. שמרו על קצב רגוע ויציב לאורך כל הדקה.',
      ),
      category: ExerciseCategory.warmUp,
      difficulty: Difficulty.beginner,
      duration: 60,
      muscles: const ['cardiovascular', 'hipFlexors', 'calves'],
    ),
    item(
      id: 'ex-shoulder-rolls',
      name: _t('Shoulder Rolls', 'סיבובי כתפיים'),
      description: _t(
        'Slow circles to open the shoulders and upper back.',
        'סיבובים איטיים לפתיחת הכתפיים והגב העליון.',
      ),
      instructions: _t(
        '1. Stand or sit tall.\n'
        '2. Lift the shoulders toward the ears.\n'
        '3. Roll them back and down.\n'
        '4. Reverse direction halfway through.',
        '1. עמדו או שבו זקוף.\n'
        '2. הרימו כתפיים לכיוון האוזניים.\n'
        '3. גלגלו לאחור ולמטה.\n'
        '4. החליפו כיוון באמצע הזמן.',
      ),
      category: ExerciseCategory.warmUp,
      difficulty: Difficulty.beginner,
      duration: 60,
      muscles: const ['shoulders', 'back'],
    ),
    item(
      id: 'ex-cat-cow',
      name: _t('Cat-Cow', 'חתול-פרה'),
      description: _t(
        'Spinal flexion and extension to wake up the back.',
        'כפיפה ויישור של עמוד השדרה להערת הגב.',
      ),
      instructions: _t(
        '1. Come to all fours, wrists under shoulders, knees under hips.\n'
        '2. Inhale, drop the belly, lift the chest (cow).\n'
        '3. Exhale, round the spine toward the ceiling (cat).\n'
        '4. Flow slowly with the breath.',
        '1. עמדו על שש, פרקי כף היד מתחת לכתפיים, ברכיים מתחת לירכיים.\n'
        '2. שאיפה: בטן למטה, חזה למעלה (פרה).\n'
        '3. נשיפה: גב מעוגל לתקרה (חתול).\n'
        '4. זרמו לאט עם הנשימה.',
      ),
      category: ExerciseCategory.mobility,
      difficulty: Difficulty.beginner,
      duration: 60,
      muscles: const ['back', 'core'],
      safety: _t(
        'Keep wrists comfortable. Pad the knees if needed.',
        'שמרו על פרקי כף היד נוחים. ריפדו את הברכיים אם צריך.',
      ),
    ),
    item(
      id: 'ex-worlds-stretch',
      name: _t("World's Greatest Stretch", 'המתיחה הגדולה'),
      description: _t(
        'A flowing lunge stretch for hips, hamstrings, and thoracic spine.',
        'מתיחת לאנג׳ זורמת לירכיים, המסטרינג וגב עליון.',
      ),
      instructions: _t(
        '1. Step into a long lunge, back knee lifted or down.\n'
        '2. Place the same-side hand inside the front foot.\n'
        '3. Rotate the chest open and reach the other arm up.\n'
        '4. Switch sides and repeat.',
        '1. צעדו ללאנג׳ ארוך, ברך אחורית מורמת או על הרצפה.\n'
        '2. הניחו את כף היד בצד הרגל הקדמית.\n'
        '3. סובבו את החזה ופתחו יד למעלה.\n'
        '4. החליפו צד וחזרו.',
      ),
      category: ExerciseCategory.mobility,
      difficulty: Difficulty.intermediate,
      duration: 60,
      muscles: const ['hipMobility', 'hamstrings', 'back'],
    ),
    item(
      id: 'ex-squat',
      name: _t('Squat', 'סקווט'),
      description: _t(
        'Sit the hips back and stand up to load the legs.',
        'דחיפת ירכיים לאחור ועמידה להפעלת הרגליים.',
      ),
      instructions: _t(
        '1. Stand with feet about shoulder-width apart.\n'
        '2. Push the hips backwards.\n'
        '3. Bend the knees and keep the chest lifted.\n'
        '4. Return to standing.',
        '1. עמדו עם רגליים ברוחב הכתפיים בערך.\n'
        '2. דחפו את הירכיים לאחור.\n'
        '3. כופפו ברכיים ושמרו על חזה מורם.\n'
        '4. חזרו לעמידה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      repetitions: 12,
      muscles: const ['quadriceps', 'glutes', 'hamstrings'],
    ),
    item(
      id: 'ex-incline-pushup',
      name: _t('Incline Push-up', 'שכיבות סמיכה בשיפוע'),
      description: _t(
        'Push-ups with hands on a chair, counter, or wall.',
        'שכיבות סמיכה עם ידיים על כיסא, משטח או קיר.',
      ),
      instructions: _t(
        '1. Place hands on a stable elevated surface.\n'
        '2. Walk the feet back into a straight line from head to heels.\n'
        '3. Bend the elbows and lower the chest toward the surface.\n'
        '4. Press back to the start.',
        '1. הניחו ידיים על משטח יציב וגבוה.\n'
        '2. צעדו רגליים אחורה לקו ישר מהראש לעקבים.\n'
        '3. כופפו מרפקים והורידו חזה לכיוון המשטח.\n'
        '4. לחצו חזרה להתחלה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      repetitions: 10,
      muscles: const ['chest', 'shoulders', 'core'],
      safety: _t(
        'Use a surface that will not slide. Keep the body in one line.',
        'השתמשו במשטח שאינו מחליק. שמרו על הגוף בקו אחד.',
      ),
    ),
    item(
      id: 'ex-reverse-lunge',
      name: _t('Reverse Lunge', 'לאנג׳ אחורה'),
      description: _t(
        'Step back into a lunge, then return. Alternate legs.',
        'צעד אחורה ללאנג׳ וחזרו. החליפו רגליים.',
      ),
      instructions: _t(
        '1. Stand tall.\n'
        '2. Step one foot back and lower the back knee toward the floor.\n'
        '3. Front knee stays stacked over the ankle.\n'
        '4. Push through the front foot to stand and switch sides.',
        '1. עמדו זקוף.\n'
        '2. צעדו רגל אחורה והורידו את הברך האחורית לכיוון הרצפה.\n'
        '3. הברך הקדמית נשארת מעל הקרסול.\n'
        '4. לחצו דרך הרגל הקדמית לעמידה והחליפו צד.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      repetitions: 10,
      muscles: const ['quadriceps', 'glutes', 'hamstrings'],
    ),
    item(
      id: 'ex-glute-bridge',
      name: _t('Glute Bridge', 'גשר ישבן'),
      description: _t(
        'Lie on the back and lift the hips by squeezing the glutes.',
        'שכבו על הגב והרימו אגן תוך כיווץ הישבן.',
      ),
      instructions: _t(
        '1. Lie on your back, knees bent, feet flat.\n'
        '2. Press through the heels and lift the hips.\n'
        '3. Squeeze the glutes at the top without arching the low back.\n'
        '4. Lower with control.',
        '1. שכבו על הגב, ברכיים כפופות, כפות רגליים על הרצפה.\n'
        '2. לחצו דרך העקבים והרימו את האגן.\n'
        '3. כווצו ישבן למעלה בלי לקשת את הגב התחתון.\n'
        '4. הורידו בשליטה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      repetitions: 12,
      muscles: const ['glutes', 'hamstrings', 'core'],
    ),
    item(
      id: 'ex-plank',
      name: _t('Plank', 'פלאנק'),
      description: _t(
        'Hold a straight body line on forearms or hands.',
        'החזיקו קו גוף ישר על אמות או ידיים.',
      ),
      instructions: _t(
        '1. Set elbows under shoulders (or hands for a high plank).\n'
        '2. Extend the legs and brace the core.\n'
        '3. Keep hips level — not sagging or piked.\n'
        '4. Breathe steadily for the hold.',
        '1. מרפקים מתחת לכתפיים (או ידיים לפלאנק גבוה).\n'
        '2. יישרו רגליים וכווצו ליבה.\n'
        '3. שמרו על אגן ישר — בלי לצנוח או להתרומם.\n'
        '4. נשמו באופן יציב לאורך האחיזה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      duration: 30,
      muscles: const ['core', 'shoulders'],
    ),
    item(
      id: 'ex-cardio',
      name: _t('Cardio', 'אירובי'),
      description: _t(
        'Six minutes of marching, step-touches, or easy jogging in place.',
        'שש דקות צעידה, צעדי צד או ריצה קלה במקום.',
      ),
      instructions: _t(
        '1. Choose a low-impact option if needed (march or step-touch).\n'
        '2. Keep moving for the full six minutes.\n'
        '3. You should be able to speak in short sentences.\n'
        '4. Slow down if you feel dizzy or unwell.',
        '1. בחרו אפשרות עצימה נמוכה אם צריך (צעידה או צעד-צד).\n'
        '2. המשיכו לנוע לאורך שש הדקות.\n'
        '3. אפשר לדבר במשפטים קצרים.\n'
        '4. האטו אם מופיע סחרחורת או הרגשה לא טובה.',
      ),
      category: ExerciseCategory.cardio,
      difficulty: Difficulty.beginner,
      duration: 360,
      muscles: const ['cardiovascular', 'fullBody'],
    ),
    item(
      id: 'ex-cooldown',
      name: _t('Cool-down', 'שחרור'),
      description: _t(
        'Easy breathing and light stretches to finish.',
        'נשימה קלה ומתיחות עדינות לסיום.',
      ),
      instructions: _t(
        '1. Walk slowly in place and let the breath settle.\n'
        '2. Stretch the hips, hamstrings, and chest without bouncing.\n'
        '3. Hold each stretch about 20 seconds.\n'
        '4. Finish standing tall.',
        '1. צעדו לאט במקום ותנו לנשימה להירגע.\n'
        '2. מתחו ירכיים, המסטרינג וחזה בלי קפיצות.\n'
        '3. החזיקו כל מתיחה כ־20 שניות.\n'
        '4. סיימו בעמידה זקופה.',
      ),
      category: ExerciseCategory.coolDown,
      difficulty: Difficulty.beginner,
      duration: 120,
      muscles: const ['fullBody'],
    ),
    item(
      id: 'ex-jumping-jacks',
      name: _t('Jumping Jacks', 'ג׳מפינג ג׳קס'),
      description: _t(
        'A classic full-body pulse raiser. Step-touch if jumping is too much.',
        'תרגיל קלאסי להעלאת דופק. אפשר צעד-צד במקום קפיצה.',
      ),
      instructions: _t(
        '1. Stand with feet together and arms by the sides.\n'
        '2. Jump the feet out and raise the arms overhead.\n'
        '3. Return to the start.\n'
        '4. Land softly, or step out instead of jumping.',
        '1. עמדו עם רגליים צמודות וידיים לצדדים.\n'
        '2. קפצו החוצה והרימו ידיים מעל הראש.\n'
        '3. חזרו להתחלה.\n'
        '4. נחתו ברכות, או צעדו החוצה במקום לקפוץ.',
      ),
      category: ExerciseCategory.cardio,
      difficulty: Difficulty.beginner,
      duration: 45,
      muscles: const ['cardiovascular', 'calves', 'shoulders'],
    ),
    item(
      id: 'ex-wall-sit',
      name: _t('Wall Sit', 'ישיבת קיר'),
      description: _t(
        'Hold a seated position against the wall to load the legs.',
        'החזיקו תנוחת ישיבה מול הקיר להפעלת הרגליים.',
      ),
      instructions: _t(
        '1. Stand with the back against a wall.\n'
        '2. Slide down until thighs are about parallel to the floor.\n'
        '3. Keep knees over the ankles.\n'
        '4. Hold, then stand up with control.',
        '1. עמדו עם הגב לקיר.\n'
        '2. החליקו למטה עד שהירכיים מקבילות לרצפה בערך.\n'
        '3. שמרו ברכיים מעל הקרסוליים.\n'
        '4. החזיקו, ואז עמדו בשליטה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      duration: 30,
      muscles: const ['quadriceps', 'glutes'],
    ),
    item(
      id: 'ex-dead-bug',
      name: _t('Dead Bug', 'חרק מת'),
      description: _t(
        'Opposite arm and leg reach while the low back stays on the floor.',
        'יד ורגל נגדיות נשלחות בזמן שהגב התחתון נשאר על הרצפה.',
      ),
      instructions: _t(
        '1. Lie on your back, arms up, knees over hips.\n'
        '2. Press the low back gently into the floor.\n'
        '3. Extend one leg and the opposite arm.\n'
        '4. Return and switch sides.',
        '1. שכבו על הגב, ידיים למעלה, ברכיים מעל הירכיים.\n'
        '2. לחצו קלות את הגב התחתון לרצפה.\n'
        '3. יישרו רגל אחת ואת היד הנגדית.\n'
        '4. חזרו והחליפו צד.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      repetitions: 8,
      muscles: const ['core'],
    ),
    item(
      id: 'ex-bird-dog',
      name: _t('Bird Dog', 'ציפור-כלב'),
      description: _t(
        'Balance on all fours while reaching opposite arm and leg.',
        'שיווי משקל על שש תוך שליחת יד ורגל נגדיות.',
      ),
      instructions: _t(
        '1. Come to all fours.\n'
        '2. Reach one arm forward and the opposite leg back.\n'
        '3. Keep the hips level.\n'
        '4. Return and switch.',
        '1. עמדו על שש.\n'
        '2. שלחו יד קדימה ואת הרגל הנגדית אחורה.\n'
        '3. שמרו על אגן ישר.\n'
        '4. חזרו והחליפו.',
      ),
      category: ExerciseCategory.mobility,
      difficulty: Difficulty.beginner,
      repetitions: 8,
      muscles: const ['core', 'back', 'glutes'],
    ),
    item(
      id: 'ex-side-plank',
      name: _t('Side Plank', 'פלאנק צד'),
      description: _t(
        'A side body hold for the obliques and shoulders.',
        'אחיזת צד לאלכסונים ולכתפיים.',
      ),
      instructions: _t(
        '1. Lie on one side, elbow under the shoulder.\n'
        '2. Lift the hips so the body is a straight line.\n'
        '3. Hold, then switch sides.\n'
        '4. Drop the bottom knee if you need an easier option.',
        '1. שכבו על הצד, מרפק מתחת לכתף.\n'
        '2. הרימו אגן לקו ישר.\n'
        '3. החזיקו, ואז החליפו צד.\n'
        '4. הורידו ברך תחתונה אם צריך הקלה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.intermediate,
      duration: 20,
      muscles: const ['core', 'shoulders'],
    ),
    item(
      id: 'ex-calf-raise',
      name: _t('Calf Raise', 'הרמת שוקיים'),
      description: _t(
        'Rise onto the balls of the feet, then lower slowly.',
        'עלו על כריות כפות הרגליים והורידו לאט.',
      ),
      instructions: _t(
        '1. Stand tall, optional light touch on a wall for balance.\n'
        '2. Rise onto the balls of both feet.\n'
        '3. Pause at the top.\n'
        '4. Lower with control.',
        '1. עמדו זקוף, אפשר מגע קל בקיר לשיווי משקל.\n'
        '2. עלו על כריות שתי הרגליים.\n'
        '3. עצרו למעלה.\n'
        '4. הורידו בשליטה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      repetitions: 15,
      muscles: const ['calves'],
    ),
    item(
      id: 'ex-kneeling-pushup',
      name: _t('Kneeling Push-up', 'שכיבות סמיכה על הברכיים'),
      description: _t(
        'A floor push-up with knees down to reduce load.',
        'שכיבת סמיכה על הרצפה עם ברכיים למטה להפחתת עומס.',
      ),
      instructions: _t(
        '1. Hands under shoulders, knees on the floor.\n'
        '2. Keep a straight line from head to knees.\n'
        '3. Lower the chest, then press up.\n'
        '4. Do not let the hips sag.',
        '1. ידיים מתחת לכתפיים, ברכיים על הרצפה.\n'
        '2. שמרו על קו ישר מהראש לברכיים.\n'
        '3. הורידו חזה ולחצו מעלה.\n'
        '4. אל תתנו לאגן לצנוח.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      repetitions: 10,
      muscles: const ['chest', 'shoulders', 'core'],
    ),
    item(
      id: 'ex-leg-extension',
      name: _t('Leg Extension', 'פשיטת ברך במכונה'),
      description: _t(
        'Machine knee extension for the quadriceps. Plan load: 28 kg, seat 3/3.',
        'פשיטת ברך במכונה לארבע-ראשי. משקל בתוכנית: 28 ק״ג, כיוונון 3/3.',
      ),
      instructions: _t(
        '1. Sit in the machine, back against the pad, chest tall.\n'
        '2. Align the knees with the machine pivot.\n'
        '3. Straighten the knees through a comfortable range.\n'
        '4. Lower slowly.\n'
        'Breathe: exhale on the extension, inhale on the way down.',
        '1. שב במכונה, יישר את הגב והצמד חזה לגב המושב.\n'
        '2. יישר ברכיים עד יישור מלא בטווח נוח.\n'
        '3. חזור לאט למצב ההתחלתי.\n'
        'נשימה: נושף ביישור, שואף בירידה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.gym,
      equipment: EquipmentKind.machine,
      repetitions: 10,
      muscles: const ['quadriceps'],
    ),
    item(
      id: 'ex-leg-press',
      name: _t('Leg Press', 'לחיצת רגליים במכונה'),
      description: _t(
        'Machine press for legs and glutes. Plan load: 45 kg.',
        'לחיצת רגליים במכונה לרגליים ולישבן. משקל בתוכנית: 45 ק״ג.',
      ),
      instructions: _t(
        '1. Sit with the back against the pad.\n'
        '2. Place feet high on the platform, about shoulder-width.\n'
        '3. Press until the knees are almost straight, without locking.\n'
        '4. Return slowly.\n'
        'Breathe: exhale on the press, inhale on the return.',
        '1. שב במכונה, גב צמוד למושב.\n'
        '2. הנח כפות רגליים בחלק העליון של הפלטפורמה ברוחב הכתפיים.\n'
        '3. דחוף את הפלטפורמה עד יישור כמעט מלא של הברכיים, בלי לנעול.\n'
        '4. חזור לאט.\n'
        'נשימה: נושף בדחיפה, שואף בחזרה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.gym,
      equipment: EquipmentKind.machine,
      repetitions: 10,
      muscles: const ['quadriceps', 'glutes'],
    ),
    item(
      id: 'ex-chest-press',
      name: _t('Chest Press / Pec Deck', 'לחיצת חזה / מכונת פרפר'),
      description: _t(
        'Chest press with dumbbells or pec-deck machine. Plan: 18 kg machine or 4–5 kg dumbbells.',
        'לחיצת חזה עם משקולות או מכונת פרפר. בתוכנית: 18 ק״ג במכונה או 4–5 ק״ג במשקולות.',
      ),
      instructions: _t(
        '1. Lie on the bench with feet planted, or sit in the pec deck.\n'
        '2. Hold the weights or handles at chest height.\n'
        '3. Press or bring the arms together over the chest.\n'
        '4. Return slowly.\n'
        'Breathe: inhale on the opening, exhale on the press.',
        '1. בשכיבה על ספסל, רגליים יציבות על הרצפה — או ישיבה במכונת פרפר.\n'
        '2. הרם משקולות מעל החזה, או אחוז בידיות.\n'
        '3. הורד באיטיות לרוחב החזה ודחוף חזרה, או קרב ידיים מול החזה.\n'
        'נשימה: שואף בפתיחה, נושף בסגירה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.gym,
      equipment: EquipmentKind.dumbbells,
      repetitions: 10,
      muscles: const ['chest'],
    ),
    item(
      id: 'ex-incline-chest-press',
      name: _t('Incline Chest Press', 'לחיצת חזה עליון במכונה'),
      description: _t(
        'Machine press on a positive incline for the upper chest. Use a low seat.',
        'לחיצת חזה במכונה בזווית חיובית לחזה העליון. כסא נמוך.',
      ),
      instructions: _t(
        '1. Sit on a roughly 30° incline so the handles are at chest height.\n'
        '2. Hold the handles at the chest.\n'
        '3. Press forward until the arms are almost straight.\n'
        '4. Return slowly with the back on the pad.\n'
        'Breathe: exhale on the press, inhale on the return.',
        '1. שב במכונה בזווית חיובית (כ-30 מעלות).\n'
        '2. אחוז בידיות בגובה החזה.\n'
        '3. דחוף קדימה עד יישור זרועות.\n'
        '4. חזור לאט.\n'
        'נשימה: נושף בדחיפה, שואף בחזרה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.gym,
      equipment: EquipmentKind.machine,
      repetitions: 10,
      muscles: const ['chest', 'shoulders'],
    ),
    item(
      id: 'ex-lat-pulldown',
      name: _t('Wide-Grip Lat Pulldown', 'חתירה אחיזה רחבה בפולי'),
      description: _t(
        'Cable pulldown with a wide grip for the lats. Plan load: 24 kg.',
        'משיכה בפולי באחיזה רחבה לגב הרחב. משקל בתוכנית: 24 ק״ג.',
      ),
      instructions: _t(
        '1. Hold the bar wider than the shoulders.\n'
        '2. Pull the bar down to the chest.\n'
        '3. Pause with the chest up.\n'
        '4. Return until the arms are straight.\n'
        'Breathe: exhale on the pull, inhale on the return.',
        '1. אחוז במוט רחב, כפות ידיים מעבר לכתפיים.\n'
        '2. משוך את המוט כלפי מטה לחזה.\n'
        '3. עצור עם חזה פתוח.\n'
        '4. חזור לאט ליישור זרועות.\n'
        'נשימה: נושף במשיכה, שואף בחזרה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.gym,
      equipment: EquipmentKind.cable,
      repetitions: 10,
      muscles: const ['back'],
    ),
    item(
      id: 'ex-seated-row',
      name: _t('Seated Row', 'חתירה אחיזה צרה במכונה'),
      description: _t(
        'Close-grip seated row for mid-back and shoulder blades. Plan load: 45 kg.',
        'חתירה בישיבה באחיזה צרה לגב אמצעי ולשכמות. משקל בתוכנית: 45 ק״ג.',
      ),
      instructions: _t(
        '1. Sit tall and hold the close handles.\n'
        '2. Pull them toward the belly, elbows close.\n'
        '3. Squeeze the shoulder blades together.\n'
        '4. Return slowly.\n'
        'Breathe: exhale on the pull, inhale on the return.',
        '1. שב זקוף, אחוז בידיות קרובות.\n'
        '2. משוך אותן לכיוון הבטן בצמוד לגוף.\n'
        '3. כווץ את השכמות יחד.\n'
        '4. חזור לאט.\n'
        'נשימה: נושף במשיכה, שואף בחזרה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.gym,
      equipment: EquipmentKind.machine,
      repetitions: 10,
      muscles: const ['back'],
    ),
    item(
      id: 'ex-bicep-curl',
      name: _t('Bicep Curl', 'כפיפת מרפק ליד קדמית'),
      description: _t(
        'Seated dumbbell curl for the biceps. Plan load: 4–5 kg.',
        'כפיפת מרפק בישיבה ליד הקדמית. משקל בתוכנית: 4–5 ק״ג.',
      ),
      instructions: _t(
        '1. Sit tall, holding dumbbells with elbows close to the body.\n'
        '2. Curl the weights toward the shoulders.\n'
        '3. Lower slowly without swinging.\n'
        'Breathe: exhale on the curl, inhale on the way down.',
        '1. שב זקוף, כפות ידיים אוחזות במשקולות.\n'
        '2. כופף מרפקים והבא את המשקולות לכיוון הכתפיים.\n'
        '3. הורד לאט בלי לנענע.\n'
        'נשימה: נושף בעלייה, שואף בירידה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.both,
      equipment: EquipmentKind.dumbbells,
      repetitions: 10,
      muscles: const ['shoulders'],
    ),
    item(
      id: 'ex-triceps-pushdown',
      name: _t('Triceps Pushdown', 'פשיטת מרפק ליד אחורית בפולי'),
      description: _t(
        'Cable pushdown for the triceps. Plan load: 24 kg.',
        'לחיצה מטה בפולי ליד האחורית. משקל בתוכנית: 24 ק״ג.',
      ),
      instructions: _t(
        '1. Stand tall and hold the handle or rope.\n'
        '2. Keep the elbows pinned to the sides.\n'
        '3. Push down until the elbows straighten, then squeeze.\n'
        '4. Return slowly.\n'
        'Breathe: exhale on the press, inhale on the return.',
        '1. עמוד זקוף, אחוז בידית או בחבל.\n'
        '2. משוך כלפי מטה עד יישור מרפקים.\n'
        '3. כווץ למטה.\n'
        '4. חזור לאט.\n'
        'נשימה: נושף בלחיצה, שואף בחזרה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.gym,
      equipment: EquipmentKind.cable,
      repetitions: 10,
      muscles: const ['shoulders'],
    ),
    item(
      id: 'ex-front-lateral-raise',
      name: _t('Front and Lateral Raise', 'הרמת ידיים קדימה וצידית'),
      description: _t(
        'Dumbbell raises to the front and to the side. Plan: 10+10 at 3 kg.',
        'הרמת ידיים קדימה ואז הצידה. בתוכנית: 10+10 עם 3 ק״ג.',
      ),
      instructions: _t(
        '1. Front raise: lift a straight arm forward to shoulder height.\n'
        '2. Lateral raise: lift the arm out to the side to shoulder height.\n'
        '3. Lower slowly. Do not swing.\n'
        'Breathe: exhale on the lift, inhale on the return.',
        '1. הרמה קדימה: הרם יד ישרה קדימה עד גובה הכתף.\n'
        '2. הרמה צידית: הרם יד הצידה עד גובה הכתף.\n'
        '3. הורד לאט.\n'
        'נשימה: נושף בהרמה, שואף בחזרה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.both,
      equipment: EquipmentKind.dumbbells,
      repetitions: 10,
      muscles: const ['shoulders'],
    ),
    item(
      id: 'ex-w-raise',
      name: _t('W Raise', 'כתף אחורית ושכמות — W'),
      description: _t(
        'Band or cable pull into a W for rear shoulders and shoulder blades. Light band.',
        'משיכה לאחור לצורת W לכתף אחורית ולשכמות. גומיה דקה.',
      ),
      instructions: _t(
        '1. Hold a light band or cable handles.\n'
        '2. Pull back and open the elbows into a W.\n'
        '3. Squeeze the shoulder blades.\n'
        '4. Return slowly.\n'
        'Breathe: exhale on the pull, inhale on the return.',
        '1. אחוז בגומייה או בידיות בפולי.\n'
        '2. משוך לאחור ופתח את המרפקים לצורת W.\n'
        '3. כווץ שכמות.\n'
        '4. חזור לאט.\n'
        'נשימה: נושף במשיכה, שואף בחזרה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.both,
      equipment: EquipmentKind.resistanceBand,
      repetitions: 10,
      muscles: const ['shoulders', 'back'],
    ),
    item(
      id: 'ex-external-rotation',
      name: _t('External Rotation', 'סיבוב חיצוני לשכמות'),
      description: _t(
        'Light-band external rotation for the rotator cuff. 8–10 slow reps.',
        'סיבוב חיצוני עם גומיה דקה למסובבי הכתף. 8–10 חזרות איטיות.',
      ),
      instructions: _t(
        '1. Hold a light band or cable.\n'
        '2. Bend the elbow to 90° and keep it against the side.\n'
        '3. Rotate the forearm outward.\n'
        '4. Return slowly.\n'
        'Breathe: exhale on the rotation, inhale on the return.',
        '1. אחוז בגומייה או בידית בפולי.\n'
        '2. כופף מרפק 90 מעלות והצמד לגוף.\n'
        '3. סובב את האמה החוצה.\n'
        '4. חזור לאט.\n'
        'נשימה: נושף בסיבוב, שואף בחזרה.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.both,
      equipment: EquipmentKind.resistanceBand,
      repetitions: 10,
      muscles: const ['shoulders'],
    ),
    item(
      id: 'ex-bosu-hold',
      name: _t('Bosu Hold', 'תרגיל בטן על בוסו'),
      description: _t(
        'A stable core hold on the bosu, 30–45 seconds.',
        'אחיזת ליבה על בוסו, 30–45 שניות.',
      ),
      instructions: _t(
        '1. Lie on the bosu with the low back supported.\n'
        '2. Keep the spine long and the belly active.\n'
        '3. Hold 30–45 seconds without rocking.',
        '1. שכיבה על בוסו בלבד, שמור על גב ישר ובטן פעילה.\n'
        '2. החזק 30–45 שניות בלי להתנדנד.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.gym,
      equipment: EquipmentKind.mat,
      duration: 45,
      muscles: const ['core'],
    ),
    item(
      id: 'ex-superman',
      name: _t('Superman', 'סופרמן'),
      description: _t(
        'Lie on the stomach and lift arms and legs for the back extensors.',
        'שכיבה על הבטן והרמת ידיים ורגליים לזוקפי הגב.',
      ),
      instructions: _t(
        '1. Lie face down, arms reaching forward.\n'
        '2. Lift the arms and legs a comfortable amount.\n'
        '3. Pause, then lower.\n'
        '4. Do 10–12 controlled reps.',
        '1. שכב על הבטן, ידיים קדימה.\n'
        '2. הרם ידיים ורגליים בטווח נוח.\n'
        '3. עצור והורד.\n'
        '4. 10–12 חזרות.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.both,
      equipment: EquipmentKind.mat,
      repetitions: 12,
      muscles: const ['back', 'core'],
    ),
    item(
      id: 'ex-dolphin',
      name: _t('Dolphin', 'דולפין'),
      description: _t(
        'A short hold for back extensors and balance, 20–30 seconds.',
        'אחיזה קצרה לזוקפי הגב ולשיווי משקל, 20–30 שניות.',
      ),
      instructions: _t(
        '1. Set up in a stable face-down or forearm position as coached.\n'
        '2. Keep the body long and still.\n'
        '3. Hold 20–30 seconds.',
        '1. התמקם בתנוחה יציבה לפי ההדרכה.\n'
        '2. שמור על גוף ארוך ויציב.\n'
        '3. החזק 20–30 שניות.',
      ),
      category: ExerciseCategory.strength,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.both,
      equipment: EquipmentKind.mat,
      duration: 30,
      muscles: const ['back', 'core'],
    ),
    item(
      id: 'ex-high-march-chair',
      name: _t('High March with Chair Support', 'צעידה גבוהה עם תמיכת כיסא'),
      description: _t(
        'March in place next to a chair, lifting the knees and pumping the opposite arm.',
        'צעידה במקום ליד כיסא, הרמת ברכיים והנעת היד הנגדית.',
      ),
      instructions: _t(
        '1. Stand tall next to a sturdy chair, holding the backrest with one hand.\n'
        '2. March in place, lifting the knees to a comfortable height.\n'
        '3. Pump the opposite arm.\n'
        '4. Keep the chest up and land softly.',
        '1. עמדו זקוף ליד כיסא יציב, יד אחת על המשענת.\n'
        '2. צעדו במקום והרימו ברכיים לגובה נוח.\n'
        '3. הנעו את היד הנגדית.\n'
        '4. שמרו על גב זקוף ונחיתה רכה. ניתן להיעזר בגב הכיסא ליציבות.',
      ),
      category: ExerciseCategory.warmUp,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      equipment: EquipmentKind.chair,
      duration: 60,
      muscles: const ['cardiovascular', 'hipFlexors', 'core'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
    item(
      id: 'ex-step-jacks-low',
      name: _t('Step Jacks — Low Impact', 'סטפ ג׳קס בעצימה נמוכה'),
      description: _t(
        'Side steps with arm reaches below shoulder height. No jumping.',
        'פסיעות לצדדים עם הנעת ידיים מתחת לגובה הכתף. בלי קפיצה.',
      ),
      instructions: _t(
        '1. Step wide to the right and reach the arms out to the sides.\n'
        '2. Return to center.\n'
        '3. Repeat to the left.\n'
        '4. Keep the arms at chest height if the shoulders are sensitive.',
        '1. פסיעה רחבה ימינה והוציאו ידיים לצדדים.\n'
        '2. חזרו למרכז.\n'
        '3. חזרו על הצד שמאל.\n'
        '4. פסיעה רחבה הצידה ללא קפיצה. שמרו ידיים בגובה החזה אם יש רגישות בכתפיים.',
      ),
      category: ExerciseCategory.warmUp,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      duration: 60,
      muscles: const ['cardiovascular', 'shoulders', 'hipFlexors'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
    item(
      id: 'ex-shadow-boxing',
      name: _t('Seated or Standing Shadow Boxing', 'אגרוף צללים בעמידה או בישיבה'),
      description: _t(
        'Controlled straight jabs, seated or standing, with the feet grounded.',
        'אגרופים ישרים מבוקרים בעמידה או בישיבה, כפות רגליים יציבות.',
      ),
      instructions: _t(
        '1. Sit or stand tall with feet wide and grounded.\n'
        '2. Throw light straight jabs, alternating hands.\n'
        '3. Keep the punches at a controlled pace and engage the core.\n'
        '4. Use a stable chair if you prefer to sit.',
        '1. שבו או עמדו זקוף, רגליים ברוחב נוח ויציבות.\n'
        '2. אגרופים ישרים קלים לסירוגין.\n'
        '3. שמרו על קצב מבוקר וליבה פעילה.\n'
        '4. אגרופים לפנים בקצב מבוקר. ניתן לבצע בישיבה על כיסא יציב.',
      ),
      category: ExerciseCategory.cardio,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      equipment: EquipmentKind.chair,
      duration: 45,
      muscles: const ['cardiovascular', 'shoulders', 'core'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
    item(
      id: 'ex-skater-taps',
      name: _t('Low-Impact Skater Taps', 'צעדי מחליק עדינים'),
      description: _t(
        'Light diagonal toe taps behind you, without dropping into a squat.',
        'נגיעת אצבעות אלכסונית מאחור, בלי לרדת לסקווט.',
      ),
      instructions: _t(
        '1. Stand tall.\n'
        '2. Step right and tap the left toes diagonally behind you.\n'
        '3. Alternate sides in a steady rhythm.\n'
        '4. Swing the arms naturally. Do not bend the knees deeply.',
        '1. עמדו זקוף.\n'
        '2. פסעו ימינה ונגעו באצבעות שמאל באלכסון מאחור.\n'
        '3. החליפו צד בקצב רגוע.\n'
        '4. נגיעת אצבעות קלה מאחור, ללא כפוף עמוק של הברכיים.',
      ),
      category: ExerciseCategory.cardio,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      duration: 45,
      muscles: const ['cardiovascular', 'glutes', 'hipFlexors'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
    item(
      id: 'ex-butt-kicks-lat',
      name: _t('Gentle Butt Kicks with Lat Pulls', 'הרמת עקבים לישבן עם משיכת גב'),
      description: _t(
        'Side-to-side steps with a gentle heel lift and elbows pulling back.',
        'צעדים לצדדים עם הרמת עקב עדינה ומשיכת מרפקים לאחור.',
      ),
      instructions: _t(
        '1. Step side to side.\n'
        '2. Bring the heel up toward the glute as you step.\n'
        '3. Pull the elbows back to the waist as the heel lifts.\n'
        '4. Keep the movement small and smooth.',
        '1. צעדו מצד לצד.\n'
        '2. הרימו עקב עדין לכיוון הישבן.\n'
        '3. משכו מרפקים לאחור לגובה המותניים.\n'
        '4. הרמת עקב אחורית עדינה ומשיכת מרפקים לאחור לחיזוק הגב העליון.',
      ),
      category: ExerciseCategory.cardio,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      duration: 45,
      muscles: const ['cardiovascular', 'glutes', 'back'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
    item(
      id: 'ex-lateral-step-touch',
      name: _t('Lateral Step-Touch', 'צעד-צד לצדדים'),
      description: _t(
        'Two side-steps right, a light tap, then two steps back left.',
        'שתי פסיעות ימינה, נגיעה קלה, ושתי פסיעות חזרה שמאלה.',
      ),
      instructions: _t(
        '1. Take two steps to the right.\n'
        '2. Tap the left foot on the floor.\n'
        '3. Take two steps back to the left.\n'
        '4. Keep the knees soft and the chest tall.',
        '1. שתי פסיעות ימינה.\n'
        '2. נגיעה קלה ברצפה.\n'
        '3. שתי פסיעות בחזרה שמאלה.\n'
        '4. שמרו על ברכיים רכות וחזה פתוח.',
      ),
      category: ExerciseCategory.cardio,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      duration: 45,
      muscles: const ['cardiovascular', 'hipFlexors', 'glutes'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
    item(
      id: 'ex-seated-fast-feet',
      name: _t('Seated Fast Feet', 'תיפוף רגליים מהיר בישיבה'),
      description: _t(
        'Quick, light foot taps from the front edge of a chair.',
        'תיפוף מהיר וקליל של כפות הרגליים מקצה הכיסא.',
      ),
      instructions: _t(
        '1. Sit upright on the front edge of a chair.\n'
        '2. Lean back slightly with the core tight.\n'
        '3. Tap the feet as quickly as is comfortable.\n'
        '4. Keep the taps light.',
        '1. שבו זקוף על קצה הכיסא.\n'
        '2. נטו מעט לאחור עם ליבה מכווצת.\n'
        '3. תפפו ברגליים במהירות נוחה.\n'
        '4. ישיבה על קצה הכיסא ותיפוף מהיר וקליל של כפות הרגליים.',
      ),
      category: ExerciseCategory.cardio,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      equipment: EquipmentKind.chair,
      duration: 30,
      muscles: const ['cardiovascular', 'hipFlexors', 'core'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
    item(
      id: 'ex-chair-incline-burpee',
      name: _t('Chair Incline Burpee', 'בורפי בשיפוע על כיסא'),
      description: _t(
        'Hands on a chair seat, step back to an incline plank, step in, and stand tall.',
        'ידיים על מושב כיסא, צעידה לאחור לפלאנק בשיפוע, חזרה ועמידה.',
      ),
      instructions: _t(
        '1. Place both hands on a fixed chair seat.\n'
        '2. Step back one foot at a time into a strong incline plank.\n'
        '3. Step the feet forward.\n'
        '4. Stand tall and reach overhead.',
        '1. הניחו ידיים על מושב כיסא יציב.\n'
        '2. צעדו לאחור רגל-רגל לפלאנק בשיפוע.\n'
        '3. צעדו לפנים.\n'
        '4. עמדו זקוף והרימו ידיים.',
      ),
      category: ExerciseCategory.cardio,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      equipment: EquipmentKind.chair,
      duration: 30,
      muscles: const ['cardiovascular', 'chest', 'core'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
    item(
      id: 'ex-seated-quad-stretch',
      name: _t('Seated Quad and Hip Flexor Stretch', 'מתיחת ארבע-ראשי ומכופפי ירך בישיבה'),
      description: _t(
        'Sit sideways on a chair and drop the outside knee toward the floor.',
        'ישיבה על צידי הכיסא והורדת הברך החיצונית כלפי הרצפה.',
      ),
      instructions: _t(
        '1. Sit sideways on a sturdy chair.\n'
        '2. Drop the outside knee toward the floor.\n'
        '3. Keep the torso upright.\n'
        '4. Hold, then switch sides.',
        '1. שבו על צידי כיסא יציב.\n'
        '2. הורידו את הברך החיצונית כלפי הרצפה.\n'
        '3. החזיקו את הגו זקוף.\n'
        '4. החזיקו והחליפו צד.',
      ),
      category: ExerciseCategory.coolDown,
      difficulty: Difficulty.beginner,
      venue: ExerciseVenue.home,
      equipment: EquipmentKind.chair,
      duration: 120,
      muscles: const ['quadriceps', 'hipFlexors'],
      safety: _t(
        'Low-impact and joint-friendly. Keep a sturdy chair nearby. Stop if you feel dizzy, short of breath, or sharp pain.',
        'אימון בעצימה נמוכה וידידותי למפרקים. השאירו כיסא יציב בקרבת מקום. עצרו אם מופיעה סחרחורת, קוצר נשימה או כאב חד.',
      ),
    ),
  ];
}
