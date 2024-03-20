import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/user.dart';

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
      return await currentUserData;
    } catch (e) {
      print("Error updating current day index: $e");
      return null;
    }
  }
}
