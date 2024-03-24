import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/screens/finished_workout.dart';
import 'package:gym_partner/screens/rest.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/modals/end_workout_confirmation.dart';
import 'package:gym_partner/widgets/modals/exercise_info.dart';
import 'package:gym_partner/widgets/plan_day_card.dart';
import 'package:gym_partner/widgets/workout_progress_bar.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.day});

  final PlanDay day;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  bool _showRestScreen = false;

  PlanExercise get _currentExercise {
    return widget.day.exercises[_currentExerciseIndex];
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
        children: [
          Text(
            'All exercises',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          for (final (index, exercise) in widget.day.exercises.indexed)
            PlanExerciseRow(exercise: exercise, index: index)
        ],
      ),
    );
  }

  void _finishSet() async {
    if (!_isLastSet) {
      setState(() {
        _showRestScreen = true;
      });
    }
    _jumpToNextSet();
  }

  void _finishRest() {
    setState(() {
      _showRestScreen = false;
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => FinishedWorkoutScreen(),
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
          isRest: _showRestScreen,
        ));

    var appBar = AppBar(
      bottom: progressBar,
      actions: [
        IconButton(
            onPressed: _showExerciseInfoModal,
            icon: const Icon(Icons.question_mark)),
        IconButton(onPressed: _showDayInfo, icon: const Icon(Icons.list)),
      ],
      leading: IconButton(
        onPressed: _showEndWorkoutModal,
        icon: const Icon(Icons.close),
      ),
    );
    var restContent = Center(
      child: ElevatedButton(child: Text('skip rest'), onPressed: _finishRest),
    );
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding:
            const EdgeInsets.only(right: 24, left: 24, top: 24, bottom: 48),
        child: _showRestScreen
            ? restContent
            : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Text('$_currentExerciseIndex'),
                          Text('$_currentSetIndex'),
                          Text(
                            _currentExercise.exercise.name,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!_isFirstSet)
                            _nextOrBackIconButton(
                                iconData: Icons.chevron_left,
                                onPressed: _jumpToPreviousSet),
                          const Spacer(),
                          if (!_isLastSet)
                            _nextOrBackIconButton(
                                iconData: Icons.chevron_right,
                                onPressed: _jumpToNextSet),
                        ],
                      ),
                      IconButton(
                        padding: EdgeInsets.all(25),
                        focusColor: Colors.black,
                        color: Theme.of(context).colorScheme.onPrimary,
                        style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        onPressed: _finishSet,
                        icon: const Icon(
                          Icons.done,
                          size: 50,
                          weight: 0.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
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
