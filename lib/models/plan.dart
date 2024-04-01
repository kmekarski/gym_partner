import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_partner/data/exercises.dart';
import 'package:gym_partner/models/exercise.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/plan_visibility.dart';

class Plan {
  Plan({
    required this.id,
    required this.name,
    required this.authorName,
    required this.authorId,
    required this.days,
    required this.tags,
    required this.difficulty,
    required this.visibility,
    required this.authorAvatarUrl,
  });

  factory Plan.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    List<dynamic> daysData = data['days'] ?? [];
    List<PlanDay> days = daysData.map((dayData) {
      List<dynamic> exercisesData = dayData['exercises'] ?? [];
      List<PlanExercise> exercises = exercisesData.map(
        (exerciseData) {
          return PlanExercise(
            exercise: allExercises.firstWhere(
                (el) => el.name == (exerciseData['exercise'] ?? 'Bench press')),
            numOfSets: exerciseData['num_of_sets'] ?? 3,
            numOfReps: exerciseData['num_of_reps'] ?? 10,
            restTime: exerciseData['rest_time'] ?? 120,
          );
        },
      ).toList();
      return PlanDay(id: dayData['id'] ?? '', exercises: exercises);
    }).toList();

    List<dynamic> tagsData = data['tags'] ?? [];
    List<PlanTag> tags = tagsData.map((tagString) {
      return PlanTag.values.firstWhere((e) => e.toString() == tagString,
          orElse: () => PlanTag.cardio);
    }).toList();

    final difficultyString = (data['difficulty'] ?? '').toString();
    final difficulty = PlanDifficulty.values.firstWhere(
      (e) => e.toString() == difficultyString,
      orElse: () => PlanDifficulty.easy,
    );

    final visibilityString = (data['visibility'] ?? '').toString();
    final visibility = PlanVisibility.values.firstWhere(
      (e) => e.toString() == visibilityString,
      orElse: () => PlanVisibility.private,
    );

    return Plan(
      id: doc.id,
      name: data['name'] ?? '',
      days: days,
      tags: tags,
      difficulty: difficulty,
      visibility: visibility,
      authorName: data['author_name'] ?? '',
      authorId: data['author_id'] ?? '',
      authorAvatarUrl: data['author_avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'days': days.map((day) => day.toFirestore()).toList(),
      'tags': tags.map((tag) => tag.toString()).toList(),
      'difficulty': difficulty.toString(),
      'visibility': visibility.toString(),
      'author_name': authorName,
      'author_id': authorId,
      'author_avatar_url': authorAvatarUrl,
    };
  }

  final String id;
  final String name;
  final List<PlanDay> days;
  final List<PlanTag> tags;
  final PlanDifficulty difficulty;
  final PlanVisibility visibility;
  final String authorName;
  final String authorId;
  final String authorAvatarUrl;

  int getCompletionPercentage(int currentDayIndex) {
    return (100 * currentDayIndex / days.length).round();
  }
}
