import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/widgets/plans_list.dart';
import 'package:gym_partner/widgets/simple_badge.dart';

class PlanDetailsScreen extends ConsumerWidget {
  const PlanDetailsScreen({super.key, required this.type, required this.plan});

  final PlansListType type;
  final Plan plan;

  void _downloadPlan(WidgetRef ref) async {
    final downloadedPlan =
        await ref.read(userPlansProvider.notifier).downloadPlan(plan);
    if (downloadedPlan != null) {
      await ref.read(userProvider.notifier).addNewPlanData(downloadedPlan!.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planData = ref
        .read(userProvider)
        .plansData
        .firstWhere((planData) => planData.planId == plan.id);
    var authorInfo = Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage('assets/images/default.png'),
        ),
        const SizedBox(width: 10),
        Text(
          'Created by: ${plan.authorName}',
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
    var tags = Row(
      children: [
        for (PlanTag tag in plan.tags)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              planTagStrings[tag] ?? '',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
      ],
    );
    var badges = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SimpleBadge(
            text: planDifficultyStrings[plan.difficulty] ?? '',
            textColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        for (final tag in plan.tags)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SimpleBadge(
                text: planTagStrings[tag] ?? '',
                textColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary),
          ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
        actions: [
          if (type == PlansListType.private)
            IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 36),
        child: Column(
          children: [
            authorInfo,
            const SizedBox(height: 16),
            badges,
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                child: type == PlansListType.private
                    ? ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) => planDayCard(
                            plan.days[planData.currentDayIndex],
                            planData.currentDayIndex,
                            context),
                      )
                    : ListView.builder(
                        itemCount: plan.days.length,
                        itemBuilder: (context, index) =>
                            planDayCard(plan.days[index], index, context),
                      ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () async {
                  if (type == PlansListType.private) {
                    await ref
                        .read(userProvider.notifier)
                        .incrementCurrentDayIndex(plan);
                    await ref
                        .read(userProvider.notifier)
                        .setPlanAsRecent(plan.id);
                  }
                  if (type == PlansListType.public) {}
                },
                child: Text(type == PlansListType.private
                    ? 'Start workout'
                    : 'Add to your plans'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card planDayCard(PlanDay day, int dayIndex, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Day ${dayIndex + 1}${type == PlansListType.private ? ' / ${plan.days.length}' : ''}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (day.exercises.isEmpty)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rest day',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            for (final (index, exercise) in day.exercises.indexed)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0) Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${exercise.exercise.name}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                            '${exercise.numOfSets} sets, ${exercise.numOfReps} reps',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
