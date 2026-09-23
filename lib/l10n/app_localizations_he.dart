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
  String get loginTitle => 'התחברו כדי להתאמן';

  @override
  String get loginLead =>
      'לספורטאים בלבד. אותו אימייל וסיסמה כמו באתר StayAble.';

  @override
  String get loginEmail => 'אימייל';

  @override
  String get loginPassword => 'סיסמה';

  @override
  String get loginEmailRequired => 'הזינו אימייל';

  @override
  String get loginPasswordRequired => 'הזינו סיסמה';

  @override
  String get loginAction => 'התחברות';

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
