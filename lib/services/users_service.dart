import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/models/user_plan_data.dart';

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
          plansData: plansData);
      return updatedUserData;
    } catch (e) {
      print("Error updating current day index: $e");
      return null;
    }
  }
}
