import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/services/plans_service.dart';
import 'package:gym_partner/services/users_service.dart';

final plansService = PlansService();
final usersService = UsersService();

final publicPlansProvider =
    StateNotifierProvider<PublicPlansNotifier, List<Plan>>(
        (ref) => PublicPlansNotifier());

class PublicPlansNotifier extends StateNotifier<List<Plan>> {
  PublicPlansNotifier() : super([]);

  Future<void> getPlans() async {
    state = await plansService.getPublicPlans();
  }
}
