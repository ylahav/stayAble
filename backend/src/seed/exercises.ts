import type { Payload } from 'payload'

import { localizedToLexical } from '../lib/richText'
import { ensureExerciseMedia } from './media'
import { aerobicExercises } from './aerobic-20min'
import { fullBodyPlanExercises } from './full-body-plan'

const safetyDefault = {
  en: 'Move within a comfortable range. Stop if you feel sharp pain.',
  he: 'הישארו בטווח נוח. עצרו אם מופיע כאב חד.',
}

export type SeedExercise = {
  clientId: string
  name: { en: string; he: string }
  description: { en: string; he: string }
  instructions: { en: string; he: string }
  safetyNotes: { en: string; he: string }
  photo: string
  category: 'warmUp' | 'mobility' | 'strength' | 'cardio' | 'stretching' | 'coolDown'
  difficulty: 'beginner' | 'intermediate' | 'advanced'
  venue?: 'home' | 'gym' | 'both'
  workoutType?: 'strength' | 'aerobic' | 'hiit' | 'functional'
  gymNumber?: number
  duration?: number
  repetitions?: number
  targetMuscles: string[]
  equipment: 'none' | 'mat' | 'resistanceBand' | 'dumbbells' | 'chair' | 'machine' | 'barbell' | 'cable' | 'kettlebell' | 'bench'
  active: true
  deleted: false
}

