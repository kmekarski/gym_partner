import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/services/users_service.dart';

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

  Future<Plan?> addUserPlan(Plan plan) async {
    try {
      DocumentReference planDocRef = await userDocRef(currentUser.uid)
          .collection('plans')
          .add(plan.toFirestore());

      final planId = planDocRef.id;
      planDocRef.update({'id': planId});

      final userData = await currentUserData;

      return Plan(
        id: planId,
        name: plan.name,
        days: plan.days,
        tags: plan.tags,
        authorName: userData.username,
      );
    } catch (e) {
      print("Error adding user's plan to Firebase: $e");
      return null;
    }
  }
}
