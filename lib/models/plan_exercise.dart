import 'package:gym_partner/models/exercise.dart';

class PlanExercise {
  PlanExercise(
      {required this.exercise,
      this.numOfSets = 3,
      this.numOfReps = 10,
      this.restTime = 120});

  int numOfSets;
  int numOfReps;
  int restTime;
  final Exercise exercise;

  Map<String, dynamic> toFirestore() {
    return {
      'exercise': exercise.name,
      'num_of_sets': numOfSets,
      'num_of_reps': numOfReps,
      'rest_time': restTime,
    };
  }
}
