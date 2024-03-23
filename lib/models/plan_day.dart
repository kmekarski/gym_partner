import 'package:gym_partner/models/plan_exercise.dart';

class PlanDay {
  PlanDay({
    required this.id,
    required this.exercises,
  });
  final String id;
  List<PlanExercise> exercises;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'exercises': exercises.map((e) => e.toFirestore()).toList(),
    };
  }
}
