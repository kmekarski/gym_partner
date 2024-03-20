import 'package:gym_partner/models/exercise.dart';

class PlanDay {
  PlanDay({required this.id}) : exercises = [];
  final String id;
  final List<Exercise> exercises;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'exercises': [],
    };
  }
}
