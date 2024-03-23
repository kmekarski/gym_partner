import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/screens/finished_workout.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';

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
          IconButton(onPressed: () {}, icon: Icon(Icons.pause)),
          IconButton(onPressed: () {}, icon: Icon(Icons.info_outline)),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: 24, left: 24, top: 24, bottom: 32),
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
            WideButton(label: Text('OK'), onPressed: _nextSet)
          ],
        ),
      ),
    );
  }
}
