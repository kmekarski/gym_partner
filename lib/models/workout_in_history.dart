import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_partner/models/plan_tag.dart';

class WorkoutInHistory {
  const WorkoutInHistory(
      {required this.id,
      required this.planName,
      required this.tags,
      required this.dayIndex,
      required this.numOfSets,
      required this.numOfExercises,
      required this.timeInSeconds,
      required this.timestamp});

  final String id;
  final String planName;
  final List<PlanTag> tags;
  final int dayIndex;
  final int numOfSets;
  final int numOfExercises;
  final Timestamp timestamp;
  final int timeInSeconds;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'plan_name': planName,
      'tags': tags.map((tag) => tag.toString()).toList(),
      'day_index': dayIndex,
      'num_of_sets': numOfSets,
      'num_of_exercises': numOfExercises,
      'time_in_seconds': timeInSeconds,
      'timestamp': timestamp,
    };
  }
}
