import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../core/l10n/labels.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/stayable_async.dart';
import '../../domain/domain.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../profile/birthday_prompt.dart';
import '../providers.dart';

enum _WizardStep { health, goals, fitness, lifestyle, nutrition, program }

class ProgramWizardScreen extends ConsumerStatefulWidget {
  const ProgramWizardScreen({super.key});

  @override
  ConsumerState<ProgramWizardScreen> createState() =>
      _ProgramWizardScreenState();
}

class _ProgramWizardScreenState extends ConsumerState<ProgramWizardScreen> {
  var _step = _WizardStep.health;
  var _assessment = const TraineeAssessment();
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await ref.read(repositoryProvider).getCurrentUser();
    if (!mounted || user.assessment == null) return;
    setState(() => _assessment = user.assessment!);
  }

  List<_WizardStep> get _steps => const [
        _WizardStep.health,
        _WizardStep.goals,
        _WizardStep.fitness,
        _WizardStep.lifestyle,
        _WizardStep.nutrition,
        _WizardStep.program,
      ];

  void _toggleInjury(InjuryArea area) {
    setState(() {
      final next = {..._assessment.injuries};
      next.contains(area) ? next.remove(area) : next.add(area);
      _assessment = _assessment.copyWith(injuries: next);
    });
  }

  void _toggleCondition(MedicalCondition condition) {
    setState(() {
      final next = {..._assessment.conditions};
      next.contains(condition) ? next.remove(condition) : next.add(condition);
      _assessment = _assessment.copyWith(conditions: next);
    });
  }

  void _toggleGoal(FitnessGoal goal) {
    setState(() {
      final next = [..._assessment.goals];
      if (next.contains(goal)) {
        next.remove(goal);
      } else {
        next.add(goal);
      }
      _assessment = _assessment.copyWith(goals: next);
    });
  }

  void _togglePreference(TrainingPreference preference) {
    setState(() {
      final next = {..._assessment.preferences};
      next.contains(preference) ? next.remove(preference) : next.add(preference);
      _assessment = _assessment.copyWith(preferences: next);
    });
  }

  void _toggleWeekday(int weekday) {
    setState(() {
      final next = {..._assessment.weekdays};
      next.contains(weekday) ? next.remove(weekday) : next.add(weekday);
      _assessment = _assessment.copyWith(weekdays: [...next]..sort());
    });
  }

  void _setPeriod(ScheduleType period) {
    setState(() {
      var weekdays = _assessment.weekdays;
      if (period == ScheduleType.weekly && weekdays.isEmpty) {
        weekdays = const [
          DateTime.monday,
          DateTime.wednesday,
          DateTime.friday,
        ];
      }
      if (period == ScheduleType.daily) {
        weekdays = [
          for (var day = DateTime.monday; day <= DateTime.sunday; day++) day,
        ];
      }
      _assessment = _assessment.copyWith(period: period, weekdays: weekdays);
    });
  }

  String? _validate(AppLocalizations l10n) {
    switch (_step) {
      case _WizardStep.goals:
        if (_assessment.goals.isEmpty) return l10n.wizardGoalsRequired;
      case _WizardStep.lifestyle:
        if (_assessment.period == ScheduleType.weekly &&
            _assessment.weekdays.isEmpty) {
          return l10n.selectDays;
        }
      default:
        break;
    }
    return null;
  }

  Future<void> _next() async {
    final l10n = AppLocalizations.of(context);
    final error = _validate(l10n);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() => _error = null);
    final index = _steps.indexOf(_step);
    if (index < _steps.length - 1) {
      setState(() => _step = _steps[index + 1]);
      return;
    }
    final birth = await ensureUserBirthDate(context: context, ref: ref);
    if (!mounted) return;
    if (birth == null) {
      setState(() => _error = l10n.birthdayRequired);
      return;
    }
    await _saveAssessment();
    if (!mounted) return;
    context.pop();
  }

  void _back() {
    final index = _steps.indexOf(_step);
    if (index <= 0) {
      context.pop();
      return;
    }
    setState(() {
      _error = null;
      _step = _steps[index - 1];
    });
  }

  Future<void> _saveAssessment() async {
    await ref.read(authProvider.notifier).saveAssessment(_assessment);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = _steps;
    final index = steps.indexOf(_step);
    return StayAblePage(
      title: l10n.assessTitle,
      leading: PlinthActionIcon(
        semanticLabel: l10n.wizardBack,
        icon: const Icon(Icons.arrow_back),
        onPressed: _back,
      ),
      actions: const [LanguageToggle()],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          PlinthSpacing.lg,
          PlinthSpacing.sm,
          PlinthSpacing.lg,
          PlinthSpacing.xl,
        ),
        children: [
          PlinthText(l10n.wizardStepOf(index + 1, steps.length), color: 'gray'),
          const PlinthSpace(h: PlinthSize.xs),
          PlinthProgress(value: (index + 1) / steps.length),
          const PlinthSpace(h: PlinthSize.md),
          if (_error != null) PlinthAlert(color: 'red', child: Text(_error!)),
          if (_step == _WizardStep.health) ...[
            PlinthText(l10n.wizardLead, color: 'gray'),
            const PlinthSpace(h: PlinthSize.md),
          ],
          ..._stepBody(l10n),
          const PlinthSpace(h: PlinthSize.lg),
          PlinthAsyncButton(
            fullWidth: true,
            onPressed: _next,
            doneLabel: l10n.wizardAssessmentSaved,
            child: Text(
              index < steps.length - 1
                  ? l10n.wizardNext
                  : l10n.wizardSaveAssessment,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _stepBody(AppLocalizations l10n) {
    return switch (_step) {
      _WizardStep.health => _health(l10n),
      _WizardStep.goals => _goals(l10n),
      _WizardStep.fitness => _fitness(l10n),
      _WizardStep.lifestyle => _lifestyle(l10n),
      _WizardStep.nutrition => _nutrition(l10n),
      _WizardStep.program => _program(l10n),
    };
  }

  List<Widget> _health(AppLocalizations l10n) {
    return [
      PlinthTitle(l10n.wizardHealthTitle, order: 3),
      PlinthText(l10n.wizardHealthLead, color: 'gray'),
      const PlinthSpace(h: PlinthSize.md),
      PlinthTitle(l10n.wizardHealthInjuries, order: 4),
      _ChipRow(
        children: [
          for (final area in InjuryArea.values)
            PlinthChip(
              label: injuryAreaLabel(l10n, area),
              selected: _assessment.injuries.contains(area),
              onSelected: (_) => _toggleInjury(area),
            ),
        ],
      ),
      const PlinthSpace(h: PlinthSize.md),
      PlinthTitle(l10n.wizardHealthConditions, order: 4),
      _ChipRow(
        children: [
          for (final condition in MedicalCondition.values)
            PlinthChip(
              label: medicalConditionLabel(l10n, condition),
              selected: _assessment.conditions.contains(condition),
              onSelected: (_) => _toggleCondition(condition),
            ),
        ],
      ),
      const PlinthSpace(h: PlinthSize.md),
      PlinthChip(
        label: l10n.wizardHealthMeds,
        selected: _assessment.medicationsAffecting,
        onSelected: (_) => setState(
          () => _assessment = _assessment.copyWith(
            medicationsAffecting: !_assessment.medicationsAffecting,
          ),
        ),
      ),
      const PlinthSpace(h: PlinthSize.sm),
      PlinthChip(
        label: l10n.wizardHealthClearance,
        selected: _assessment.needsClearance,
        onSelected: (_) => setState(
          () => _assessment = _assessment.copyWith(
            needsClearance: !_assessment.needsClearance,
          ),
        ),
      ),
    ];
  }

  List<Widget> _goals(AppLocalizations l10n) {
    return [
      PlinthTitle(l10n.wizardGoals, order: 3),
      PlinthText(l10n.wizardGoalsLead, color: 'gray'),
      const PlinthSpace(h: PlinthSize.md),
      _ChipRow(
        children: [
          for (final goal in FitnessGoal.values)
            PlinthChip(
              label: fitnessGoalLabel(l10n, goal),
              selected: _assessment.goals.contains(goal),
              onSelected: (_) => _toggleGoal(goal),
            ),
        ],
      ),
      const PlinthSpace(h: PlinthSize.lg),
      PlinthTitle(l10n.wizardTimeline, order: 4),
      _ChipRow(
        children: [
          for (final timeline in GoalTimeline.values)
            PlinthChip(
              label: goalTimelineLabel(l10n, timeline),
              selected: _assessment.timeline == timeline,
              onSelected: (_) => setState(
                () => _assessment = _assessment.copyWith(timeline: timeline),
              ),
            ),
        ],
      ),
      const PlinthSpace(h: PlinthSize.lg),
      PlinthTitle(l10n.wizardPreferences, order: 4),
      _ChipRow(
        children: [
          for (final preference in TrainingPreference.values)
            PlinthChip(
              label: trainingPreferenceLabel(l10n, preference),
              selected: _assessment.preferences.contains(preference),
              onSelected: (_) => _togglePreference(preference),
            ),
        ],
      ),
    ];
  }

  List<Widget> _fitness(AppLocalizations l10n) {
    return [
      PlinthTitle(l10n.wizardFitnessTitle, order: 3),
      PlinthText(l10n.wizardFitnessLead, color: 'gray'),
      const PlinthSpace(h: PlinthSize.md),
      PlinthTitle(l10n.wizardBackground, order: 4),
      _ChipRow(
        children: [
          for (final background in TrainingBackground.values)
            PlinthChip(
              label: trainingBackgroundLabel(l10n, background),
              selected: _assessment.background == background,
              onSelected: (_) => setState(
                () =>
                    _assessment = _assessment.copyWith(background: background),
              ),
            ),
        ],
      ),
      const PlinthSpace(h: PlinthSize.lg),
      PlinthTitle(l10n.wizardOccupation, order: 4),
      _ChipRow(
        children: [
          for (final occupation in OccupationDemand.values)
            PlinthChip(
              label: occupationDemandLabel(l10n, occupation),
              selected: _assessment.occupation == occupation,
              onSelected: (_) => setState(
                () =>
                    _assessment = _assessment.copyWith(occupation: occupation),
              ),
            ),
        ],
      ),
      const PlinthSpace(h: PlinthSize.lg),
      PlinthTitle(l10n.wizardMobility, order: 4),
      _ChipRow(
        children: [
          for (final mobility in MobilityLevel.values)
            PlinthChip(
              label: mobilityLevelLabel(l10n, mobility),
              selected: _assessment.mobility == mobility,
              onSelected: (_) => setState(
                () => _assessment = _assessment.copyWith(mobility: mobility),
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> _lifestyle(AppLocalizations l10n) {
    return [
      PlinthTitle(l10n.wizardLifestyleTitle, order: 3),
      PlinthText(l10n.wizardLifestyleLead, color: 'gray'),
      const PlinthSpace(h: PlinthSize.md),
      PlinthTitle(l10n.wizardPeriod, order: 4),
      _ChipRow(
        children: [
          PlinthChip(
            label: l10n.wizardPeriodWeekly,
            selected: _assessment.period == ScheduleType.weekly,
            onSelected: (_) => _setPeriod(ScheduleType.weekly),
          ),
          PlinthChip(
            label: l10n.wizardPeriodDaily,
            selected: _assessment.period == ScheduleType.daily,
            onSelected: (_) => _setPeriod(ScheduleType.daily),
          ),
          PlinthChip(
            label: l10n.wizardPeriodOccasional,
            selected: _assessment.period == ScheduleType.occasional,
            onSelected: (_) => _setPeriod(ScheduleType.occasional),
          ),
        ],
      ),
      if (_assessment.period == ScheduleType.weekly) ...[
        const PlinthSpace(h: PlinthSize.md),
        PlinthTitle(l10n.wizardDays, order: 4),
        _ChipRow(
          children: [
            for (var weekday = DateTime.monday;
                weekday <= DateTime.sunday;
                weekday++)
              PlinthChip(
                label: weekdayLabel(l10n, weekday),
                selected: _assessment.weekdays.contains(weekday),
                onSelected: (_) => _toggleWeekday(weekday),
              ),
          ],
        ),
      ],
      const PlinthSpace(h: PlinthSize.lg),
      PlinthNumberInput(
        value: _assessment.sessionMinutes,
        min: 20,
        step: 5,
        label: l10n.wizardSessionMinutes,
        onChanged: (value) => setState(
          () => _assessment =
              _assessment.copyWith(sessionMinutes: value.round()),
        ),
      ),
      const PlinthSpace(h: PlinthSize.md),
      PlinthNumberInput(
        value: _assessment.sleepHours,
        min: 4,
        step: 1,
        label: l10n.wizardSleepHours,
        onChanged: (value) => setState(
          () =>
              _assessment = _assessment.copyWith(sleepHours: value.round()),
        ),
      ),
      const PlinthSpace(h: PlinthSize.md),
      PlinthTitle(l10n.wizardStress, order: 4),
      _ChipRow(
        children: [
          for (final stress in StressLevel.values)
            PlinthChip(
              label: stressLevelLabel(l10n, stress),
              selected: _assessment.stress == stress,
              onSelected: (_) => setState(
                () => _assessment = _assessment.copyWith(stress: stress),
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> _nutrition(AppLocalizations l10n) {
    return [
      PlinthTitle(l10n.wizardNutritionTitle, order: 3),
      PlinthText(l10n.wizardNutritionLead, color: 'gray'),
      const PlinthSpace(h: PlinthSize.md),
      PlinthTitle(l10n.wizardDiet, order: 4),
      _ChipRow(
        children: [
          for (final diet in DietHabit.values)
            PlinthChip(
              label: dietHabitLabel(l10n, diet),
              selected: _assessment.diet == diet,
              onSelected: (_) => setState(
                () => _assessment = _assessment.copyWith(diet: diet),
              ),
            ),
        ],
      ),
      const PlinthSpace(h: PlinthSize.lg),
      PlinthTitle(l10n.wizardHabits, order: 4),
      _ChipRow(
        children: [
          for (final habit in LifestyleHabit.values)
            PlinthChip(
              label: lifestyleHabitLabel(l10n, habit),
              selected: _assessment.habits == habit,
              onSelected: (_) => setState(
                () => _assessment = _assessment.copyWith(habits: habit),
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> _program(AppLocalizations l10n) {
    return [
      PlinthTitle(l10n.wizardProgramTitle, order: 3),
      PlinthText(l10n.wizardProgramLead, color: 'gray'),
      const PlinthSpace(h: PlinthSize.md),
      PlinthTitle(l10n.wizardVenue, order: 4),
      _ChipRow(
        children: [
          for (final venue in const [ProgramVenue.home, ProgramVenue.gym])
            PlinthChip(
              label: programVenueLabel(l10n, venue),
              selected: _assessment.venue == venue,
              onSelected: (_) => setState(
                () => _assessment = _assessment.copyWith(venue: venue),
              ),
            ),
        ],
      ),
      const PlinthSpace(h: PlinthSize.lg),
      PlinthTitle(l10n.wizardType, order: 4),
      _ChipRow(
        children: [
          for (final type in WorkoutType.values)
            PlinthChip(
              label: workoutTypeLabel(l10n, type),
              selected: _assessment.workoutType == type,
              onSelected: (_) => setState(
                () => _assessment = _assessment.copyWith(workoutType: type),
              ),
            ),
        ],
      ),
    ];
  }
}

class GenerateFromProfileScreen extends ConsumerStatefulWidget {
  const GenerateFromProfileScreen({super.key});

  @override
  ConsumerState<GenerateFromProfileScreen> createState() =>
      _GenerateFromProfileScreenState();
}

class _GenerateFromProfileScreenState
    extends ConsumerState<GenerateFromProfileScreen> {
  String? _error;
  var _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    if (_started) return;
    _started = true;
    final l10n = AppLocalizations.of(context);
    var user = await ref.read(repositoryProvider).getCurrentUser();
    if (user.assessment == null) {
      if (!mounted) return;
      await context.push('/profile');
      if (!mounted) return;
      user = await ref.read(repositoryProvider).getCurrentUser();
      if (!mounted) return;
      if (user.assessment == null) {
        context.pop();
        return;
      }
    }
    if (!mounted) return;
    final birth = await ensureUserBirthDate(context: context, ref: ref);
    if (!mounted) return;
    final age = ageYearsFromBirthDate(birth);
    if (birth == null || age == null || age < minAgeYears || age > maxAgeYears) {
      setState(() => _error = l10n.birthdayRequired);
      return;
    }
    final assessment = user.assessment!;
    try {
      try {
        await ref.read(authProvider.notifier).refreshCatalog();
      } catch (_) {
        // Private mode still has the on-device catalog.
      }
      final catalog = await ref.read(repositoryProvider).getExercises();
      if (catalog.isEmpty) {
        setState(() => _error = l10n.wizardEmptyCatalog);
        return;
      }
      final generated = generateLocalProgram(
        answers: ProgramWizardAnswers(
          venue: assessment.resolvedVenue,
          workoutType: assessment.resolvedWorkoutType,
          age: age,
          status: assessment.derivedLevel(age),
          goals: assessment.goals,
          period: assessment.period,
          weekdays: [...assessment.weekdays]..sort(),
          sessionMinutes: assessment.sessionMinutes,
          assessment: assessment,
        ),
        catalog: catalog,
        language: ref.read(localeProvider).languageCode,
      );
      final id = await ref.read(repositoryProvider).saveLocalProgram(
            generated.toDraft(),
          );
      ref.invalidate(homeSnapshotProvider);
      ref.invalidate(programSnapshotProvider);
      if (!mounted) return;
      context.pushReplacement('/program/edit/$id');
    } on ProgramWizardException {
      if (!mounted) return;
      setState(() => _error = l10n.wizardEmptyCatalog);
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.failure == AuthFailure.network
            ? l10n.createProgramWizardOffline
            : l10n.wizardFailed;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = l10n.wizardFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StayAblePage(
      title: l10n.createProgramWizardTitle,
      leading: PlinthActionIcon(
        semanticLabel: l10n.wizardBack,
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      actions: const [LanguageToggle()],
      body: _error == null
          ? const StayAbleLoading()
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                PlinthSpacing.lg,
                PlinthSpacing.sm,
                PlinthSpacing.lg,
                PlinthSpacing.xl,
              ),
              children: [
                PlinthAlert(color: 'red', child: Text(_error!)),
                const PlinthSpace(h: PlinthSize.md),
                PlinthButton(
                  fullWidth: true,
                  onPressed: () => context.push('/profile'),
                  child: Text(l10n.assessChange),
                ),
              ],
            ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: children,
    );
  }
}
