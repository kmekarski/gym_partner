import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/models/workout_in_history.dart';
import 'package:jiffy/jiffy.dart';

enum ChartDataType {
  exercises,
  sets,
  time,
}

enum ChartTime {
  lastWeek,
  thisMonth,
  allTime,
}

Map<ChartTime, bool Function(DateTime date)> chartTimeConditions = {
  ChartTime.lastWeek: (date) {
    final now = DateTime.now();
    final sixDaysBefore = now.subtract(const Duration(days: 6));
    return date.isAfter(DateTime(
            sixDaysBefore.year, sixDaysBefore.month, sixDaysBefore.day)) &&
        date.isBefore(now);
  },
  ChartTime.thisMonth: (date) {
    final now = DateTime.now();
    return date.month == now.month &&
        date.year == now.year &&
        date.isBefore(now);
  },
  ChartTime.allTime: (date) => date.isBefore(DateTime.now())
};

class HistoryService {
  DocumentReference<Map<String, dynamic>> userDocRef(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  User get currentUser {
    return FirebaseAuth.instance.currentUser!;
  }

  Future<AppUser> get currentUserData async {
    return AppUser.fromFirestore((await userDocRef(currentUser.uid).get()));
  }
}
