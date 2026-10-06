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
  String get workoutTypeLabel => 'Workout type';

  @override
  String get workoutTypeAll => 'All types';

  @override
  String get workoutTypeStrength => 'Strength';

  @override
  String get workoutTypeAerobic => 'Aerobic';

  @override
  String get workoutTypeHiit => 'HIIT';

  @override
  String get workoutTypeFunctional => 'Functional';

  @override
  String get filterAtHome => 'At home';

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
  String get setupTitle => 'Private or with an instructor?';

  @override
  String get setupLead =>
      'First choice: stay private on this device, or sign in as a user your instructor created on the server.';

  @override
  String get setupServerLead =>
      'You are a user on this StayAble site. Programs and results are stored there. You will not enter the address again at sign-in.';

  @override
  String get setupContinue => 'Continue';

  @override
  String get changeSetup => 'Change device setup';

  @override
  String get changeSetupHint =>
      'Choose private or instructor again. You will be signed out.';

  @override
  String get modeChooserTitle => 'How do you want to train?';

  @override
  String get modeChooserLead =>
      'Private on this device, or with an instructor on the server.';

  @override
  String get modeTrainerTitle => 'With an instructor';

  @override
  String get modeTrainerLead =>
      'Network. Your instructor created you as a user on the StayAble server. Programs and results are stored there.';

  @override
  String get modeTrainerAction => 'Continue with instructor';

  @override
  String get modeLocalTitle => 'Private';

  @override
  String get modeLocalLead =>
      'This device only. You are not a server user. You build your own program here.';

  @override
  String get modeLocalAction => 'Continue privately';

  @override
  String get setupLocalLoginTitle => 'Use a login on this device?';

  @override
  String get setupLocalLoginLead =>
      'A login keeps each person\'s programs private when more than one person uses StayAble. Skip it if you want to stay anonymous.';

  @override
  String get setupLocalLoginYesTitle => 'Use login';

  @override
  String get setupLocalLoginYesLead =>
      'Create a user on this device, or sign in. Programs stay here and are not mixed.';

  @override
  String get setupLocalLoginYesAction => 'Use login';

  @override
  String get setupLocalLoginNoTitle => 'No login';

  @override
  String get setupLocalLoginNoLead =>
      'Stay private. No account. Everyone on this device shares the same programs.';

  @override
  String get setupLocalLoginNoAction => 'Continue without login';

  @override
  String get loginLeadLocal =>
      'Create a user on this device, or sign in. Each person keeps their own programs here.';

  @override
  String get backToModes => 'Private or instructor';

  @override
  String get createProgram => 'Create program';

  @override
  String get createProgramHow =>
      'Build it yourself, or let StayAble use your trainee profile.';

  @override
  String get createProgramManualTitle => 'Manual';

  @override
  String get createProgramManualLead => 'Choose days and exercises yourself.';

  @override
  String get createProgramManualAction => 'Build it myself';

  @override
  String get createProgramWizardTitle => 'From profile';

  @override
  String get createProgramWizardLead =>
      'StayAble builds a program from your trainee profile. Update health, goals, and lifestyle there — not on each program.';

  @override
  String get createProgramWizardAction => 'Build from profile';

  @override
  String get createProgramWizardOffline =>
      'The wizard needs an internet connection to the StayAble server.';

  @override
  String get wizardTitle => 'Trainee profile';

  @override
  String get wizardLead =>
      'Age is only a starting point. Your trainee profile covers health, goals, fitness, lifestyle, and habits.';

  @override
  String get wizardVenue => 'Where will you train?';

  @override
  String get wizardType => 'What kind of program?';

  @override
  String get wizardAge => 'Age';

  @override
  String get wizardAgeRange => 'Age must be between 12 and 90.';

  @override
  String get birthday => 'Birthday';

  @override
  String get birthdayLead =>
      'Enter your birthday once. StayAble uses it to size programs and workouts.';

  @override
  String get birthdayRequired => 'Add your birthday to continue.';

  @override
  String get birthdaySave => 'Save birthday';

  @override
  String get birthdayChange => 'Change birthday';

  @override
  String get birthdayUnset => 'Not set';

  @override
  String get wizardStatus => 'Current fitness level';

  @override
  String get wizardGoals => 'Goals';

  @override
  String get wizardGoalsRequired => 'Choose at least one goal.';

  @override
  String get wizardPeriod => 'Schedule';

  @override
  String get wizardPeriodWeekly => 'Weekly';

  @override
  String get wizardPeriodWeeklyHint => 'Pick the days that repeat every week.';

  @override
  String get wizardDays => 'Training days';

  @override
  String get wizardPeriodDaily => 'Day by day';

  @override
  String get wizardPeriodDailyHint => 'A session for every day.';

  @override
  String get wizardPeriodOccasional => 'Occasional';

  @override
  String get wizardPeriodOccasionalHint =>
      'Available anytime. You choose when to start it.';

  @override
  String get scheduleAnytime => 'Anytime';

  @override
  String get wizardGenerate => 'Create program';

  @override
  String get wizardFailed =>
      'Could not create a program. Check the connection and try again.';

  @override
  String get wizardEmptyCatalog =>
      'Not enough matching exercises to build this program.';

  @override
  String get goalGeneralFitness => 'General fitness';

  @override
  String get goalStrength => 'Get stronger';

  @override
  String get goalMobility => 'Mobility';

  @override
  String get goalCardio => 'Cardio';

  @override
  String get goalWeightManagement => 'Weight management';

  @override
  String get goalBodyToning => 'Body toning';

  @override
  String get wizardNext => 'Next';

  @override
  String get wizardBack => 'Back';

  @override
  String wizardStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get wizardHealthTitle => 'Health and medical history';

  @override
  String get wizardHealthLead =>
      'This is the most important step. StayAble uses it to keep the program safer. It is not a medical diagnosis.';

  @override
  String get wizardHealthInjuries => 'Injuries or chronic pain';

  @override
  String get wizardHealthConditions => 'Medical conditions';

  @override
  String get wizardHealthMeds =>
      'Medications that affect heart rate, blood pressure, balance, or energy';

  @override
  String get wizardHealthClearance => 'A doctor should clear me before I train';

  @override
  String get wizardHealthNone => 'None of these';

  @override
  String get assessInjuryKnees => 'Knees';

  @override
  String get assessInjuryBack => 'Back';

  @override
  String get assessInjuryShoulders => 'Shoulders';

  @override
  String get assessInjuryOther => 'Other';

  @override
  String get assessConditionHeart => 'Heart disease';

  @override
  String get assessConditionBp => 'High blood pressure';

  @override
  String get assessConditionAsthma => 'Asthma';

  @override
  String get assessConditionDiabetes => 'Diabetes';

  @override
  String get assessConditionJoints => 'Joint disorders';

  @override
  String get wizardGoalsLead =>
      'What should this program work toward, and how fast?';

  @override
  String get wizardTimeline => 'When do you hope to see results?';

  @override
  String get assessTimelineSlow => 'Slow and steady';

  @override
  String get assessTimelineModerate => 'A few months';

  @override
  String get assessTimelineFast => 'As soon as possible';

  @override
  String get wizardPreferences => 'How do you prefer to train?';

  @override
  String get assessPrefFreeWeights => 'Free weights';

  @override
  String get assessPrefMachines => 'Machines';

  @override
  String get assessPrefFunctional => 'Functional training';

  @override
  String get assessPrefMixed => 'A mix';

  @override
  String get wizardFitnessTitle => 'Current fitness and experience';

  @override
  String get wizardFitnessLead =>
      'Starting point, work life, and how you move.';

  @override
  String get wizardBackground =>
      'Are you starting from scratch or returning to fitness?';

  @override
  String get assessBackgroundStarting => 'Starting from scratch';

  @override
  String get assessBackgroundReturning => 'Returning to fitness';

  @override
  String get assessBackgroundCurrent => 'Already training';

  @override
  String get wizardOccupation => 'Daily occupation';

  @override
  String get assessOccupationSedentary => 'Mostly sitting';

  @override
  String get assessOccupationMixed => 'A mix of sitting and moving';

  @override
  String get assessOccupationPhysical => 'Physically demanding';

  @override
  String get wizardMobility => 'Mobility, flexibility, and core stability';

  @override
  String get assessMobilityLimited => 'Limited';

  @override
  String get assessMobilityAverage => 'Average';

  @override
  String get assessMobilityGood => 'Good';

  @override
  String get wizardLifestyleTitle => 'Availability and lifestyle';

  @override
  String get wizardLifestyleLead =>
      'How many days, how long, and how you recover.';

  @override
  String get wizardSessionMinutes => 'Minutes per session';

  @override
  String get wizardSleepHours => 'Hours of sleep';

  @override
  String get wizardStress => 'Daily stress';

  @override
  String get assessStressLow => 'Low';

  @override
  String get assessStressModerate => 'Moderate';

  @override
  String get assessStressHigh => 'High';

  @override
  String get wizardNutritionTitle => 'Nutrition and habits';

  @override
  String get wizardNutritionLead =>
      'Food and lifestyle habits that affect stamina and recovery.';

  @override
  String get wizardDiet => 'Eating pattern';

  @override
  String get assessDietRegular => 'Regular meals';

  @override
  String get assessDietPlan => 'A specific meal plan';

  @override
  String get assessDietSkip => 'I often skip meals';

  @override
  String get wizardHabits => 'Smoking or alcohol';

  @override
  String get assessHabitNone => 'Neither';

  @override
  String get assessHabitSmoking => 'Smoking';

  @override
  String get assessHabitAlcohol => 'Alcohol';

  @override
  String get assessHabitBoth => 'Both';

  @override
  String get wizardProgramTitle => 'Program shape';

  @override
  String get wizardProgramLead =>
      'Last choices: where you train and what kind of sessions to build.';

  @override
  String get wizardSaveAssessment => 'Save assessment';

  @override
  String get wizardAssessmentSaved => 'Assessment saved';

  @override
  String get assessTitle => 'Trainee profile';

  @override
  String get assessChange => 'Edit trainee profile';

  @override
  String get assessUnset => 'Not completed yet';

  @override
  String get editProgram => 'Edit';

  @override
  String get deleteProgram => 'Delete';

  @override
  String get deleteProgramConfirm =>
      'Delete this program? Past workouts stay in History.';

  @override
  String get programName => 'Program name';

  @override
  String get programNameRequired => 'Enter a program name';

  @override
  String get saveProgram => 'Save program';

  @override
  String get programSaved => 'Program saved';

  @override
  String get addExercise => 'Add exercise';

  @override
  String get selectDays => 'Choose at least one weekday';

  @override
  String get programNeedsExercise => 'Add at least one exercise';

  @override
  String get timedExercise => 'Timed';

  @override
  String get repsExercise => 'Reps';

  @override
  String get removeExercise => 'Remove';

  @override
  String get reorderExercise => 'Drag to reorder';

  @override
  String get catalogRefresh => 'Refresh exercise catalog';

  @override
  String get catalogRefreshed => 'Catalog updated';

  @override
  String get catalogRefreshFailed =>
      'Could not refresh the catalog. Check the server address.';

  @override
  String get serverUrlHintLocal =>
      'HTTPS address of the StayAble site. The public exercise list is downloaded from there.';

  @override
  String get catalogWeeklyHint =>
      'StayAble checks the default server about once a week for new exercises. You can also refresh the list here.';

  @override
  String get catalogUpdateBadge => 'New exercises';

  @override
  String catalogUpdateAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new exercises are available.',
      one: 'A new exercise is available.',
    );
    return '$_temp0';
  }

  @override
  String get catalogUpdateChanged => 'Updated exercises are available.';

  @override
  String get catalogSyncNow => 'Sync exercises';

  @override
  String get catalogUpdateLater => 'Later';

  @override
  String get appModeLocal => 'Private';

  @override
  String get appModeCloud => 'With an instructor';

  @override
  String get noProgramLocal =>
      'No program yet. Create one from the exercise catalog.';

  @override
  String get chooseTags => 'Filter by tags';

  @override
  String get loginTitle => 'Log in to train';

  @override
  String get loginLead =>
      'Trainees only. Use the same email and password as the StayAble website.';

  @override
  String get loginCreateTitle => 'Create user';

  @override
  String get loginCreateLead =>
      'This user stays on this device. It is not an instructor account on the server.';

  @override
  String get loginCreateAction => 'Create user';

  @override
  String get loginName => 'Name';

  @override
  String get loginNameRequired => 'Enter a name';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginEmailRequired => 'Enter your email';

  @override
  String get loginPasswordRequired => 'Enter your password';

  @override
  String get loginPasswordShort => 'Use at least 6 characters.';

  @override
  String get loginAction => 'Log in';

  @override
  String get loginErrorEmailTaken =>
      'This email already has a user on this device.';

  @override
  String get loginSubmitting => 'Signing in…';

  @override
  String get loginErrorCredentials => 'Email or password is wrong.';

  @override
  String get loginErrorNotAthlete =>
      'This app is for trainees. Instructors and admins use the website.';

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
