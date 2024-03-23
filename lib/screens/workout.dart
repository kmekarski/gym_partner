import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/screens/finished_workout.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/plan_day_card.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.day});

  final PlanDay day;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;

  PlanExercise get _currentExercise {
    return widget.day.exercises[_currentExerciseIndex];
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

  void _nextSet() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.question_mark)),
          IconButton(onPressed: _showDayInfo, icon: Icon(Icons.list)),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: 24, left: 24, top: 24, bottom: 48),
        child: Column(
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
                    if (_currentExerciseIndex > 0)
                      _nextOrBackIconButton(
                          iconData: Icons.chevron_left, onPressed: () {}),
                    const Spacer(),
                    if (_currentExerciseIndex < widget.day.exercises.length - 1)
                      _nextOrBackIconButton(
                          iconData: Icons.chevron_right, onPressed: () {}),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.all(25),
                  focusColor: Colors.black,
                  color: Theme.of(context).colorScheme.onPrimary,
                  style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: _nextSet,
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
