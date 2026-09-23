// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StayAble';

  @override
  String get navHome => 'Home';

  @override
  String get navExercises => 'Exercises';

  @override
  String get navProgram => 'Program';

  @override
  String get navHistory => 'History';

  @override
  String get languageToggle => 'Language';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get todaysWorkout => 'Today\'s workout';

  @override
  String get startWorkout => 'Start workout';

  @override
  String get resumeWorkout => 'Resume workout';

  @override
  String get inProgress => 'In progress';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get workouts => 'Workouts';

  @override
  String get workoutTime => 'Workout time';

  @override
  String get exercisesLabel => 'Exercises';

  @override
  String get completion => 'Completion';

  @override
  String get minutes => 'minutes';

  @override
  String get minutesShort => 'min';

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get search => 'Search';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryWarmUp => 'Warm-up';

  @override
  String get categoryMobility => 'Mobility';

  @override
  String get categoryStrength => 'Strength';

  @override
  String get categoryCardio => 'Cardio';

  @override
  String get categoryStretching => 'Stretching';

  @override
  String get categoryCoolDown => 'Cool-down';

  @override
  String get difficultyBeginner => 'Beginner';

  @override
  String get difficultyIntermediate => 'Intermediate';

  @override
  String get difficultyAdvanced => 'Advanced';

  @override
  String get howToPerform => 'How to perform';

  @override
  String get targetMuscles => 'Target muscles';

  @override
  String get equipment => 'Equipment';

  @override
  String get description => 'Description';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get safetyNotes => 'Safety notes';

  @override
  String get equipmentNone => 'None';

  @override
  String get equipmentMat => 'Mat';

  @override
  String get equipmentResistanceBand => 'Resistance band';

  @override
  String get equipmentDumbbells => 'Dumbbells';

  @override
  String get equipmentChair => 'Chair';

  @override
  String get equipmentMachine => 'Machine';

  @override
  String get equipmentBarbell => 'Barbell';

  @override
  String get equipmentCable => 'Cable';

  @override
  String get equipmentKettlebell => 'Kettlebell';

  @override
  String get equipmentBench => 'Bench';

  @override
  String get venueHome => 'Home';

  @override
  String get venueGym => 'Gym';

  @override
  String get venueBoth => 'Home + gym';

  @override
  String get venueMixed => 'Mixed';

  @override
  String gymStation(int n) {
    return 'Station #$n';
  }

  @override
  String get kg => 'kg';

  @override
  String get load => 'Load';

  @override
  String get myProgram => 'My program';

  @override
  String get myPrograms => 'My programs';

  @override
  String get weeklyProgram => 'Weekly program';

  @override
  String get noProgramAssigned => 'No program assigned yet';

  @override
  String get completed => 'Completed';

  @override
  String get today => 'Today';

  @override
  String get upcoming => 'Upcoming';

  @override
  String exerciseProgress(int current, int total) {
    return 'Exercise $current / $total';
  }

  @override
  String get chooseExercise => 'Choose an exercise';

  @override
  String get chooseAnother => 'Choose another';

  @override
  String exercisesDone(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get reps => 'reps';

  @override
  String get sets => 'sets';

  @override
  String get rest => 'Rest';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get howDidYouDo => 'How did you do?';

  @override
  String get effortEasy => 'Easy';

  @override
  String get effortGood => 'Good';

  @override
  String get effortDifficult => 'Difficult';

  @override
  String get continueLabel => 'Continue';

  @override
  String get history => 'History';

  @override
  String get restDay => 'Rest day';

  @override
  String get restDayMessage =>
      'No workout is scheduled for today. Recover, or browse the program.';

  @override
  String get viewProgram => 'View program';

  @override
  String get partiallyCompleted => 'Partially completed';

  @override
  String get skipped => 'Skipped';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get planned => 'Planned';

  @override
  String get started => 'Started';

  @override
  String setNumber(int n) {
    return 'Set $n';
  }

  @override
  String get seconds => 'sec';

  @override
  String get noHistory => 'No workouts yet. Start today\'s session from Home.';

  @override
  String get noExercises => 'No exercises match that search.';

  @override
  String get endWorkout => 'End workout';

  @override
  String get workoutComplete => 'Workout complete';

  @override
  String get seeHistory => 'See history';

  @override
  String get start => 'Start';

  @override
  String get nextSet => 'Next set';

  @override
  String get confirmSet => 'Log set';

  @override
  String get weekdayMon => 'Monday';

  @override
  String get weekdayTue => 'Tuesday';

  @override
  String get weekdayWed => 'Wednesday';

  @override
  String get weekdayThu => 'Thursday';

  @override
  String get weekdayFri => 'Friday';

  @override
  String get weekdaySat => 'Saturday';

  @override
  String get weekdaySun => 'Sunday';

  @override
  String get muscleQuadriceps => 'Quadriceps';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleHamstrings => 'Hamstrings';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleHipFlexors => 'Hip flexors';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleFullBody => 'Full body';

  @override
  String get muscleCardiovascular => 'Cardiovascular';

  @override
  String get muscleHipMobility => 'Hips';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String exerciseCount(int count) {
    return '$count exercises';
  }

  @override
  String prescriptionSetsReps(int sets, int reps) {
    return '$sets × $reps';
  }

  @override
  String prescriptionDuration(int seconds) {
    return '$seconds sec';
  }

  @override
  String prescriptionMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get alreadyCompletedToday => 'Completed today';

  @override
  String get startAgain => 'Start again';

  @override
  String get exitWorkoutTitle => 'End this workout?';

  @override
  String get exitWorkoutBody =>
      'Unfinished exercises will be saved as a partial session.';

  @override
  String get cancel => 'Cancel';

  @override
  String get savePartial => 'Save partial';

  @override
  String get close => 'Close';

  @override
  String get loginTitle => 'Log in to train';

  @override
  String get loginLead =>
      'Athletes only. Use the same email and password as the StayAble website.';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginEmailRequired => 'Enter your email';

  @override
  String get loginPasswordRequired => 'Enter your password';

  @override
  String get loginAction => 'Log in';

  @override
  String get loginSubmitting => 'Signing in…';

  @override
  String get loginErrorCredentials => 'Email or password is wrong.';

  @override
  String get loginErrorNotAthlete =>
      'This app is for athletes. Trainers and admins use the website.';

  @override
  String get loginErrorInactive => 'This account is inactive.';

  @override
  String get loginErrorNetwork =>
      'Cannot reach the server. Is the backend running?';

  @override
  String get loginErrorUnknown => 'Could not sign in. Try again.';

  @override
  String get loginErrorServer =>
      'Enter a valid server address, like https://gym.example.com';

  @override
  String get logOut => 'Log out';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get serverUrl => 'Backend site';

  @override
  String get serverUrlHint =>
      'HTTPS address of the StayAble site. Workout results are stored there.';

  @override
  String get serverUrlRequired => 'Enter the backend site address';

  @override
  String get serverSave => 'Save address';

  @override
  String get serverSaved => 'Saved. New workouts will sync to this site.';

  @override
  String get completeExercise => 'Complete';

  @override
  String get addNote => 'Add note';

  @override
  String get exerciseNoteHint => 'How it felt, what to change next time…';
}
