import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/services/plans_service.dart';
import 'package:gym_partner/services/users_service.dart';

final plansService = PlansService();
final usersService = UsersService();

final userPlansProvider = StateNotifierProvider<UserPlansNotifier, List<Plan>>(
    (ref) => UserPlansNotifier());

class UserPlansNotifier extends StateNotifier<List<Plan>> {
  UserPlansNotifier() : super([]);

  Future<void> getUserPlans() async {
    state = await plansService.getUserPlans();
  }

  Future<void> addNewPlan(Plan plan) async {
    Plan? addedPlan;
    try {
      addedPlan = await plansService.addUserPlan(plan);
    } finally {
      if (addedPlan != null) {
        state = [...state, addedPlan];
      }
    }
  }
}
