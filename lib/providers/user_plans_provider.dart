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

  Future<Plan?> addNewPlan(Plan plan) async {
    Plan? addedPlan;
    try {
      addedPlan = await plansService.addUserPlan(plan);
    } finally {
      if (addedPlan != null) {
        state = [...state, addedPlan];
      }
    }
    return addedPlan;
  }

  Future<Plan?> downloadPlan(Plan plan) async {
    Plan? downloadedPlan;
    try {
      downloadedPlan = await plansService.downloadPlan(plan);
    } finally {
      if (downloadedPlan != null) {
        state = [...state, downloadedPlan];
      }
    }
    return downloadedPlan;
  }

  Future<void> deletePlan(Plan planToDelete) async {
    bool? didDelete;
    try {
      didDelete = await plansService.deletePlan(planToDelete);
    } finally {
      if (didDelete == true) {
        List<Plan> newState = [];
        for (final plan in state) {
          if (plan.id != planToDelete.id) {
            newState.add(plan);
          }
        }
        state = newState;
      }
    }
  }
}
