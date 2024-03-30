import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/models/workout_in_history.dart';

class UsersService {
  DocumentReference<Map<String, dynamic>> userDocRef(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  User get currentUser {
    return FirebaseAuth.instance.currentUser!;
  }

  Future<AppUser> get currentUserData async {
    return AppUser.fromFirestore(await userDocRef(currentUser.uid).get());
  }

  Future<AppUser?> deletePlanData(String planId) async {
    try {
      final userData = await currentUserData;
      userData.plansData.removeWhere(
        (planData) => planData.planId == planId,
      );
      await userDocRef(currentUser.uid).update({
        'plans_data': userData.plansData
            .map((planData) => planData.toFirestore())
            .toList(),
      });

      return userData;
    } catch (e) {
      print("Error deleting plan data: $e");
      return null;
    }
  }

  Future<AppUser?> addNewPlanData(String planId) async {
    try {
      final userData = await currentUserData;
      final newPlanData =
          UserPlanData(planId: planId, currentDayIndex: 0, isRecent: false);
      userData.plansData.add(newPlanData);
      await userDocRef(currentUser.uid).update({
        'plans_data': userData.plansData
            .map((planData) => planData.toFirestore())
            .toList(),
      });

      return userData;
    } catch (e) {
      print("Error adding plan data: $e");
      return null;
    }
  }

  Future<AppUser?> setPlanAsRecent(String planId) async {
    try {
      final userData = await currentUserData;

      for (final planData in userData.plansData) {
        if (planData.planId == planId) {
          planData.isRecent = true;
        } else {
          planData.isRecent = false;
        }
      }

      await userDocRef(currentUser.uid).update({
        'plans_data': userData.plansData
            .map((planData) => planData.toFirestore())
            .toList(),
      });

      return userData;
    } catch (e) {
      print("Error adding plan data: $e");
      return null;
    }
  }

  Future<AppUser?> addWorkoutInHistory(
      Plan plan, int workoutTimeInSeconds) async {
    try {
      final userData = await currentUserData;
      final plansData = userData.plansData;
      final currentWorkoutsHistory = userData.workoutsHistory;

      final dayIndex = plansData
          .firstWhere((planData) => planData.planId == plan.id)
          .currentDayIndex;
      final day = plan.days[dayIndex];
      final numOfExercises = day.exercises.length;

      int numOfSets = 0;
      for (final exercise in day.exercises) {
        numOfSets += exercise.numOfSets;
      }

      final workoutInHistoryToAdd = WorkoutInHistory(
          id: currentWorkoutsHistory.length.toString(),
          planName: plan.name,
          tags: plan.tags,
          dayIndex: dayIndex,
          numOfSets: numOfSets,
          numOfExercises: numOfExercises,
          timeInSeconds: workoutTimeInSeconds,
          timestamp: Timestamp.now());

      final updatedWorkoutsHistory = [
        workoutInHistoryToAdd,
        ...currentWorkoutsHistory
      ];

      await userDocRef(currentUser.uid).update(
        {
          'workouts_history': updatedWorkoutsHistory
              .map((workoutInHistory) => workoutInHistory.toFirestore())
              .toList(),
        },
      );
      final updatedUserData = AppUser(
        id: userData.id,
        username: userData.username,
        email: userData.email,
        plansData: plansData,
        workoutsHistory: updatedWorkoutsHistory,
        totalStatsData: userData.totalStatsData,
      );
      return updatedUserData;
    } catch (e) {
      print("Error adding workout in history: $e");
      return null;
    }
  }

  Future<AppUser?> incrementCurrentDayIndex(Plan plan) async {
    try {
      final userData = await currentUserData;
      final plansData = userData.plansData;
      final currentDayIndex = plansData
          .firstWhere((planData) => planData.planId == plan.id)
          .currentDayIndex;

      final updatedDayIndex =
          currentDayIndex + 1 >= plan.days.length ? 0 : currentDayIndex + 1;

      plansData
          .firstWhere((planData) => planData.planId == plan.id)
          .currentDayIndex = updatedDayIndex;

      await userDocRef(currentUser.uid).update(
        {
          'plans_data':
              plansData.map((planData) => planData.toFirestore()).toList(),
        },
      );
      final updatedUserData = AppUser(
        id: userData.id,
        username: userData.username,
        email: userData.email,
        plansData: plansData,
        workoutsHistory: userData.workoutsHistory,
        totalStatsData: userData.totalStatsData,
      );
      return updatedUserData;
    } catch (e) {
      print("Error updating current day index: $e");
      return null;
    }
  }
}
