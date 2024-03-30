import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/finished_workout.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/modals/end_workout_confirmation.dart';
import 'package:gym_partner/widgets/modals/exercise_info.dart';
import 'package:gym_partner/widgets/plan_day_card.dart';
import 'package:gym_partner/widgets/workout_progress_bar.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key, required this.day, required this.plan});

  final Plan plan;
  final PlanDay day;

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  bool _isRest = false;

  final oneSecond = const Duration(seconds: 1);
  Timer? _restTimer;
  Timer? _workoutTimer;
  int _remainingSeconds = 0;
  int _workoutTime = 0;

  @override
  void initState() {
    _restTimer = Timer.periodic(oneSecond, (Timer timer) {
      _workoutTime += 1;
    });
    super.initState();
  }

  PlanExercise get _currentExercise {
    return widget.day.exercises[_currentExerciseIndex];
  }

  PlanExercise get _nextExercise {
    if (_currentSetIndex == _currentExercise.numOfSets - 1 &&
        _currentExerciseIndex < widget.day.exercises.length - 1) {
      return widget.day.exercises[_currentExerciseIndex + 1];
    } else {
      return _currentExercise;
    }
  }

  bool get _isLastSet {
    return _currentExerciseIndex == widget.day.exercises.length - 1 &&
        _currentSetIndex == _currentExercise.numOfSets - 1;
  }

  bool get _isFirstSet {
    return _currentExerciseIndex == 0 && _currentSetIndex == 0;
  }

  int get _currentWorkoutSetIndex {
    var workoutSetIndex = 0;
    for (final (index, exercise) in widget.day.exercises.indexed) {
      if (index < _currentExerciseIndex) {
        workoutSetIndex += exercise.numOfSets;
      }
    }
    workoutSetIndex += _currentSetIndex;
    return workoutSetIndex;
  }

  int get _totalSetsCount {
    var setsCount = 0;
    for (var exercise in widget.day.exercises) {
      setsCount += exercise.numOfSets;
    }
    return setsCount;
  }

  void _showDayInfo() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => _dayInfoModalContent(context),
    );
  }

  Padding _dayInfoModalContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All exercises',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          for (final (index, exercise) in widget.day.exercises.indexed)
            PlanExerciseRow(exercise: exercise, index: index)
        ],
      ),
    );
  }

  void _finishSet() async {
    if (!_isLastSet) {
      _startRest();
    } else {
      _finishWorkout();
    }
  }

  void _startRest() {
    _remainingSeconds = _currentExercise.restTime;
    _restTimer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _finishRest();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
    setState(() {
      _isRest = true;
    });
  }

  void _finishRest() {
    _jumpToNextSet();
    setState(() {
      _isRest = false;
      _restTimer?.cancel();
    });
  }

  void _jumpToPreviousSet() {
    var tempSetIndex = _currentSetIndex;
    var tempExerciseIndex = _currentExerciseIndex;
    tempSetIndex -= 1;
    if (tempSetIndex < 0) {
      tempExerciseIndex -= 1;
      tempSetIndex = widget.day.exercises[tempExerciseIndex].numOfSets - 1;
    }
    setState(() {
      _currentSetIndex = tempSetIndex;
      _currentExerciseIndex = tempExerciseIndex;
    });
  }

  void _jumpToNextSet() {
    var tempSetIndex = _currentSetIndex;
    var tempExerciseIndex = _currentExerciseIndex;
    tempSetIndex += 1;
    if (tempSetIndex == _currentExercise.numOfSets) {
      tempSetIndex = 0;
      tempExerciseIndex += 1;
    }

    if (tempExerciseIndex == widget.day.exercises.length) {
      _finishWorkout();
    } else {
      setState(() {
        _currentSetIndex = tempSetIndex;
        _currentExerciseIndex = tempExerciseIndex;
      });
    }
  }

  void _finishWorkout() {
    _workoutTimer?.cancel();
    ref.read(userProvider.notifier).incrementCurrentDayIndex(widget.plan);
    ref.read(userProvider.notifier).finishWorkout(widget.plan, _workoutTime);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => FinishedWorkoutScreen(
        day: widget.day,
        timeInSeconds: _workoutTime,
      ),
    ));
  }

  void _showExerciseInfoModal() {
    showDialog(
      context: context,
      builder: (context) =>
          ExerciseInfoModal(exercise: _currentExercise.exercise),
    );
  }

  void _showEndWorkoutModal() {
    showDialog(
      context: context,
      builder: (context) => EndWorkoutConfirmationModal(onConfirm: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = PreferredSize(
        preferredSize: const Size.fromHeight(12),
        child: WorkoutProgressBar(
          currentSetIndex: _currentWorkoutSetIndex,
          totalSetsCount: _totalSetsCount,
          isRest: _isRest,
        ));

    var showExerciseInfoButton = IconButton(
        onPressed: _showExerciseInfoModal,
        icon: const Icon(Icons.question_mark));
    var showDayInfoButton =
        IconButton(onPressed: _showDayInfo, icon: const Icon(Icons.list));
    var appBar = AppBar(
      bottom: progressBar,
      actions: [
        if (!_isRest) showExerciseInfoButton,
        showDayInfoButton,
      ],
      leading: IconButton(
        onPressed: _showEndWorkoutModal,
        icon: const Icon(Icons.close),
      ),
    );
    var nextExerciseBanner = Container(
      width: double.infinity,
      height: 110,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
      child: _isLastSet
          ? Text(
              'Final exercise',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NEXT EXERCISE:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  _nextExercise.exercise.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
    );
    var restContent = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1, end: 0),
            duration: Duration(seconds: _currentExercise.restTime + 1),
            builder: (context, value, _) => CircularProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              value: value,
              strokeWidth: 12,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rest',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              '${_remainingSeconds.round()}',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        )
      ],
    );
    var exerciseHeader = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _currentExercise.exercise.name,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          'x${_currentExercise.numOfReps}',
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
    var bottomButtons = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!_isFirstSet && !_isRest)
                _nextOrBackIconButton(
                    iconData: Icons.chevron_left,
                    onPressed: _jumpToPreviousSet),
              const Spacer(),
              if (!_isLastSet && !_isRest)
                _nextOrBackIconButton(
                    iconData: Icons.chevron_right, onPressed: _jumpToNextSet),
            ],
          ),
          IconButton(
            padding: const EdgeInsets.all(25),
            focusColor: Colors.black,
            color: Theme.of(context).colorScheme.onPrimary,
            style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary),
            onPressed: _isRest ? _finishRest : _finishSet,
            icon: Icon(
              _isRest ? Icons.chevron_right : Icons.done,
              size: 50,
              weight: 0.1,
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 48),
        child: Column(
          children: [
            const SizedBox(height: 24),
            nextExerciseBanner,
            Expanded(child: _isRest ? restContent : exerciseHeader),
            bottomButtons,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  IconButton _nextOrBackIconButton(
          {required IconData iconData, required void Function() onPressed}) =>
      IconButton(
        onPressed: onPressed,
        icon: Icon(
          iconData,
          size: 70,
        ),
      );
}
