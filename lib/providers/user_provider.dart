import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/total_stats_data.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/services/plans_service.dart';
import 'package:gym_partner/services/users_service.dart';

final plansService = PlansService();
final usersService = UsersService();

final userProvider =
    StateNotifierProvider<UserNotifier, AppUser>((ref) => UserNotifier());

class UserNotifier extends StateNotifier<AppUser> {
  UserNotifier()
      : super(AppUser(
          id: '',
          username: '',
          email: '',
          plansData: [],
          workoutsHistory: [],
          totalStatsData: TotalStatsData(),
        ));

  Future<void> getUserData() async {
    state = await usersService.currentUserData;
  }

  Future<void> incrementCurrentDayIndex(Plan plan) async {
    AppUser? updatedUser;
    try {
      updatedUser = await usersService.incrementCurrentDayIndex(plan);
    } finally {
      if (updatedUser != null) {
        state = updatedUser;
      }
    }
  }

  Future<void> addNewPlanData(String planId) async {
    AppUser? updatedUser;
    try {
      updatedUser = await usersService.addNewPlanData(planId);
    } finally {
      if (updatedUser != null) {
        state = updatedUser;
      }
    }
  }

  Future<void> deletePlanData(String planId) async {
    AppUser? updatedUser;
    try {
      updatedUser = await usersService.deletePlanData(planId);
    } finally {
      if (updatedUser != null) {
        state = updatedUser;
      }
    }
  }

  Future<void> finishWorkout(Plan plan, int workoutTime) async {
    AppUser? updatedUser;
    try {
      updatedUser = await usersService.addWorkoutInHistory(plan, workoutTime);
    } finally {
      if (updatedUser != null) {
        state = updatedUser;
      }
    }
  }

  Future<void> setPlanAsRecent(String planId) async {
    AppUser? updatedUser;
    try {
      updatedUser = await usersService.setPlanAsRecent(planId);
    } finally {
      if (updatedUser != null) {
        state = updatedUser;
      }
    }
  }
}
