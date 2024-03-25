import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/models/workout_in_history.dart';

class AppUser {
  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.plansData,
    required this.workoutsHistory,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    List<dynamic> plansDataData = data['plans_data'] ?? [];
    List<UserPlanData> plansData = plansDataData.map((planData) {
      return UserPlanData(
          planId: planData['plan_id'],
          currentDayIndex: planData['current_day_index'],
          isRecent: planData['is_recent']);
    }).toList();

    List<dynamic> workoutsHistoryData = data['workouts_history'] ?? [];
    List<WorkoutInHistory> workoutsHistory =
        workoutsHistoryData.map((workoutInHistoryData) {
      return WorkoutInHistory(
        id: workoutInHistoryData['id'] ?? '',
        planName: workoutInHistoryData['plan_name'] ?? '',
        dayIndex: workoutInHistoryData['day_index'] ?? 0,
        tags: [],
        numOfSets: workoutInHistoryData['num_of_sets'] ?? 0,
        numOfExercises: workoutInHistoryData['num_of_exercises'] ?? 0,
        timestamp: workoutInHistoryData['timestamp'] ?? Timestamp.now(),
        timeInSeconds: workoutInHistoryData['time_in_seconds'] ?? 0,
      );
    }).toList();
    return AppUser(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'],
      plansData: plansData,
      workoutsHistory: workoutsHistory,
    );
  }

  final String id;
  final String username;
  final String email;
  final List<UserPlanData> plansData;
  final List<WorkoutInHistory> workoutsHistory;
}
