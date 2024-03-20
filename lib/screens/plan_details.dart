import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/providers/user_provider.dart';

class PlanDetailsScreen extends ConsumerWidget {
  const PlanDetailsScreen({super.key, required this.plan});

  final Plan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
      ),
      body: Center(
        child: Column(
          children: [
            Text(plan.name),
            Text('${plan.days.length} day(s)'),
            ElevatedButton(
                onPressed: () {
                  ref
                      .read(userProvider.notifier)
                      .incrementCurrentDayIndex(plan);
                },
                child: Text('day index + 1'))
          ],
        ),
      ),
    );
  }
}
