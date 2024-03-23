import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/body_part.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/workout.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/plan_day_card.dart';
import 'package:gym_partner/widgets/plans_list.dart';
import 'package:gym_partner/widgets/badges/simple_badge.dart';

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

  void _startWorkout(PlanDay day, WidgetRef ref, BuildContext context) async {
    if (type == PlansListType.private) {
      // await ref.read(userProvider.notifier).incrementCurrentDayIndex(plan);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => WorkoutScreen(day: day),
      ));
      ref.read(userProvider.notifier).setPlanAsRecent(plan.id);
    }
    if (type == PlansListType.public) {}
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
          radius: 24,
          backgroundImage: AssetImage('assets/images/default.png'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created by',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              plan.authorName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
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

    var badges = SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
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
      ),
    );

    var todaysActivitySection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Today\'s activity', context),
        _planDayCard(plan.days[planData.currentDayIndex],
            planData.currentDayIndex, context),
        const SizedBox(height: 16),
        _sectionTitle('Whole plan', context),
      ],
    );

    var daysList = Expanded(
      child: ListView.builder(
        itemCount: plan.days.length,
        itemBuilder: (context, index) =>
            _planDayCard(plan.days[index], index, context),
      ),
    );

    var bottomButton = WideButton(
      text:
          type == PlansListType.private ? 'Start workout' : 'Add to your plans',
      icon: null,
      onPressed: () =>
          _startWorkout(plan.days[planData.currentDayIndex], ref, context),
    );
    var appBar = AppBar(
      title: Text(plan.name),
      actions: [
        if (type == PlansListType.private)
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            authorInfo,
            const SizedBox(height: 16),
            badges,
            const SizedBox(height: 16),
            if (type == PlansListType.private) todaysActivitySection,
            daysList,
            const SizedBox(height: 16),
            bottomButton,
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _planDayCard(PlanDay day, int dayIndex, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Day ${dayIndex + 1}',
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
              PlanExerciseRow(exercise: exercise, index: index)
          ],
        ),
      ),
    );
  }
}