export const seedExercisesCatalog: SeedExercise[] = [
  {
    clientId: 'ex-march',
    name: { en: 'March in Place', he: 'צעידה במקום' },
    description: {
      en: 'Easy marching to raise heart rate and warm the joints.',
      he: 'צעידה קלה להעלאת דופק וחימום המפרקים.',
    },
    instructions: {
      en: '1. Stand tall with feet under the hips.\n2. Lift the knees alternately to about hip height.\n3. Swing the arms naturally.\n4. Keep a steady, easy pace for the full minute.',
      he: '1. עמדו זקוף, רגליים מתחת לירכיים.\n2. הרימו ברכיים לסירוגין עד גובה הירך בערך.\n3. נענעו את הידיים באופן טבעי.\n4. שמרו על קצב רגוע ויציב לאורך כל הדקה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-march.png',
    category: 'warmUp',
    difficulty: 'beginner',
    duration: 60,
    targetMuscles: ['cardiovascular', 'hipFlexors', 'calves'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-shoulder-rolls',
    name: { en: 'Shoulder Rolls', he: 'סיבובי כתפיים' },
    description: {
      en: 'Slow circles to open the shoulders and upper back.',
      he: 'סיבובים איטיים לפתיחת הכתפיים והגב העליון.',
    },
    instructions: {
      en: '1. Stand or sit tall.\n2. Lift the shoulders toward the ears.\n3. Roll them back and down.\n4. Reverse direction halfway through.',
      he: '1. עמדו או שבו זקוף.\n2. הרימו כתפיים לכיוון האוזניים.\n3. גלגלו לאחור ולמטה.\n4. החליפו כיוון באמצע הזמן.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-shoulder-rolls.png',
    category: 'warmUp',
    difficulty: 'beginner',
    duration: 60,
    targetMuscles: ['shoulders', 'back'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-cat-cow',
    name: { en: 'Cat-Cow', he: 'חתול-פרה' },
    description: {
      en: 'Spinal flexion and extension to wake up the back.',
      he: 'כפיפה ויישור של עמוד השדרה להערת הגב.',
    },
    instructions: {
      en: '1. Come to all fours, wrists under shoulders, knees under hips.\n2. Inhale, drop the belly, lift the chest (cow).\n3. Exhale, round the spine toward the ceiling (cat).\n4. Flow slowly with the breath.',
      he: '1. עמדו על שש, פרקי כף היד מתחת לכתפיים, ברכיים מתחת לירכיים.\n2. שאיפה: בטן למטה, חזה למעלה (פרה).\n3. נשיפה: גב מעוגל לתקרה (חתול).\n4. זרמו לאט עם הנשימה.',
    },
    safetyNotes: {
      en: 'Keep wrists comfortable. Pad the knees if needed.',
      he: 'שמרו על פרקי כף היד נוחים. ריפדו את הברכיים אם צריך.',
    },
    photo: 'assets/exercises/ex-cat-cow.png',
    category: 'mobility',
    difficulty: 'beginner',
    duration: 60,
    targetMuscles: ['back', 'core'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-worlds-stretch',
    name: { en: "World's Greatest Stretch", he: 'המתיחה הגדולה' },
    description: {
      en: 'A flowing lunge stretch for hips, hamstrings, and thoracic spine.',
      he: 'מתיחת לאנג׳ זורמת לירכיים, המסטרינג וגב עליון.',
    },
    instructions: {
      en: '1. Step into a long lunge, back knee lifted or down.\n2. Place the same-side hand inside the front foot.\n3. Rotate the chest open and reach the other arm up.\n4. Switch sides and repeat.',
      he: '1. צעדו ללאנג׳ ארוך, ברך אחורית מורמת או על הרצפה.\n2. הניחו את כף היד בצד הרגל הקדמית.\n3. סובבו את החזה ופתחו יד למעלה.\n4. החליפו צד וחזרו.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-worlds-stretch.png',
    category: 'mobility',
    difficulty: 'intermediate',
    duration: 60,
    targetMuscles: ['hipMobility', 'hamstrings', 'back'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-squat',
    name: { en: 'Squat', he: 'סקווט' },
    description: {
      en: 'Sit the hips back and stand up to load the legs.',
      he: 'דחיפת ירכיים לאחור ועמידה להפעלת הרגליים.',
    },
    instructions: {
      en: '1. Stand with feet about shoulder-width apart.\n2. Push the hips backwards.\n3. Bend the knees and keep the chest lifted.\n4. Return to standing.',
      he: '1. עמדו עם רגליים ברוחב הכתפיים בערך.\n2. דחפו את הירכיים לאחור.\n3. כופפו ברכיים ושמרו על חזה מורם.\n4. חזרו לעמידה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-squat.png',
    category: 'strength',
    difficulty: 'beginner',
    repetitions: 12,
    targetMuscles: ['quadriceps', 'glutes', 'hamstrings'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-incline-pushup',
    name: { en: 'Incline Push-up', he: 'שכיבות סמיכה בשיפוע' },
    description: {
      en: 'Push-ups with hands on a chair, counter, or wall.',
      he: 'שכיבות סמיכה עם ידיים על כיסא, משטח או קיר.',
    },
    instructions: {
      en: '1. Place hands on a stable elevated surface.\n2. Walk the feet back into a straight line from head to heels.\n3. Bend the elbows and lower the chest toward the surface.\n4. Press back to the start.',
      he: '1. הניחו ידיים על משטח יציב וגבוה.\n2. צעדו רגליים אחורה לקו ישר מהראש לעקבים.\n3. כופפו מרפקים והורידו חזה לכיוון המשטח.\n4. לחצו חזרה להתחלה.',
    },
    safetyNotes: {
      en: 'Use a surface that will not slide. Keep the body in one line.',
      he: 'השתמשו במשטח שאינו מחליק. שמרו על הגוף בקו אחד.',
    },
    photo: 'assets/exercises/ex-incline-pushup.png',
    category: 'strength',
    difficulty: 'beginner',
    repetitions: 10,
    targetMuscles: ['chest', 'shoulders', 'core'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-reverse-lunge',
    name: { en: 'Reverse Lunge', he: 'לאנג׳ אחורה' },
    description: {
      en: 'Step back into a lunge, then return. Alternate legs.',
      he: 'צעד אחורה ללאנג׳ וחזרו. החליפו רגליים.',
    },
    instructions: {
      en: '1. Stand tall.\n2. Step one foot back and lower the back knee toward the floor.\n3. Front knee stays stacked over the ankle.\n4. Push through the front foot to stand and switch sides.',
      he: '1. עמדו זקוף.\n2. צעדו רגל אחורה והורידו את הברך האחורית לכיוון הרצפה.\n3. הברך הקדמית נשארת מעל הקרסול.\n4. לחצו דרך הרגל הקדמית לעמידה והחליפו צד.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-reverse-lunge.png',
    category: 'strength',
    difficulty: 'beginner',
    repetitions: 10,
    targetMuscles: ['quadriceps', 'glutes', 'hamstrings'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-glute-bridge',
    name: { en: 'Glute Bridge', he: 'גשר ישבן' },
    description: {
      en: 'Lie on the back and lift the hips by squeezing the glutes.',
      he: 'שכבו על הגב והרימו אגן תוך כיווץ הישבן.',
    },
    instructions: {
      en: '1. Lie on your back, knees bent, feet flat.\n2. Press through the heels and lift the hips.\n3. Squeeze the glutes at the top without arching the low back.\n4. Lower with control.',
      he: '1. שכבו על הגב, ברכיים כפופות, כפות רגליים על הרצפה.\n2. לחצו דרך העקבים והרימו את האגן.\n3. כווצו ישבן למעלה בלי לקשת את הגב התחתון.\n4. הורידו בשליטה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-glute-bridge.png',
    category: 'strength',
    difficulty: 'beginner',
    repetitions: 12,
    targetMuscles: ['glutes', 'hamstrings', 'core'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-plank',
    name: { en: 'Plank', he: 'פלאנק' },
    description: {
      en: 'Hold a straight body line on forearms or hands.',
      he: 'החזיקו קו גוף ישר על אמות או ידיים.',
    },
    instructions: {
      en: '1. Set elbows under shoulders (or hands for a high plank).\n2. Extend the legs and brace the core.\n3. Keep hips level — not sagging or piked.\n4. Breathe steadily for the hold.',
      he: '1. מרפקים מתחת לכתפיים (או ידיים לפלאנק גבוה).\n2. יישרו רגליים וכווצו ליבה.\n3. שמרו על אגן ישר — בלי לצנוח או להתרומם.\n4. נשמו באופן יציב לאורך האחיזה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-plank.png',
    category: 'strength',
    difficulty: 'beginner',
    duration: 30,
    targetMuscles: ['core', 'shoulders'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-cardio',
    name: { en: 'Cardio', he: 'אירובי' },
    description: {
      en: 'Six minutes of marching, step-touches, or easy jogging in place.',
      he: 'שש דקות צעידה, צעדי צד או ריצה קלה במקום.',
    },
    instructions: {
      en: '1. Choose a low-impact option if needed (march or step-touch).\n2. Keep moving for the full six minutes.\n3. You should be able to speak in short sentences.\n4. Slow down if you feel dizzy or unwell.',
      he: '1. בחרו אפשרות עצימה נמוכה אם צריך (צעידה או צעד-צד).\n2. המשיכו לנוע לאורך שש הדקות.\n3. אפשר לדבר במשפטים קצרים.\n4. האטו אם מופיע סחרחורת או הרגשה לא טובה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-cardio.png',
    category: 'cardio',
    difficulty: 'beginner',
    duration: 360,
    targetMuscles: ['cardiovascular', 'fullBody'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-cooldown',
    name: { en: 'Cool-down', he: 'שחרור' },
    description: {
      en: 'Easy breathing and light stretches to finish.',
      he: 'נשימה קלה ומתיחות עדינות לסיום.',
    },
    instructions: {
      en: '1. Walk slowly in place and let the breath settle.\n2. Stretch the hips, hamstrings, and chest without bouncing.\n3. Hold each stretch about 20 seconds.\n4. Finish standing tall.',
      he: '1. צעדו לאט במקום ותנו לנשימה להירגע.\n2. מתחו ירכיים, המסטרינג וחזה בלי קפיצות.\n3. החזיקו כל מתיחה כ־20 שניות.\n4. סיימו בעמידה זקופה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-cooldown.png',
    category: 'coolDown',
    difficulty: 'beginner',
    duration: 120,
    targetMuscles: ['fullBody'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-jumping-jacks',
    name: { en: 'Jumping Jacks', he: 'ג׳מפינג ג׳קס' },
    description: {
      en: 'A classic full-body pulse raiser. Step-touch if jumping is too much.',
      he: 'תרגיל קלאסי להעלאת דופק. אפשר צעד-צד במקום קפיצה.',
    },
    instructions: {
      en: '1. Stand with feet together and arms by the sides.\n2. Jump the feet out and raise the arms overhead.\n3. Return to the start.\n4. Land softly, or step out instead of jumping.',
      he: '1. עמדו עם רגליים צמודות וידיים לצדדים.\n2. קפצו החוצה והרימו ידיים מעל הראש.\n3. חזרו להתחלה.\n4. נחתו ברכות, או צעדו החוצה במקום לקפוץ.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-jumping-jacks.png',
    category: 'cardio',
    difficulty: 'beginner',
    duration: 45,
    targetMuscles: ['cardiovascular', 'calves', 'shoulders'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-wall-sit',
    name: { en: 'Wall Sit', he: 'ישיבת קיר' },
    description: {
      en: 'Hold a seated position against the wall to load the legs.',
      he: 'החזיקו תנוחת ישיבה מול הקיר להפעלת הרגליים.',
    },
    instructions: {
      en: '1. Stand with the back against a wall.\n2. Slide down until thighs are about parallel to the floor.\n3. Keep knees over the ankles.\n4. Hold, then stand up with control.',
      he: '1. עמדו עם הגב לקיר.\n2. החליקו למטה עד שהירכיים מקבילות לרצפה בערך.\n3. שמרו ברכיים מעל הקרסוליים.\n4. החזיקו, ואז עמדו בשליטה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-wall-sit.png',
    category: 'strength',
    difficulty: 'beginner',
    duration: 30,
    targetMuscles: ['quadriceps', 'glutes'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-dead-bug',
    name: { en: 'Dead Bug', he: 'חרק מת' },
    description: {
      en: 'Opposite arm and leg reach while the low back stays on the floor.',
      he: 'יד ורגל נגדיות נשלחות בזמן שהגב התחתון נשאר על הרצפה.',
    },
    instructions: {
      en: '1. Lie on your back, arms up, knees over hips.\n2. Press the low back gently into the floor.\n3. Extend one leg and the opposite arm.\n4. Return and switch sides.',
      he: '1. שכבו על הגב, ידיים למעלה, ברכיים מעל הירכיים.\n2. לחצו קלות את הגב התחתון לרצפה.\n3. יישרו רגל אחת ואת היד הנגדית.\n4. חזרו והחליפו צד.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-dead-bug.png',
    category: 'strength',
    difficulty: 'beginner',
    repetitions: 8,
    targetMuscles: ['core'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-bird-dog',
    name: { en: 'Bird Dog', he: 'ציפור-כלב' },
    description: {
      en: 'Balance on all fours while reaching opposite arm and leg.',
      he: 'שיווי משקל על שש תוך שליחת יד ורגל נגדיות.',
    },
    instructions: {
      en: '1. Come to all fours.\n2. Reach one arm forward and the opposite leg back.\n3. Keep the hips level.\n4. Return and switch.',
      he: '1. עמדו על שש.\n2. שלחו יד קדימה ואת הרגל הנגדית אחורה.\n3. שמרו על אגן ישר.\n4. חזרו והחליפו.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-bird-dog.png',
    category: 'mobility',
    difficulty: 'beginner',
    repetitions: 8,
    targetMuscles: ['core', 'back', 'glutes'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-side-plank',
    name: { en: 'Side Plank', he: 'פלאנק צד' },
    description: {
      en: 'A side body hold for the obliques and shoulders.',
      he: 'אחיזת צד לאלכסונים ולכתפיים.',
    },
    instructions: {
      en: '1. Lie on one side, elbow under the shoulder.\n2. Lift the hips so the body is a straight line.\n3. Hold, then switch sides.\n4. Drop the bottom knee if you need an easier option.',
      he: '1. שכבו על הצד, מרפק מתחת לכתף.\n2. הרימו אגן לקו ישר.\n3. החזיקו, ואז החליפו צד.\n4. הורידו ברך תחתונה אם צריך הקלה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-side-plank.png',
    category: 'strength',
    difficulty: 'intermediate',
    duration: 20,
    targetMuscles: ['core', 'shoulders'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-calf-raise',
    name: { en: 'Calf Raise', he: 'הרמת שוקיים' },
    description: {
      en: 'Rise onto the balls of the feet, then lower slowly.',
      he: 'עלו על כריות כפות הרגליים והורידו לאט.',
    },
    instructions: {
      en: '1. Stand tall, optional light touch on a wall for balance.\n2. Rise onto the balls of both feet.\n3. Pause at the top.\n4. Lower with control.',
      he: '1. עמדו זקוף, אפשר מגע קל בקיר לשיווי משקל.\n2. עלו על כריות שתי הרגליים.\n3. עצרו למעלה.\n4. הורידו בשליטה.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-calf-raise.png',
    category: 'strength',
    difficulty: 'beginner',
    repetitions: 15,
    targetMuscles: ['calves'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  {
    clientId: 'ex-kneeling-pushup',
    name: { en: 'Kneeling Push-up', he: 'שכיבות סמיכה על הברכיים' },
    description: {
      en: 'A floor push-up with knees down to reduce load.',
      he: 'שכיבת סמיכה על הרצפה עם ברכיים למטה להפחתת עומס.',
    },
    instructions: {
      en: '1. Hands under shoulders, knees on the floor.\n2. Keep a straight line from head to knees.\n3. Lower the chest, then press up.\n4. Do not let the hips sag.',
      he: '1. ידיים מתחת לכתפיים, ברכיים על הרצפה.\n2. שמרו על קו ישר מהראש לברכיים.\n3. הורידו חזה ולחצו מעלה.\n4. אל תתנו לאגן לצנוח.',
    },
    safetyNotes: safetyDefault,
    photo: 'assets/exercises/ex-kneeling-pushup.png',
    category: 'strength',
    difficulty: 'beginner',
    repetitions: 10,
    targetMuscles: ['chest', 'shoulders', 'core'],
    equipment: 'none',
    active: true,
    deleted: false,
  },
  ...fullBodyPlanExercises,
  ...aerobicExercises,
]

const workoutTypeOverrides: Record<string, NonNullable<SeedExercise['workoutType']>> = {
  'ex-march': 'aerobic',
  'ex-plank': 'functional',
  'ex-dead-bug': 'functional',
  'ex-bird-dog': 'functional',
  'ex-side-plank': 'functional',
  'ex-bosu-hold': 'functional',
  'ex-superman': 'functional',
  'ex-dolphin': 'functional',
  'ex-high-march-chair': 'aerobic',
  'ex-step-jacks-low': 'aerobic',
  'ex-shadow-boxing': 'hiit',
  'ex-skater-taps': 'hiit',
  'ex-butt-kicks-lat': 'hiit',
  'ex-seated-fast-feet': 'hiit',
  'ex-chair-incline-burpee': 'hiit',
}

export function resolveWorkoutType(exercise: Pick<SeedExercise, 'clientId' | 'category' | 'workoutType'>): NonNullable<SeedExercise['workoutType']> {
  if (exercise.workoutType) return exercise.workoutType
  const override = workoutTypeOverrides[exercise.clientId]
  if (override) return override
  if (exercise.category === 'strength') return 'strength'
  if (exercise.category === 'cardio') return 'aerobic'
  return 'functional'
}

export async function seedExerciseCatalog(payload: Payload): Promise<void> {
  let created = 0
  let imaged = 0
  for (const exercise of seedExercisesCatalog) {
    let mediaId: string | undefined
    try {
      mediaId = await ensureExerciseMedia(payload, exercise)
    } catch (err) {
      payload.logger.error({ err, clientId: exercise.clientId }, 'Could not attach exercise photo')
    }
    const { photo, instructions, ...fields } = exercise
    const data = {
      ...fields,
      instructions: localizedToLexical(instructions),
      venue: exercise.venue ?? 'both',
      workoutType: resolveWorkoutType(exercise),
      photoPath: photo,
      ...(mediaId ? { image: mediaId } : {}),
    }

    const existing = await payload.find({
      collection: 'exercises',
      depth: 0,
      limit: 1,
      pagination: false,
      where: { clientId: { equals: exercise.clientId } },
    })
    if (!existing.docs[0]) {
      await payload.create({
        collection: 'exercises',
        data,
      })
      created += 1
      continue
    }
    if (mediaId && !existing.docs[0].image) {
      await payload.update({
        collection: 'exercises',
        id: existing.docs[0].id,
        data: { image: mediaId, photoPath: photo },
      })
      imaged += 1
    }
    if (!existing.docs[0].venue) {
      await payload.update({
        collection: 'exercises',
        id: existing.docs[0].id,
        data: { venue: exercise.venue ?? 'both' },
      })
    }
    if (!existing.docs[0].workoutType) {
      await payload.update({
        collection: 'exercises',
        id: existing.docs[0].id,
        data: { workoutType: resolveWorkoutType(exercise) },
      })
    }
  }
  if (created > 0 || imaged > 0) {
    payload.logger.info(`Seeded ${created} exercises, attached ${imaged} photos`)
  }
}
