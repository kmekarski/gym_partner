import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_visibility.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/models/workout_in_history.dart';
import 'package:gym_partner/screens/workout_history.dart';

class PlansService {
  DocumentReference<Map<String, dynamic>> userDocRef(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  User get currentUser {
    return FirebaseAuth.instance.currentUser!;
  }

  Future<AppUser> get currentUserData async {
    return AppUser.fromFirestore((await userDocRef(currentUser.uid).get()));
  }

  Future<List<Plan>> getPublicPlans() async {
    List<Plan> plans = [];

    try {
      final userData = await currentUserData;
      QuerySnapshot plansSnapshot =
          await FirebaseFirestore.instance.collection('public_plans').get();

      for (var doc in plansSnapshot.docs) {
        final plan = Plan.fromFirestore(doc);
        if (plan.authorId != userData.id) {
          plans.add(plan);
        }
      }
    } catch (e) {
      print("Error getting public plans from Firebase: $e");
    }
    return plans;
  }

  Future<List<Plan>> getUserPlans() async {
    List<Plan> userPlans = [];

    try {
      QuerySnapshot planSnapshot =
          await userDocRef(currentUser.uid).collection('plans').get();

      for (var doc in planSnapshot.docs) {
        userPlans.add(Plan.fromFirestore(doc));
      }
    } catch (e) {
      print("Error getting user's plans from Firebase: $e");
    }
    return userPlans;
  }

  Future<Plan?> downloadPlan(Plan plan) async {
    try {
      await userDocRef(currentUser.uid)
          .collection('plans')
          .doc(plan.id)
          .set(plan.toFirestore());
      return plan;
    } catch (e) {
      print("Error downloading other user's plan: $e");
      return null;
    }
  }

  Future<bool> deletePlan(Plan plan) async {
    try {
      await userDocRef(currentUser.uid)
          .collection('plans')
          .doc(plan.id)
          .delete();

      if (plan.visibility == PlanVisibility.public &&
          currentUser.uid == plan.authorId) {
        FirebaseFirestore.instance
            .collection('public_plans')
            .doc(plan.id)
            .delete();
      }
      return true;
    } catch (e) {
      print("Error deleting plan: $e");
      return false;
    }
  }

  Future<Plan?> addUserPlan(Plan plan) async {
    try {
      final userData = await currentUserData;
      final planToBeAdded = Plan(
        id: plan.id,
        name: plan.name,
        days: plan.days,
        tags: plan.tags,
        difficulty: plan.difficulty,
        visibility: plan.visibility,
        authorName: userData.username,
        authorId: userData.id,
      );
      DocumentReference userPlanDocRef = await userDocRef(currentUser.uid)
          .collection('plans')
          .add(planToBeAdded.toFirestore());

      final planId = userPlanDocRef.id;
      userPlanDocRef.update({'id': planId});

      final addedPlan = Plan(
        id: planId,
        name: plan.name,
        days: plan.days,
        tags: plan.tags,
        difficulty: plan.difficulty,
        visibility: plan.visibility,
        authorName: userData.username,
        authorId: userData.id,
      );

      if (plan.visibility == PlanVisibility.public) {
        await _addPublicPlan(addedPlan);
      }

      return addedPlan;
    } catch (e) {
      print("Error adding user's plan to Firebase: $e");
      return null;
    }
  }

  Future<void> _addPublicPlan(Plan plan) async {
    FirebaseFirestore.instance
        .collection('public_plans')
        .doc(plan.id)
        .set(plan.toFirestore());
  }

  Map<String, Map<ChartDataType, int>> calculateHistoryChartData(
    List<WorkoutInHistory> workoutsHistory,
    ChartTime chartTime,
  ) {
    final now = DateTime.now();
    final sixDaysBefore = now.subtract(Duration(days: 6));
    DateTime intervalStart =
        DateTime(sixDaysBefore.year, sixDaysBefore.month, sixDaysBefore.day);
    DateTime intervalEnd = now;

    if (chartTime == ChartTime.thisMonth) {
      intervalStart = DateTime(now.year, now.month);
    }

    final Map<String, Map<ChartDataType, int>> chartData = {};

    for (var i = intervalStart;
        i.isBefore(intervalEnd);
        i = i.add(const Duration(days: 1))) {
      final dayData = LinkedHashMap<ChartDataType, int>();

      for (var workout in workoutsHistory) {
        final workoutDate = workout.timestamp.toDate();

        if (workoutDate.year == i.year &&
            workoutDate.month == i.month &&
            workoutDate.day == i.day) {
          dayData.update(ChartDataType.exercises,
              (value) => value + workout.numOfExercises,
              ifAbsent: () => workout.numOfExercises);
          dayData.update(
              ChartDataType.sets, (value) => value + workout.numOfSets,
              ifAbsent: () => workout.numOfSets);
          dayData.update(
              ChartDataType.time, (value) => value + workout.timeInSeconds,
              ifAbsent: () => workout.timeInSeconds);
        }
      }

      if (chartTime == ChartTime.lastWeek) {
        chartData[_getWeekdayName(i)] = dayData;
      }
      if (chartTime == ChartTime.thisMonth) {
        chartData[i.day.toString()] = dayData;
      }
      if (chartTime == ChartTime.allTime) {
        chartData[i.day.toString()] = dayData;
      }
    }

    return chartData;
  }

  String _getWeekdayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
