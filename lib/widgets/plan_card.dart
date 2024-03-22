import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/widgets/plans_list.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.type,
    this.planData,
    required this.plan,
    required this.onSelectPlan,
  });

  final PlansListType type;
  final Plan plan;
  final UserPlanData? planData;
  final void Function(Plan plan) onSelectPlan;

  @override
  Widget build(BuildContext context) {
    var numOfDaysIndicator = Row(
      children: [
        Icon(
          Icons.calendar_month,
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '${plan.days.length}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
      ],
    );

    var difficultyBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).colorScheme.primary),
      child: Text(
        planDifficultyStrings[plan.difficulty] ?? '',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );

    var isRecentBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.15)),
      child: Text(
        'Recent workout',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
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

    var progressCircle = planData != null
        ? Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: planData!.currentDayIndex / plan.days.length,
                    strokeWidth: 6,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${plan.getCompletionPercentage(planData!.currentDayIndex)}%',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        : null;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onSelectPlan(plan);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 124,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        tags,
                      ],
                    ),
                    if (planData != null) progressCircle!,
                    if (planData == null) Text(plan.authorName),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    difficultyBadge,
                    if (planData != null && planData!.isRecent)
                      Row(
                        children: [
                          const SizedBox(width: 6),
                          isRecentBadge,
                        ],
                      ),
                    const Spacer(),
                    numOfDaysIndicator,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
