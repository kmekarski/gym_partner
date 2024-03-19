import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/user_plan_data.dart';

class AppUser {
  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.plansData,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    List<dynamic> plansDataData = data['plansData'] ?? [];
    List<UserPlanData> plansData = plansDataData.map((planData) {
      return UserPlanData(
          planId: planData['plan_id'],
          currentDayIndex: planData['current_day_index']);
    }).toList();

    print(data['username']);
    return AppUser(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'],
      plansData: plansData,
    );
  }

  final String id;
  final String username;
  final String email;
  final List<UserPlanData> plansData;
}
