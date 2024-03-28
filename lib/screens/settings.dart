import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/total_stats_data.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/services/history_service.dart';
import 'package:gym_partner/widgets/chart/chart.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('username: ${userData.username}'),
            Text('email: ${userData.email}'),
            ElevatedButton(onPressed: _signOut, child: const Text('Sign out')),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userData.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No data found...'),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong...'),
                    );
                  }

                  final data = snapshot.data!.data()!;
                  final totalStatsData =
                      TotalStatsData.fromMap(data["total_stats_data"]);

                  return Text(
                      'last week exercises count: ${totalStatsData.weekTotalStatsData[ChartDataType.exercises]}');
                }),
          ],
        ),
      ),
    );
  }
}
