import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_exercise.dart';
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
            Text('id: ${plan.id}'),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              height: 200,
              child: ListView.builder(
                itemCount: plan.days.length,
                itemBuilder: (context, index) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Day ${index + 1}'),
                        const SizedBox(height: 8),
                        if (plan.days[index].exercises.isEmpty)
                          const Text('Rest day'),
                        for (final exercise in plan.days[index].exercises)
                          Text(exerciseString(exercise)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).incrementCurrentDayIndex(plan);
              },
              child: const Text('day index + 1'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).setPlanAsRecent(plan.id);
              },
              child: const Text('set as recent'),
            ),
          ],
        ),
      ),
    );
  }

  String exerciseString(PlanExercise exercise) {
    return '${exercise.exercise.name} (sets:${exercise.numOfSets}, reps:${exercise.numOfReps}, rest:${exercise.restTime}s)';
  }
}
