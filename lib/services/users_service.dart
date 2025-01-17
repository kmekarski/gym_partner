import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/models/workout_in_history.dart';

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

  Future<AppUser?> deletePlanData(String planId) async {
    try {
      final userData = await currentUserData;
      userData.plansData.removeWhere(
        (planData) => planData.planId == planId,
      );
      await userDocRef(currentUser.uid).update({
        'plans_data': userData.plansData
            .map((planData) => planData.toFirestore())
            .toList(),
      });

      return userData;
    } catch (e) {
      print("Error deleting plan data: $e");
      return null;
    }
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

  Future<String> getUserAvatarUrl(String userId) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_avatars')
          .child('${userId}.jpg');
      final avatarUrl = await storageRef.getDownloadURL();
      return avatarUrl;
    } catch (e) {
      print("Error adding plan data: $e");
      return '';
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

  Future<bool> resetPassword(String email) async {
    bool returnedValue = false;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      returnedValue = true;
    } on FirebaseAuthException catch (e) {
      print("Error reseting password: $e");
      returnedValue = false;
    }
    return returnedValue;
  }

  Future<AppUser?> changeUserAvatar(File image) async {
    try {
      final userData = await currentUserData;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_avatars')
          .child('${userData.id}.jpg');
      await storageRef.putFile(image);
      final avatarUrl = await storageRef.getDownloadURL();

      await userDocRef(userData.id).update({
        'avatar_url': avatarUrl,
      });
      return AppUser(
        id: userData.id,
        username: userData.username,
        email: userData.email,
        plansData: userData.plansData,
        workoutsHistory: userData.workoutsHistory,
        totalStatsData: userData.totalStatsData,
        avatarUrl: avatarUrl,
      );
    } catch (e) {
      print("Error updating avatar: $e");
      return null;
    }
  }

  Future<AppUser?> changeUsername(
      String newUsername, String providedPassword) async {
    final userData = await currentUserData;
    AppUser? updatedUser;
    await checkCurrentPassword(
      providedPassword: providedPassword,
      onPasswordCorrect: () async {
        try {
          await userDocRef(currentUser.uid).update(
            {
              'username': newUsername,
            },
          );
          updatedUser = AppUser(
            id: userData.id,
            username: newUsername,
            email: userData.email,
            plansData: userData.plansData,
            workoutsHistory: userData.workoutsHistory,
            totalStatsData: userData.totalStatsData,
            avatarUrl: userData.avatarUrl,
          );
        } catch (e) {
          print("Error changing username: $e");
        }
      },
    );
    return updatedUser;
  }

  Future<AppUser?> changeEmail(String newEmail, String providedPassword) async {
    final userData = await currentUserData;
    AppUser? updatedUser;
    await checkCurrentPassword(
      providedPassword: providedPassword,
      onPasswordCorrect: () async {
        try {
          currentUser.verifyBeforeUpdateEmail(newEmail);
          await userDocRef(currentUser.uid).update(
            {
              'email': newEmail,
            },
          );
          updatedUser = AppUser(
            id: userData.id,
            username: userData.username,
            email: newEmail,
            plansData: userData.plansData,
            workoutsHistory: userData.workoutsHistory,
            totalStatsData: userData.totalStatsData,
            avatarUrl: userData.avatarUrl,
          );
        } catch (e) {
          print("Error changing email: $e");
        }
      },
    );
    return updatedUser;
  }

  Future<bool> changePassword(
      String newPassword, String providedPassword) async {
    bool returnedValue = false;
    await checkCurrentPassword(
      providedPassword: providedPassword,
      onPasswordCorrect: () async {
        try {
          await currentUser.updatePassword(newPassword);
          returnedValue = true;
        } catch (e) {
          print("Error changing password: $e");
          returnedValue = false;
        }
      },
    );
    return returnedValue;
  }

  Future<void> checkCurrentPassword({
    required String providedPassword,
    required void Function() onPasswordCorrect,
  }) async {
    if (currentUser.email == null) {
      return;
    }
    var credential = EmailAuthProvider.credential(
      email: currentUser.email!,
      password: providedPassword,
    );
    await currentUser
        .reauthenticateWithCredential(credential)
        .then((value) => onPasswordCorrect())
        .catchError((er) => {});
  }

  Future<AppUser?> addWorkoutInHistory(
      Plan plan, int workoutTimeInSeconds) async {
    try {
      final userData = await currentUserData;
      final plansData = userData.plansData;
      final currentWorkoutsHistory = userData.workoutsHistory;

      final dayIndex = plansData
          .firstWhere((planData) => planData.planId == plan.id)
          .currentDayIndex;
      final day = plan.days[dayIndex];
      final numOfExercises = day.exercises.length;

      int numOfSets = 0;
      for (final exercise in day.exercises) {
        numOfSets += exercise.numOfSets;
      }

      final workoutInHistoryToAdd = WorkoutInHistory(
          id: currentWorkoutsHistory.length.toString(),
          planName: plan.name,
          tags: plan.tags,
          dayIndex: dayIndex,
          numOfSets: numOfSets,
          numOfExercises: numOfExercises,
          timeInSeconds: workoutTimeInSeconds,
          timestamp: Timestamp.now());

      final updatedWorkoutsHistory = [
        workoutInHistoryToAdd,
        ...currentWorkoutsHistory
      ];

      await userDocRef(currentUser.uid).update(
        {
          'workouts_history': updatedWorkoutsHistory
              .map((workoutInHistory) => workoutInHistory.toFirestore())
              .toList(),
        },
      );
      final updatedUserData = AppUser(
        id: userData.id,
        username: userData.username,
        email: userData.email,
        plansData: plansData,
        workoutsHistory: updatedWorkoutsHistory,
        totalStatsData: userData.totalStatsData,
        avatarUrl: userData.avatarUrl,
      );
      return updatedUserData;
    } catch (e) {
      print("Error adding workout in history: $e");
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
        plansData: plansData,
        workoutsHistory: userData.workoutsHistory,
        totalStatsData: userData.totalStatsData,
        avatarUrl: userData.avatarUrl,
      );
      return updatedUserData;
    } catch (e) {
      print("Error updating current day index: $e");
      return null;
    }
  }
}
