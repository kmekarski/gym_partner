import 'package:gym_partner/models/plan_exercise.dart';

class PlanDay {
  PlanDay({required this.id}) : exercises = [];
  final String id;
  final List<PlanExercise> exercises;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'exercises': exercises.map((e) => e.toFirestore()).toList(),
    };
  }
}
