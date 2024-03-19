import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/services/plans_service.dart';
import 'package:gym_partner/services/users_service.dart';

final plansService = PlansService();
final usersService = UsersService();

final userProvider =
    StateNotifierProvider<UserNotifier, AppUser>((ref) => UserNotifier());

class UserNotifier extends StateNotifier<AppUser> {
  UserNotifier()
      : super(AppUser(id: '', username: '', email: '', plansData: []));

  Future<void> getUserData() async {
    state = await usersService.currentUserData;
  }
}
