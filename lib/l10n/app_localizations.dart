import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'StayAble'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get navExercises;

  /// No description provided for @navProgram.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get navProgram;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @languageToggle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageToggle;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @todaysWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get todaysWorkout;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get startWorkout;

  /// No description provided for @resumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Resume workout'**
  String get resumeWorkout;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// No description provided for @workoutTime.
  ///
  /// In en, this message translates to:
  /// **'Workout time'**
  String get workoutTime;

  /// No description provided for @exercisesLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesLabel;

  /// No description provided for @completion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @hoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String hoursMinutes(int hours, int minutes);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryWarmUp.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get categoryWarmUp;

  /// No description provided for @categoryMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get categoryMobility;

  /// No description provided for @categoryStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get categoryStrength;

  /// No description provided for @categoryCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get categoryCardio;

  /// No description provided for @categoryStretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching'**
  String get categoryStretching;

  /// No description provided for @categoryCoolDown.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get categoryCoolDown;

  /// No description provided for @workoutTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Workout type'**
  String get workoutTypeLabel;

  /// No description provided for @workoutTypeAll.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get workoutTypeAll;

  /// No description provided for @workoutTypeStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get workoutTypeStrength;

  /// No description provided for @workoutTypeAerobic.
  ///
  /// In en, this message translates to:
  /// **'Aerobic'**
  String get workoutTypeAerobic;

  /// No description provided for @workoutTypeHiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get workoutTypeHiit;

  /// No description provided for @workoutTypeFunctional.
  ///
  /// In en, this message translates to:
  /// **'Functional'**
  String get workoutTypeFunctional;

  /// No description provided for @filterAtHome.
  ///
  /// In en, this message translates to:
  /// **'At home'**
  String get filterAtHome;

  /// No description provided for @difficultyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get difficultyBeginner;

  /// No description provided for @difficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get difficultyIntermediate;

  /// No description provided for @difficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get difficultyAdvanced;

  /// No description provided for @howToPerform.
  ///
  /// In en, this message translates to:
  /// **'How to perform'**
  String get howToPerform;

  /// No description provided for @targetMuscles.
  ///
  /// In en, this message translates to:
  /// **'Target muscles'**
  String get targetMuscles;

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @safetyNotes.
  ///
  /// In en, this message translates to:
  /// **'Safety notes'**
  String get safetyNotes;

  /// No description provided for @equipmentNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get equipmentNone;

  /// No description provided for @equipmentMat.
  ///
  /// In en, this message translates to:
  /// **'Mat'**
  String get equipmentMat;

  /// No description provided for @equipmentResistanceBand.
  ///
  /// In en, this message translates to:
  /// **'Resistance band'**
  String get equipmentResistanceBand;

  /// No description provided for @equipmentDumbbells.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get equipmentDumbbells;

  /// No description provided for @equipmentChair.
  ///
  /// In en, this message translates to:
  /// **'Chair'**
  String get equipmentChair;

  /// No description provided for @equipmentMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get equipmentMachine;

  /// No description provided for @equipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get equipmentBarbell;

  /// No description provided for @equipmentCable.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get equipmentCable;

  /// No description provided for @equipmentKettlebell.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get equipmentKettlebell;

  /// No description provided for @equipmentBench.
  ///
  /// In en, this message translates to:
  /// **'Bench'**
  String get equipmentBench;

  /// No description provided for @venueHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get venueHome;

  /// No description provided for @venueGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get venueGym;

  /// No description provided for @venueBoth.
  ///
  /// In en, this message translates to:
  /// **'Home + gym'**
  String get venueBoth;

  /// No description provided for @venueMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get venueMixed;

  /// No description provided for @gymStation.
  ///
  /// In en, this message translates to:
  /// **'Station #{n}'**
  String gymStation(int n);

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @load.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// No description provided for @myProgram.
  ///
  /// In en, this message translates to:
  /// **'My program'**
  String get myProgram;

  /// No description provided for @myPrograms.
  ///
  /// In en, this message translates to:
  /// **'My programs'**
  String get myPrograms;

  /// No description provided for @weeklyProgram.
  ///
  /// In en, this message translates to:
  /// **'Weekly program'**
  String get weeklyProgram;

  /// No description provided for @noProgramAssigned.
  ///
  /// In en, this message translates to:
  /// **'No program assigned yet'**
  String get noProgramAssigned;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @exerciseProgress.
  ///
  /// In en, this message translates to:
  /// **'Exercise {current} / {total}'**
  String exerciseProgress(int current, int total);

  /// No description provided for @chooseExercise.
  ///
  /// In en, this message translates to:
  /// **'Choose an exercise'**
  String get chooseExercise;

  /// No description provided for @chooseAnother.
  ///
  /// In en, this message translates to:
  /// **'Choose another'**
  String get chooseAnother;

  /// No description provided for @exercisesDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String exercisesDone(int done, int total);

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get reps;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'sets'**
  String get sets;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get rest;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @howDidYouDo.
  ///
  /// In en, this message translates to:
  /// **'How did you do?'**
  String get howDidYouDo;

  /// No description provided for @effortEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get effortEasy;

  /// No description provided for @effortGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get effortGood;

  /// No description provided for @effortDifficult.
  ///
  /// In en, this message translates to:
  /// **'Difficult'**
  String get effortDifficult;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @restDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get restDay;

  /// No description provided for @restDayMessage.
  ///
  /// In en, this message translates to:
  /// **'No workout is scheduled for today. Recover, or browse the program.'**
  String get restDayMessage;

  /// No description provided for @viewProgram.
  ///
  /// In en, this message translates to:
  /// **'View program'**
  String get viewProgram;

  /// No description provided for @partiallyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Partially completed'**
  String get partiallyCompleted;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @planned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get planned;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @setNumber.
  ///
  /// In en, this message translates to:
  /// **'Set {n}'**
  String setNumber(int n);

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get seconds;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet. Start today\'s session from Home.'**
  String get noHistory;

  /// No description provided for @noExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises match that search.'**
  String get noExercises;

  /// No description provided for @endWorkout.
  ///
  /// In en, this message translates to:
  /// **'End workout'**
  String get endWorkout;

  /// No description provided for @workoutComplete.
  ///
  /// In en, this message translates to:
  /// **'Workout complete'**
  String get workoutComplete;

  /// No description provided for @seeHistory.
  ///
  /// In en, this message translates to:
  /// **'See history'**
  String get seeHistory;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @nextSet.
  ///
  /// In en, this message translates to:
  /// **'Next set'**
  String get nextSet;

  /// No description provided for @confirmSet.
  ///
  /// In en, this message translates to:
  /// **'Log set'**
  String get confirmSet;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySun;

  /// No description provided for @muscleQuadriceps.
  ///
  /// In en, this message translates to:
  /// **'Quadriceps'**
  String get muscleQuadriceps;

  /// No description provided for @muscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @muscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get muscleHamstrings;

  /// No description provided for @muscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// No description provided for @muscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// No description provided for @muscleCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// No description provided for @muscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// No description provided for @muscleHipFlexors.
  ///
  /// In en, this message translates to:
  /// **'Hip flexors'**
  String get muscleHipFlexors;

  /// No description provided for @muscleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleBack;

  /// No description provided for @muscleFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get muscleFullBody;

  /// No description provided for @muscleCardiovascular.
  ///
  /// In en, this message translates to:
  /// **'Cardiovascular'**
  String get muscleCardiovascular;

  /// No description provided for @muscleHipMobility.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get muscleHipMobility;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(int value);

  /// No description provided for @exerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String exerciseCount(int count);

  /// No description provided for @prescriptionSetsReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {reps}'**
  String prescriptionSetsReps(int sets, int reps);

  /// No description provided for @prescriptionDuration.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec'**
  String prescriptionDuration(int seconds);

  /// No description provided for @prescriptionMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String prescriptionMinutes(int minutes);

  /// No description provided for @alreadyCompletedToday.
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get alreadyCompletedToday;

  /// No description provided for @startAgain.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get startAgain;

  /// No description provided for @exitWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'End this workout?'**
  String get exitWorkoutTitle;

  /// No description provided for @exitWorkoutBody.
  ///
  /// In en, this message translates to:
  /// **'Unfinished exercises will be saved as a partial session.'**
  String get exitWorkoutBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @savePartial.
  ///
  /// In en, this message translates to:
  /// **'Save partial'**
  String get savePartial;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Private or with an instructor?'**
  String get setupTitle;

  /// No description provided for @setupLead.
  ///
  /// In en, this message translates to:
  /// **'First choice: stay private on this device, or sign in as a user your instructor created on the server.'**
  String get setupLead;

  /// No description provided for @setupServerLead.
  ///
  /// In en, this message translates to:
  /// **'You are a user on this StayAble site. Programs and results are stored there. You will not enter the address again at sign-in.'**
  String get setupServerLead;

  /// No description provided for @setupContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get setupContinue;

  /// No description provided for @changeSetup.
  ///
  /// In en, this message translates to:
  /// **'Change device setup'**
  String get changeSetup;

  /// No description provided for @changeSetupHint.
  ///
  /// In en, this message translates to:
  /// **'Choose private or instructor again. You will be signed out.'**
  String get changeSetupHint;

  /// No description provided for @modeChooserTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to train?'**
  String get modeChooserTitle;

  /// No description provided for @modeChooserLead.
  ///
  /// In en, this message translates to:
  /// **'Private on this device, or with an instructor on the server.'**
  String get modeChooserLead;

  /// No description provided for @modeTrainerTitle.
  ///
  /// In en, this message translates to:
  /// **'With an instructor'**
  String get modeTrainerTitle;

  /// No description provided for @modeTrainerLead.
  ///
  /// In en, this message translates to:
  /// **'Network. Your instructor created you as a user on the StayAble server. Programs and results are stored there.'**
  String get modeTrainerLead;

  /// No description provided for @modeTrainerAction.
  ///
  /// In en, this message translates to:
  /// **'Continue with instructor'**
  String get modeTrainerAction;

  /// No description provided for @modeLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get modeLocalTitle;

  /// No description provided for @modeLocalLead.
  ///
  /// In en, this message translates to:
  /// **'This device only. You are not a server user. You build your own program here.'**
  String get modeLocalLead;

  /// No description provided for @modeLocalAction.
  ///
  /// In en, this message translates to:
  /// **'Continue privately'**
  String get modeLocalAction;

  /// No description provided for @setupLocalLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Use a login on this device?'**
  String get setupLocalLoginTitle;

  /// No description provided for @setupLocalLoginLead.
  ///
  /// In en, this message translates to:
  /// **'A login keeps each person\'s programs private when more than one person uses StayAble. Skip it if you want to stay anonymous.'**
  String get setupLocalLoginLead;

  /// No description provided for @setupLocalLoginYesTitle.
  ///
  /// In en, this message translates to:
  /// **'Use login'**
  String get setupLocalLoginYesTitle;

  /// No description provided for @setupLocalLoginYesLead.
  ///
  /// In en, this message translates to:
  /// **'Create a user on this device, or sign in. Programs stay here and are not mixed.'**
  String get setupLocalLoginYesLead;

  /// No description provided for @setupLocalLoginYesAction.
  ///
  /// In en, this message translates to:
  /// **'Use login'**
  String get setupLocalLoginYesAction;

  /// No description provided for @setupLocalLoginNoTitle.
  ///
  /// In en, this message translates to:
  /// **'No login'**
  String get setupLocalLoginNoTitle;

  /// No description provided for @setupLocalLoginNoLead.
  ///
  /// In en, this message translates to:
  /// **'Stay private. No account. Everyone on this device shares the same programs.'**
  String get setupLocalLoginNoLead;

  /// No description provided for @setupLocalLoginNoAction.
  ///
  /// In en, this message translates to:
  /// **'Continue without login'**
  String get setupLocalLoginNoAction;

  /// No description provided for @loginLeadLocal.
  ///
  /// In en, this message translates to:
  /// **'Create a user on this device, or sign in. Each person keeps their own programs here.'**
  String get loginLeadLocal;

  /// No description provided for @backToModes.
  ///
  /// In en, this message translates to:
  /// **'Private or instructor'**
  String get backToModes;

  /// No description provided for @createProgram.
  ///
  /// In en, this message translates to:
  /// **'Create program'**
  String get createProgram;

  /// No description provided for @createProgramHow.
  ///
  /// In en, this message translates to:
  /// **'Build it yourself, or let StayAble use your trainee profile.'**
  String get createProgramHow;

  /// No description provided for @createProgramManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get createProgramManualTitle;

  /// No description provided for @createProgramManualLead.
  ///
  /// In en, this message translates to:
  /// **'Choose days and exercises yourself.'**
  String get createProgramManualLead;

  /// No description provided for @createProgramManualAction.
  ///
  /// In en, this message translates to:
  /// **'Build it myself'**
  String get createProgramManualAction;

  /// No description provided for @createProgramWizardTitle.
  ///
  /// In en, this message translates to:
  /// **'From profile'**
  String get createProgramWizardTitle;

  /// No description provided for @createProgramWizardLead.
  ///
  /// In en, this message translates to:
  /// **'StayAble builds a program from your trainee profile. Update health, goals, and lifestyle there — not on each program.'**
  String get createProgramWizardLead;

  /// No description provided for @createProgramWizardAction.
  ///
  /// In en, this message translates to:
  /// **'Build from profile'**
  String get createProgramWizardAction;

  /// No description provided for @createProgramWizardOffline.
  ///
  /// In en, this message translates to:
  /// **'The wizard needs an internet connection to the StayAble server.'**
  String get createProgramWizardOffline;

  /// No description provided for @wizardTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainee profile'**
  String get wizardTitle;

  /// No description provided for @wizardLead.
  ///
  /// In en, this message translates to:
  /// **'Age is only a starting point. Your trainee profile covers health, goals, fitness, lifestyle, and habits.'**
  String get wizardLead;

  /// No description provided for @wizardVenue.
  ///
  /// In en, this message translates to:
  /// **'Where will you train?'**
  String get wizardVenue;

  /// No description provided for @wizardType.
  ///
  /// In en, this message translates to:
  /// **'What kind of program?'**
  String get wizardType;

  /// No description provided for @wizardAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get wizardAge;

  /// No description provided for @wizardAgeRange.
  ///
  /// In en, this message translates to:
  /// **'Age must be between 12 and 90.'**
  String get wizardAgeRange;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @birthdayLead.
  ///
  /// In en, this message translates to:
  /// **'Enter your birthday once. StayAble uses it to size programs and workouts.'**
  String get birthdayLead;

  /// No description provided for @birthdayRequired.
  ///
  /// In en, this message translates to:
  /// **'Add your birthday to continue.'**
  String get birthdayRequired;

  /// No description provided for @birthdaySave.
  ///
  /// In en, this message translates to:
  /// **'Save birthday'**
  String get birthdaySave;

  /// No description provided for @birthdayChange.
  ///
  /// In en, this message translates to:
  /// **'Change birthday'**
  String get birthdayChange;

  /// No description provided for @birthdayUnset.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get birthdayUnset;

  /// No description provided for @wizardStatus.
  ///
  /// In en, this message translates to:
  /// **'Current fitness level'**
  String get wizardStatus;

  /// No description provided for @wizardGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get wizardGoals;

  /// No description provided for @wizardGoalsRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one goal.'**
  String get wizardGoalsRequired;

  /// No description provided for @wizardPeriod.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get wizardPeriod;

  /// No description provided for @wizardPeriodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get wizardPeriodWeekly;

  /// No description provided for @wizardPeriodWeeklyHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the days that repeat every week.'**
  String get wizardPeriodWeeklyHint;

  /// No description provided for @wizardDays.
  ///
  /// In en, this message translates to:
  /// **'Training days'**
  String get wizardDays;

  /// No description provided for @wizardPeriodDaily.
  ///
  /// In en, this message translates to:
  /// **'Day by day'**
  String get wizardPeriodDaily;

  /// No description provided for @wizardPeriodDailyHint.
  ///
  /// In en, this message translates to:
  /// **'A session for every day.'**
  String get wizardPeriodDailyHint;

  /// No description provided for @wizardPeriodOccasional.
  ///
  /// In en, this message translates to:
  /// **'Occasional'**
  String get wizardPeriodOccasional;

  /// No description provided for @wizardPeriodOccasionalHint.
  ///
  /// In en, this message translates to:
  /// **'Available anytime. You choose when to start it.'**
  String get wizardPeriodOccasionalHint;

  /// No description provided for @scheduleAnytime.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get scheduleAnytime;

  /// No description provided for @wizardGenerate.
  ///
  /// In en, this message translates to:
  /// **'Create program'**
  String get wizardGenerate;

  /// No description provided for @wizardFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create a program. Check the connection and try again.'**
  String get wizardFailed;

  /// No description provided for @wizardEmptyCatalog.
  ///
  /// In en, this message translates to:
  /// **'Not enough matching exercises to build this program.'**
  String get wizardEmptyCatalog;

  /// No description provided for @goalGeneralFitness.
  ///
  /// In en, this message translates to:
  /// **'General fitness'**
  String get goalGeneralFitness;

  /// No description provided for @goalStrength.
  ///
  /// In en, this message translates to:
  /// **'Get stronger'**
  String get goalStrength;

  /// No description provided for @goalMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get goalMobility;

  /// No description provided for @goalCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get goalCardio;

  /// No description provided for @goalWeightManagement.
  ///
  /// In en, this message translates to:
  /// **'Weight management'**
  String get goalWeightManagement;

  /// No description provided for @goalBodyToning.
  ///
  /// In en, this message translates to:
  /// **'Body toning'**
  String get goalBodyToning;

  /// No description provided for @wizardNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get wizardNext;

  /// No description provided for @wizardBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get wizardBack;

  /// No description provided for @wizardStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String wizardStepOf(int current, int total);

  /// No description provided for @wizardHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health and medical history'**
  String get wizardHealthTitle;

  /// No description provided for @wizardHealthLead.
  ///
  /// In en, this message translates to:
  /// **'This is the most important step. StayAble uses it to keep the program safer. It is not a medical diagnosis.'**
  String get wizardHealthLead;

  /// No description provided for @wizardHealthInjuries.
  ///
  /// In en, this message translates to:
  /// **'Injuries or chronic pain'**
  String get wizardHealthInjuries;

  /// No description provided for @wizardHealthConditions.
  ///
  /// In en, this message translates to:
  /// **'Medical conditions'**
  String get wizardHealthConditions;

  /// No description provided for @wizardHealthMeds.
  ///
  /// In en, this message translates to:
  /// **'Medications that affect heart rate, blood pressure, balance, or energy'**
  String get wizardHealthMeds;

  /// No description provided for @wizardHealthClearance.
  ///
  /// In en, this message translates to:
  /// **'A doctor should clear me before I train'**
  String get wizardHealthClearance;

  /// No description provided for @wizardHealthNone.
  ///
  /// In en, this message translates to:
  /// **'None of these'**
  String get wizardHealthNone;

  /// No description provided for @assessInjuryKnees.
  ///
  /// In en, this message translates to:
  /// **'Knees'**
  String get assessInjuryKnees;

  /// No description provided for @assessInjuryBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get assessInjuryBack;

  /// No description provided for @assessInjuryShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get assessInjuryShoulders;

  /// No description provided for @assessInjuryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get assessInjuryOther;

  /// No description provided for @assessConditionHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart disease'**
  String get assessConditionHeart;

  /// No description provided for @assessConditionBp.
  ///
  /// In en, this message translates to:
  /// **'High blood pressure'**
  String get assessConditionBp;

  /// No description provided for @assessConditionAsthma.
  ///
  /// In en, this message translates to:
  /// **'Asthma'**
  String get assessConditionAsthma;

  /// No description provided for @assessConditionDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get assessConditionDiabetes;

  /// No description provided for @assessConditionJoints.
  ///
  /// In en, this message translates to:
  /// **'Joint disorders'**
  String get assessConditionJoints;

  /// No description provided for @wizardGoalsLead.
  ///
  /// In en, this message translates to:
  /// **'What should this program work toward, and how fast?'**
  String get wizardGoalsLead;

  /// No description provided for @wizardTimeline.
  ///
  /// In en, this message translates to:
  /// **'When do you hope to see results?'**
  String get wizardTimeline;

  /// No description provided for @assessTimelineSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow and steady'**
  String get assessTimelineSlow;

  /// No description provided for @assessTimelineModerate.
  ///
  /// In en, this message translates to:
  /// **'A few months'**
  String get assessTimelineModerate;

  /// No description provided for @assessTimelineFast.
  ///
  /// In en, this message translates to:
  /// **'As soon as possible'**
  String get assessTimelineFast;

  /// No description provided for @wizardPreferences.
  ///
  /// In en, this message translates to:
  /// **'How do you prefer to train?'**
  String get wizardPreferences;

  /// No description provided for @assessPrefFreeWeights.
  ///
  /// In en, this message translates to:
  /// **'Free weights'**
  String get assessPrefFreeWeights;

  /// No description provided for @assessPrefMachines.
  ///
  /// In en, this message translates to:
  /// **'Machines'**
  String get assessPrefMachines;

  /// No description provided for @assessPrefFunctional.
  ///
  /// In en, this message translates to:
  /// **'Functional training'**
  String get assessPrefFunctional;

  /// No description provided for @assessPrefMixed.
  ///
  /// In en, this message translates to:
  /// **'A mix'**
  String get assessPrefMixed;

  /// No description provided for @wizardFitnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Current fitness and experience'**
  String get wizardFitnessTitle;

  /// No description provided for @wizardFitnessLead.
  ///
  /// In en, this message translates to:
  /// **'Starting point, work life, and how you move.'**
  String get wizardFitnessLead;

  /// No description provided for @wizardBackground.
  ///
  /// In en, this message translates to:
  /// **'Are you starting from scratch or returning to fitness?'**
  String get wizardBackground;

  /// No description provided for @assessBackgroundStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting from scratch'**
  String get assessBackgroundStarting;

  /// No description provided for @assessBackgroundReturning.
  ///
  /// In en, this message translates to:
  /// **'Returning to fitness'**
  String get assessBackgroundReturning;

  /// No description provided for @assessBackgroundCurrent.
  ///
  /// In en, this message translates to:
  /// **'Already training'**
  String get assessBackgroundCurrent;

  /// No description provided for @wizardOccupation.
  ///
  /// In en, this message translates to:
  /// **'Daily occupation'**
  String get wizardOccupation;

  /// No description provided for @assessOccupationSedentary.
  ///
  /// In en, this message translates to:
  /// **'Mostly sitting'**
  String get assessOccupationSedentary;

  /// No description provided for @assessOccupationMixed.
  ///
  /// In en, this message translates to:
  /// **'A mix of sitting and moving'**
  String get assessOccupationMixed;

  /// No description provided for @assessOccupationPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physically demanding'**
  String get assessOccupationPhysical;

  /// No description provided for @wizardMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility, flexibility, and core stability'**
  String get wizardMobility;

  /// No description provided for @assessMobilityLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get assessMobilityLimited;

  /// No description provided for @assessMobilityAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get assessMobilityAverage;

  /// No description provided for @assessMobilityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get assessMobilityGood;

  /// No description provided for @wizardLifestyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Availability and lifestyle'**
  String get wizardLifestyleTitle;

  /// No description provided for @wizardLifestyleLead.
  ///
  /// In en, this message translates to:
  /// **'How many days, how long, and how you recover.'**
  String get wizardLifestyleLead;

  /// No description provided for @wizardSessionMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes per session'**
  String get wizardSessionMinutes;

  /// No description provided for @wizardSleepHours.
  ///
  /// In en, this message translates to:
  /// **'Hours of sleep'**
  String get wizardSleepHours;

  /// No description provided for @wizardStress.
  ///
  /// In en, this message translates to:
  /// **'Daily stress'**
  String get wizardStress;

  /// No description provided for @assessStressLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get assessStressLow;

  /// No description provided for @assessStressModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get assessStressModerate;

  /// No description provided for @assessStressHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get assessStressHigh;

  /// No description provided for @wizardNutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition and habits'**
  String get wizardNutritionTitle;

  /// No description provided for @wizardNutritionLead.
  ///
  /// In en, this message translates to:
  /// **'Food and lifestyle habits that affect stamina and recovery.'**
  String get wizardNutritionLead;

  /// No description provided for @wizardDiet.
  ///
  /// In en, this message translates to:
  /// **'Eating pattern'**
  String get wizardDiet;

  /// No description provided for @assessDietRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular meals'**
  String get assessDietRegular;

  /// No description provided for @assessDietPlan.
  ///
  /// In en, this message translates to:
  /// **'A specific meal plan'**
  String get assessDietPlan;

  /// No description provided for @assessDietSkip.
  ///
  /// In en, this message translates to:
  /// **'I often skip meals'**
  String get assessDietSkip;

  /// No description provided for @wizardHabits.
  ///
  /// In en, this message translates to:
  /// **'Smoking or alcohol'**
  String get wizardHabits;

  /// No description provided for @assessHabitNone.
  ///
  /// In en, this message translates to:
  /// **'Neither'**
  String get assessHabitNone;

  /// No description provided for @assessHabitSmoking.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get assessHabitSmoking;

  /// No description provided for @assessHabitAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get assessHabitAlcohol;

  /// No description provided for @assessHabitBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get assessHabitBoth;

  /// No description provided for @wizardProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Program shape'**
  String get wizardProgramTitle;

  /// No description provided for @wizardProgramLead.
  ///
  /// In en, this message translates to:
  /// **'Last choices: where you train and what kind of sessions to build.'**
  String get wizardProgramLead;

  /// No description provided for @wizardSaveAssessment.
  ///
  /// In en, this message translates to:
  /// **'Save assessment'**
  String get wizardSaveAssessment;

  /// No description provided for @wizardAssessmentSaved.
  ///
  /// In en, this message translates to:
  /// **'Assessment saved'**
  String get wizardAssessmentSaved;

  /// No description provided for @assessTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainee profile'**
  String get assessTitle;

  /// No description provided for @assessChange.
  ///
  /// In en, this message translates to:
  /// **'Edit trainee profile'**
  String get assessChange;

  /// No description provided for @assessUnset.
  ///
  /// In en, this message translates to:
  /// **'Not completed yet'**
  String get assessUnset;

  /// No description provided for @editProgram.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editProgram;

  /// No description provided for @deleteProgram.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteProgram;

  /// No description provided for @deleteProgramConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this program? Past workouts stay in History.'**
  String get deleteProgramConfirm;

  /// No description provided for @programName.
  ///
  /// In en, this message translates to:
  /// **'Program name'**
  String get programName;

  /// No description provided for @programNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a program name'**
  String get programNameRequired;

  /// No description provided for @saveProgram.
  ///
  /// In en, this message translates to:
  /// **'Save program'**
  String get saveProgram;

  /// No description provided for @programSaved.
  ///
  /// In en, this message translates to:
  /// **'Program saved'**
  String get programSaved;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExercise;

  /// No description provided for @selectDays.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one weekday'**
  String get selectDays;

  /// No description provided for @programNeedsExercise.
  ///
  /// In en, this message translates to:
  /// **'Add at least one exercise'**
  String get programNeedsExercise;

  /// No description provided for @timedExercise.
  ///
  /// In en, this message translates to:
  /// **'Timed'**
  String get timedExercise;

  /// No description provided for @repsExercise.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsExercise;

  /// No description provided for @removeExercise.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeExercise;

  /// No description provided for @reorderExercise.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get reorderExercise;

  /// No description provided for @catalogRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh exercise catalog'**
  String get catalogRefresh;

  /// No description provided for @catalogRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Catalog updated'**
  String get catalogRefreshed;

  /// No description provided for @catalogRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh the catalog. Check the server address.'**
  String get catalogRefreshFailed;

  /// No description provided for @serverUrlHintLocal.
  ///
  /// In en, this message translates to:
  /// **'HTTPS address of the StayAble site. The public exercise list is downloaded from there.'**
  String get serverUrlHintLocal;

  /// No description provided for @catalogWeeklyHint.
  ///
  /// In en, this message translates to:
  /// **'StayAble checks the default server about once a week for new exercises. You can also refresh the list here.'**
  String get catalogWeeklyHint;

  /// No description provided for @catalogUpdateBadge.
  ///
  /// In en, this message translates to:
  /// **'New exercises'**
  String get catalogUpdateBadge;

  /// No description provided for @catalogUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{A new exercise is available.} other{{count} new exercises are available.}}'**
  String catalogUpdateAvailable(int count);

  /// No description provided for @catalogUpdateChanged.
  ///
  /// In en, this message translates to:
  /// **'Updated exercises are available.'**
  String get catalogUpdateChanged;

  /// No description provided for @catalogSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync exercises'**
  String get catalogSyncNow;

  /// No description provided for @catalogUpdateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get catalogUpdateLater;

  /// No description provided for @appModeLocal.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get appModeLocal;

  /// No description provided for @appModeCloud.
  ///
  /// In en, this message translates to:
  /// **'With an instructor'**
  String get appModeCloud;

  /// No description provided for @noProgramLocal.
  ///
  /// In en, this message translates to:
  /// **'No program yet. Create one from the exercise catalog.'**
  String get noProgramLocal;

  /// No description provided for @chooseTags.
  ///
  /// In en, this message translates to:
  /// **'Filter by tags'**
  String get chooseTags;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to train'**
  String get loginTitle;

  /// No description provided for @loginLead.
  ///
  /// In en, this message translates to:
  /// **'Trainees only. Use the same email and password as the StayAble website.'**
  String get loginLead;

  /// No description provided for @loginCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create user'**
  String get loginCreateTitle;

  /// No description provided for @loginCreateLead.
  ///
  /// In en, this message translates to:
  /// **'This user stays on this device. It is not an instructor account on the server.'**
  String get loginCreateLead;

  /// No description provided for @loginCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create user'**
  String get loginCreateAction;

  /// No description provided for @loginName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get loginName;

  /// No description provided for @loginNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get loginNameRequired;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get loginEmailRequired;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordRequired;

  /// No description provided for @loginPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get loginPasswordShort;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginAction;

  /// No description provided for @loginErrorEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'This email already has a user on this device.'**
  String get loginErrorEmailTaken;

  /// No description provided for @loginSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get loginSubmitting;

  /// No description provided for @loginErrorCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is wrong.'**
  String get loginErrorCredentials;

  /// No description provided for @loginErrorNotAthlete.
  ///
  /// In en, this message translates to:
  /// **'This app is for trainees. Instructors and admins use the website.'**
  String get loginErrorNotAthlete;

  /// No description provided for @loginErrorInactive.
  ///
  /// In en, this message translates to:
  /// **'This account is inactive.'**
  String get loginErrorInactive;

  /// No description provided for @loginErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the server. Is the backend running?'**
  String get loginErrorNetwork;

  /// No description provided for @loginErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in. Try again.'**
  String get loginErrorUnknown;

  /// No description provided for @loginErrorServer.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid server address, like https://gym.example.com'**
  String get loginErrorServer;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Backend site'**
  String get serverUrl;

  /// No description provided for @serverUrlHint.
  ///
  /// In en, this message translates to:
  /// **'HTTPS address of the StayAble site. Workout results are stored there.'**
  String get serverUrlHint;

  /// No description provided for @serverUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the backend site address'**
  String get serverUrlRequired;

  /// No description provided for @serverSave.
  ///
  /// In en, this message translates to:
  /// **'Save address'**
  String get serverSave;

  /// No description provided for @serverSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved. New workouts will sync to this site.'**
  String get serverSaved;

  /// No description provided for @completeExercise.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeExercise;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @exerciseNoteHint.
  ///
  /// In en, this message translates to:
  /// **'How it felt, what to change next time…'**
  String get exerciseNoteHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
