import 'package:gym_partner/models/plan_exercise.dart';

class PlanDay {
  PlanDay({
    required this.id,
    this.exercises = const [],
  });
  final String id;
  final List<PlanExercise> exercises;

  // factory PlanDay.fromMap(Map<String, dynamic> map) {
  //   return PlanDay(
  //     id: map['id'] ?? '',
  //     exercises: map[]
  //   );
  // }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'exercises': exercises.map((e) => e.toFirestore()).toList(),
    };
  }
}
