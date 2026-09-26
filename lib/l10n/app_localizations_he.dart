// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'יכולת';

  @override
  String get navHome => 'בית';

  @override
  String get navExercises => 'תרגילים';

  @override
  String get navProgram => 'תוכנית';

  @override
  String get navHistory => 'היסטוריה';

  @override
  String get languageToggle => 'שפה';

  @override
  String get goodMorning => 'בוקר טוב';

  @override
  String get goodAfternoon => 'צהריים טובים';

  @override
  String get goodEvening => 'ערב טוב';

  @override
  String get todaysWorkout => 'האימון להיום';

  @override
  String get startWorkout => 'התחל אימון';

  @override
  String get resumeWorkout => 'המשך אימון';

  @override
  String get inProgress => 'בתהליך';

  @override
  String get thisWeek => 'השבוע';

  @override
  String get thisMonth => 'החודש';

  @override
  String get workouts => 'אימונים';

  @override
  String get workoutTime => 'זמן אימון';

  @override
  String get exercisesLabel => 'תרגילים';

  @override
  String get completion => 'השלמה';

  @override
  String get minutes => 'דקות';

  @override
  String get minutesShort => 'דק׳';

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursש׳ $minutesדק׳';
  }

  @override
  String get search => 'חיפוש';

  @override
  String get categoryAll => 'הכל';

  @override
  String get categoryWarmUp => 'חימום';

  @override
  String get categoryMobility => 'מוביליטי';

  @override
  String get categoryStrength => 'כוח';

  @override
  String get categoryCardio => 'אירובי';

  @override
  String get categoryStretching => 'מתיחות';

  @override
  String get categoryCoolDown => 'שחרור';

  @override
  String get workoutTypeLabel => 'סוג אימון';

  @override
  String get workoutTypeAll => 'כל הסוגים';

  @override
  String get workoutTypeStrength => 'כוח';

  @override
  String get workoutTypeAerobic => 'אירובי';

  @override
  String get workoutTypeHiit => 'HIIT';

  @override
  String get workoutTypeFunctional => 'פונקציונלי';

  @override
  String get filterAtHome => 'בבית';

  @override
  String get difficultyBeginner => 'מתחיל';

  @override
  String get difficultyIntermediate => 'בינוני';

  @override
  String get difficultyAdvanced => 'מתקדם';

  @override
  String get howToPerform => 'איך לבצע';

  @override
  String get targetMuscles => 'שרירים יעד';

  @override
  String get equipment => 'ציוד';

  @override
  String get description => 'תיאור';

  @override
  String get difficulty => 'רמה';

  @override
  String get safetyNotes => 'הערות בטיחות';

  @override
  String get equipmentNone => 'ללא';

  @override
  String get equipmentMat => 'מזרן';

  @override
  String get equipmentResistanceBand => 'גומיית התנגדות';

  @override
  String get equipmentDumbbells => 'משקולות';

  @override
  String get equipmentChair => 'כיסא';

  @override
  String get equipmentMachine => 'מכונה';

  @override
  String get equipmentBarbell => 'מוט';

  @override
  String get equipmentCable => 'כבל';

  @override
  String get equipmentKettlebell => 'קטלבל';

  @override
  String get equipmentBench => 'ספסל';

  @override
  String get venueHome => 'בית';

  @override
  String get venueGym => 'אולם';

  @override
  String get venueBoth => 'בית + אולם';

  @override
  String get venueMixed => 'משולב';

  @override
  String gymStation(int n) {
    return 'עמדה #$n';
  }

  @override
  String get kg => 'ק״ג';

  @override
  String get load => 'משקל';

  @override
  String get myProgram => 'התוכנית שלי';

  @override
  String get myPrograms => 'התוכניות שלי';

  @override
  String get weeklyProgram => 'תוכנית שבועית';

  @override
  String get noProgramAssigned => 'עדיין לא שובצה תוכנית';

  @override
  String get completed => 'הושלם';

  @override
  String get today => 'היום';

  @override
  String get upcoming => 'בקרוב';

  @override
  String exerciseProgress(int current, int total) {
    return 'תרגיל $current / $total';
  }

  @override
  String get chooseExercise => 'בחר תרגיל';

  @override
  String get chooseAnother => 'בחר תרגיל אחר';

  @override
  String exercisesDone(int done, int total) {
    return '$done מתוך $total הושלמו';
  }

  @override
  String get reps => 'חזרות';

  @override
  String get sets => 'סטים';

  @override
  String get rest => 'מנוחה';

  @override
  String get done => 'סיימתי';

  @override
  String get skip => 'דלג';

  @override
  String get howDidYouDo => 'איך היה לך?';

  @override
  String get effortEasy => 'קל';

  @override
  String get effortGood => 'טוב';

  @override
  String get effortDifficult => 'קשה';

  @override
  String get continueLabel => 'המשך';

  @override
  String get history => 'היסטוריה';

  @override
  String get restDay => 'יום מנוחה';

  @override
  String get restDayMessage =>
      'אין אימון מתוכנן להיום. אפשר לנוח או לעיין בתוכנית.';

  @override
  String get viewProgram => 'לצפייה בתוכנית';

  @override
  String get partiallyCompleted => 'הושלם חלקית';

  @override
  String get skipped => 'דולג';

  @override
  String get cancelled => 'בוטל';

  @override
  String get planned => 'מתוכנן';

  @override
  String get started => 'התחיל';

  @override
  String setNumber(int n) {
    return 'סט $n';
  }

  @override
  String get seconds => 'שנ׳';

  @override
  String get noHistory => 'עדיין אין אימונים. התחילו את האימון מהמסך הראשי.';

  @override
  String get noExercises => 'אין תרגילים שתואמים לחיפוש.';

  @override
  String get endWorkout => 'סיים אימון';

  @override
  String get workoutComplete => 'האימון הושלם';

  @override
  String get seeHistory => 'לצפייה בהיסטוריה';

  @override
  String get start => 'התחל';

  @override
  String get nextSet => 'סט הבא';

  @override
  String get confirmSet => 'רשום סט';

  @override
  String get weekdayMon => 'שני';

  @override
  String get weekdayTue => 'שלישי';

  @override
  String get weekdayWed => 'רביעי';

  @override
  String get weekdayThu => 'חמישי';

  @override
  String get weekdayFri => 'שישי';

  @override
  String get weekdaySat => 'שבת';

  @override
  String get weekdaySun => 'ראשון';

  @override
  String get muscleQuadriceps => 'ארבע ראשי';

  @override
  String get muscleGlutes => 'ישבן';

  @override
  String get muscleHamstrings => 'המסטרינג';

  @override
  String get muscleShoulders => 'כתפיים';

  @override
  String get muscleChest => 'חזה';

  @override
  String get muscleCore => 'ליבה';

  @override
  String get muscleCalves => 'שוקיים';

  @override
  String get muscleHipFlexors => 'מכופפי ירך';

  @override
  String get muscleBack => 'גב';

  @override
  String get muscleFullBody => 'כל הגוף';

  @override
  String get muscleCardiovascular => 'סיבולת לב־ריאה';

  @override
  String get muscleHipMobility => 'ירכיים';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String exerciseCount(int count) {
    return '$count תרגילים';
  }

  @override
  String prescriptionSetsReps(int sets, int reps) {
    return '$sets × $reps';
  }

  @override
  String prescriptionDuration(int seconds) {
    return '$seconds שנ׳';
  }

  @override
  String prescriptionMinutes(int minutes) {
    return '$minutes דק׳';
  }

  @override
  String get alreadyCompletedToday => 'הושלם היום';

  @override
  String get startAgain => 'התחל שוב';

  @override
  String get exitWorkoutTitle => 'לסיים את האימון?';

  @override
  String get exitWorkoutBody => 'תרגילים שלא הושלמו יישמרו כאימון חלקי.';

  @override
  String get cancel => 'ביטול';

  @override
  String get savePartial => 'שמור חלקי';

  @override
  String get close => 'סגור';

  @override
  String get setupTitle => 'פרטי או עם מאמן?';

  @override
  String get setupLead =>
      'בחירה ראשונה: להישאר פרטיים במכשיר, או להתחבר כמשתמש שהמאמן הגדיר בשרת.';

  @override
  String get setupServerLead =>
      'אתם משתמשים באתר StayAble הזה. התוכניות והתוצאות נשמרות שם. לא תצטרכו להזין את הכתובת שוב בכניסה.';

  @override
  String get setupContinue => 'המשך';

  @override
  String get changeSetup => 'שינוי הגדרת המכשיר';

  @override
  String get changeSetupHint => 'בחרו שוב פרטי או מאמן. תנותקו מהחשבון.';

  @override
  String get modeChooserTitle => 'איך תרצו להתאמן?';

  @override
  String get modeChooserLead => 'פרטי במכשיר, או עם מאמן בשרת.';

  @override
  String get modeTrainerTitle => 'עם מאמן';

  @override
  String get modeTrainerLead =>
      'רשת. המאמן הגדיר אתכם כמשתמש בשרת StayAble. התוכניות והתוצאות נשמרות שם.';

  @override
  String get modeTrainerAction => 'המשך עם מאמן';

  @override
  String get modeLocalTitle => 'פרטי';

  @override
  String get modeLocalLead =>
      'רק במכשיר הזה. אינכם משתמש בשרת. כאן בונים תוכנית משלכם.';

  @override
  String get modeLocalAction => 'המשך בפרטיות';

  @override
  String get setupLocalLoginTitle => 'להשתמש בהתחברות במכשיר הזה?';

  @override
  String get setupLocalLoginLead =>
      'התחברות שומרת את התוכניות של כל אדם בנפרד כשכמה אנשים משתמשים ב־StayAble. אפשר לדלג כדי להישאר אנונימיים.';

  @override
  String get setupLocalLoginYesTitle => 'עם התחברות';

  @override
  String get setupLocalLoginYesLead =>
      'צרו משתמש במכשיר, או התחברו. התוכניות נשארות כאן ואינן מתערבבות.';

  @override
  String get setupLocalLoginYesAction => 'שימוש בהתחברות';

  @override
  String get setupLocalLoginNoTitle => 'בלי התחברות';

  @override
  String get setupLocalLoginNoLead =>
      'פרטיות מלאה. בלי חשבון. כולם במכשיר משתמשים באותן תוכניות.';

  @override
  String get setupLocalLoginNoAction => 'המשך בלי התחברות';

  @override
  String get loginLeadLocal =>
      'צרו משתמש במכשיר, או התחברו. לכל אדם יש תוכניות משלו כאן.';

  @override
  String get backToModes => 'פרטי או מאמן';

  @override
  String get createProgram => 'יצירת תוכנית';

  @override
  String get createProgramHow =>
      'בנו לבד, או ש־StayAble ישתמש בפרופיל הספורטאי.';

  @override
  String get createProgramManualTitle => 'ידני';

  @override
  String get createProgramManualLead => 'בחרו ימים ותרגילים בעצמכם.';

  @override
  String get createProgramManualAction => 'אבנה בעצמי';

  @override
  String get createProgramWizardTitle => 'מהפרופיל';

  @override
  String get createProgramWizardLead =>
      'StayAble בונה תוכנית מפרופיל הספורטאי. בריאות, מטרות ואורח חיים מעדכנים שם — לא בכל תוכנית.';

  @override
  String get createProgramWizardAction => 'בנייה מהפרופיל';

  @override
  String get createProgramWizardOffline => 'האשף זקוק לחיבור לשרת StayAble.';

  @override
  String get wizardTitle => 'פרופיל ספורטאי';

  @override
  String get wizardLead =>
      'גיל הוא רק נקודת התחלה. פרופיל הספורטאי כולל בריאות, מטרות, כושר, אורח חיים והרגלים.';

  @override
  String get wizardVenue => 'איפה תתאמנו?';

  @override
  String get wizardType => 'איזה סוג תוכנית?';

  @override
  String get wizardAge => 'גיל';

  @override
  String get wizardAgeRange => 'הגיל צריך להיות בין 12 ל־90.';

  @override
  String get birthday => 'תאריך לידה';

  @override
  String get birthdayLead =>
      'מזינים פעם אחת. StayAble משתמש בזה כדי להתאים תוכניות ואימונים.';

  @override
  String get birthdayRequired => 'הוסיפו תאריך לידה כדי להמשיך.';

  @override
  String get birthdaySave => 'שמירת תאריך לידה';

  @override
  String get birthdayChange => 'שינוי תאריך לידה';

  @override
  String get birthdayUnset => 'לא הוגדר';

  @override
  String get wizardStatus => 'רמת הכושר הנוכחית';

  @override
  String get wizardGoals => 'מטרות';

  @override
  String get wizardGoalsRequired => 'בחרו לפחות מטרה אחת.';

  @override
  String get wizardPeriod => 'לוח זמנים';

  @override
  String get wizardPeriodWeekly => 'שבועי';

  @override
  String get wizardPeriodWeeklyHint => 'בחרו את הימים שחוזרים כל שבוע.';

  @override
  String get wizardDays => 'ימי אימון';

  @override
  String get wizardPeriodDaily => 'יום־יום';

  @override
  String get wizardPeriodDailyHint => 'אימון לכל יום.';

  @override
  String get wizardPeriodOccasional => 'מזדמן';

  @override
  String get wizardPeriodOccasionalHint => 'זמין בכל עת. בוחרים מתי להתחיל.';

  @override
  String get scheduleAnytime => 'מתי שרוצים';

  @override
  String get wizardGenerate => 'יצירת תוכנית';

  @override
  String get wizardFailed => 'לא ניתן ליצור תוכנית. בדקו את החיבור ונסו שוב.';

  @override
  String get wizardEmptyCatalog => 'אין מספיק תרגילים מתאימים לבניית התוכנית.';

  @override
  String get goalGeneralFitness => 'כושר כללי';

  @override
  String get goalStrength => 'חיזוק';

  @override
  String get goalMobility => 'ניידות';

  @override
  String get goalCardio => 'אירובי';

  @override
  String get goalWeightManagement => 'ניהול משקל';

  @override
  String get goalBodyToning => 'חיטוב';

  @override
  String get wizardNext => 'הבא';

  @override
  String get wizardBack => 'חזרה';

  @override
  String wizardStepOf(int current, int total) {
    return 'שלב $current מתוך $total';
  }

  @override
  String get wizardHealthTitle => 'בריאות והיסטוריה רפואית';

  @override
  String get wizardHealthLead =>
      'זה השלב החשוב ביותר. StayAble משתמש בזה כדי לשמור על תוכנית בטוחה יותר. זה אינו אבחון רפואי.';

  @override
  String get wizardHealthInjuries => 'פציעות או כאב כרוני';

  @override
  String get wizardHealthConditions => 'מצבים רפואיים';

  @override
  String get wizardHealthMeds =>
      'תרופות שמשפיעות על דופק, לחץ דם, שיווי משקל או אנרגיה';

  @override
  String get wizardHealthClearance => 'נדרש אישור רופא לפני פעילות';

  @override
  String get wizardHealthNone => 'אין מהאלה';

  @override
  String get assessInjuryKnees => 'ברכיים';

  @override
  String get assessInjuryBack => 'גב';

  @override
  String get assessInjuryShoulders => 'כתפיים';

  @override
  String get assessInjuryOther => 'אחר';

  @override
  String get assessConditionHeart => 'מחלת לב';

  @override
  String get assessConditionBp => 'לחץ דם גבוה';

  @override
  String get assessConditionAsthma => 'אסתמה';

  @override
  String get assessConditionDiabetes => 'סוכרת';

  @override
  String get assessConditionJoints => 'בעיות מפרקים';

  @override
  String get wizardGoalsLead => 'למה התוכנית צריכה לכוון, ובאיזה קצב?';

  @override
  String get wizardTimeline => 'מתי מצפים לראות תוצאות?';

  @override
  String get assessTimelineSlow => 'לאט וביציבות';

  @override
  String get assessTimelineModerate => 'תוך כמה חודשים';

  @override
  String get assessTimelineFast => 'מהר ככל האפשר';

  @override
  String get wizardPreferences => 'איך מעדיפים להתאמן?';

  @override
  String get assessPrefFreeWeights => 'משקולות חופשיות';

  @override
  String get assessPrefMachines => 'מכונות';

  @override
  String get assessPrefFunctional => 'אימון פונקציונלי';

  @override
  String get assessPrefMixed => 'שילוב';

  @override
  String get wizardFitnessTitle => 'כושר וניסיון נוכחיים';

  @override
  String get wizardFitnessLead => 'נקודת התחלה, אופי העבודה, ואיך הגוף זז.';

  @override
  String get wizardBackground => 'מתחילים מאפס או חוזרים לכושר?';

  @override
  String get assessBackgroundStarting => 'מתחילים מאפס';

  @override
  String get assessBackgroundReturning => 'חוזרים לכושר';

  @override
  String get assessBackgroundCurrent => 'כבר מתאמנים';

  @override
  String get wizardOccupation => 'עיסוק יומיומי';

  @override
  String get assessOccupationSedentary => 'בעיקר ישיבה';

  @override
  String get assessOccupationMixed => 'שילוב של ישיבה ותנועה';

  @override
  String get assessOccupationPhysical => 'עבודה פיזית';

  @override
  String get wizardMobility => 'ניידות, גמישות ויציבות ליבה';

  @override
  String get assessMobilityLimited => 'מוגבלת';

  @override
  String get assessMobilityAverage => 'בינונית';

  @override
  String get assessMobilityGood => 'טובה';

  @override
  String get wizardLifestyleTitle => 'זמינות ואורח חיים';

  @override
  String get wizardLifestyleLead => 'כמה ימים, כמה זמן, ואיך מתאוששים.';

  @override
  String get wizardSessionMinutes => 'דקות לאימון';

  @override
  String get wizardSleepHours => 'שעות שינה';

  @override
  String get wizardStress => 'רמת לחץ יומית';

  @override
  String get assessStressLow => 'נמוכה';

  @override
  String get assessStressModerate => 'בינונית';

  @override
  String get assessStressHigh => 'גבוהה';

  @override
  String get wizardNutritionTitle => 'תזונה והרגלים';

  @override
  String get wizardNutritionLead =>
      'אוכל והרגלים שמשפיעים על סיבולת והתאוששות.';

  @override
  String get wizardDiet => 'דפוס אכילה';

  @override
  String get assessDietRegular => 'ארוחות סדירות';

  @override
  String get assessDietPlan => 'תפריט מוגדר';

  @override
  String get assessDietSkip => 'מדלגים על ארוחות';

  @override
  String get wizardHabits => 'עישון או אלכוהול';

  @override
  String get assessHabitNone => 'לא';

  @override
  String get assessHabitSmoking => 'עישון';

  @override
  String get assessHabitAlcohol => 'אלכוהול';

  @override
  String get assessHabitBoth => 'שניהם';

  @override
  String get wizardProgramTitle => 'צורת התוכנית';

  @override
  String get wizardProgramLead =>
      'בחירות אחרונות: איפה מתאמנים ואיזה סוג אימונים לבנות.';

  @override
  String get wizardSaveAssessment => 'שמירת האבחון';

  @override
  String get wizardAssessmentSaved => 'האבחון נשמר';

  @override
  String get assessTitle => 'פרופיל ספורטאי';

  @override
  String get assessChange => 'עריכת פרופיל ספורטאי';

  @override
  String get assessUnset => 'עדיין לא מולא';

  @override
  String get editProgram => 'עריכה';

  @override
  String get deleteProgram => 'מחיקה';

  @override
  String get deleteProgramConfirm =>
      'למחוק את התוכנית הזו? היסטוריית האימונים תישאר.';

  @override
  String get programName => 'שם התוכנית';

  @override
  String get programNameRequired => 'הזינו שם לתוכנית';

  @override
  String get saveProgram => 'שמירת תוכנית';

  @override
  String get programSaved => 'התוכנית נשמרה';

  @override
  String get addExercise => 'הוספת תרגיל';

  @override
  String get selectDays => 'בחרו לפחות יום אחד';

  @override
  String get programNeedsExercise => 'הוסיפו לפחות תרגיל אחד';

  @override
  String get timedExercise => 'לפי זמן';

  @override
  String get repsExercise => 'לפי חזרות';

  @override
  String get removeExercise => 'הסרה';

  @override
  String get reorderExercise => 'גררו לשינוי הסדר';

  @override
  String get catalogRefresh => 'עדכון רשימת התרגילים';

  @override
  String get catalogRefreshed => 'הרשימה עודכנה';

  @override
  String get catalogRefreshFailed =>
      'לא ניתן לעדכן את הרשימה. בדקו את כתובת השרת.';

  @override
  String get serverUrlHintLocal =>
      'כתובת HTTPS של אתר StayAble. משם מורידים את רשימת התרגילים.';

  @override
  String get catalogWeeklyHint =>
      'StayAble בודק בשרת ברירת המחדל בערך פעם בשבוע אם נוספו תרגילים. אפשר גם לעדכן את הרשימה כאן.';

  @override
  String get catalogUpdateBadge => 'תרגילים חדשים';

  @override
  String catalogUpdateAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'יש $count תרגילים חדשים.',
      one: 'יש תרגיל חדש.',
    );
    return '$_temp0';
  }

  @override
  String get catalogUpdateChanged => 'יש עדכונים לרשימת התרגילים.';

  @override
  String get catalogSyncNow => 'סנכרון תרגילים';

  @override
  String get catalogUpdateLater => 'מאוחר יותר';

  @override
  String get appModeLocal => 'פרטי';

  @override
  String get appModeCloud => 'עם מאמן';

  @override
  String get noProgramLocal => 'עדיין אין תוכנית. צרו אחת מרשימת התרגילים.';

  @override
  String get chooseTags => 'סינון לפי תגיות';

  @override
  String get loginTitle => 'התחברו כדי להתאמן';

  @override
  String get loginLead =>
      'לספורטאים בלבד. אותו אימייל וסיסמה כמו באתר StayAble.';

  @override
  String get loginCreateTitle => 'יצירת משתמש';

  @override
  String get loginCreateLead =>
      'המשתמש נשאר במכשיר הזה. זה לא חשבון מאמן בשרת.';

  @override
  String get loginCreateAction => 'יצירת משתמש';

  @override
  String get loginName => 'שם';

  @override
  String get loginNameRequired => 'הזינו שם';

  @override
  String get loginEmail => 'אימייל';

  @override
  String get loginPassword => 'סיסמה';

  @override
  String get loginEmailRequired => 'הזינו אימייל';

  @override
  String get loginPasswordRequired => 'הזינו סיסמה';

  @override
  String get loginPasswordShort => 'לפחות 6 תווים.';

  @override
  String get loginAction => 'התחברות';

  @override
  String get loginErrorEmailTaken => 'לאימייל הזה כבר יש משתמש במכשיר.';

  @override
  String get loginSubmitting => 'מתחברים…';

  @override
  String get loginErrorCredentials => 'אימייל או סיסמה שגויים.';

  @override
  String get loginErrorNotAthlete =>
      'האפליקציה לספורטאים. מאמנים ומנהלים נכנסים באתר.';

  @override
  String get loginErrorInactive => 'החשבון אינו פעיל.';

  @override
  String get loginErrorNetwork => 'אין חיבור לשרת. האם ה־backend רץ?';

  @override
  String get loginErrorUnknown => 'ההתחברות נכשלה. נסו שוב.';

  @override
  String get loginErrorServer =>
      'הזינו כתובת שרת תקינה, למשל https://gym.example.com';

  @override
  String get logOut => 'התנתקות';

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String get serverUrl => 'אתר השרת';

  @override
  String get serverUrlHint =>
      'כתובת HTTPS של אתר StayAble. תוצאות האימון נשמרות שם.';

  @override
  String get serverUrlRequired => 'הזינו את כתובת אתר השרת';

  @override
  String get serverSave => 'שמירת כתובת';

  @override
  String get serverSaved => 'נשמר. אימונים חדשים יסונכרנו לאתר זה.';

  @override
  String get completeExercise => 'סיום';

  @override
  String get addNote => 'הוסף הערה';

  @override
  String get exerciseNoteHint => 'איך הרגשת, מה לשנות בפעם הבאה…';
}
