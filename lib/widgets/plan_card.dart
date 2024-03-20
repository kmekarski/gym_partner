import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/widgets/form_clickable_badge.dart';
import 'package:gym_partner/widgets/plan_badge.dart';

class PlanCard extends StatelessWidget {
  const PlanCard(
      {super.key,
      required this.plan,
      required this.planData,
      required this.onSelectPlan});

  final Plan plan;
  final UserPlanData planData;
  final void Function(Plan plan) onSelectPlan;

  @override
  Widget build(BuildContext context) {
    var numOfDaysIndicator = Row(
      children: [
        Icon(
          Icons.calendar_month,
          size: 30,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 4),
        Text(
          '${plan.days.length}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );

    var difficultyBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Text(
        plan.difficulty.toString().split('.').last,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );

    var tags = Row(
      children: [
        for (PlanTag tag in plan.tags)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              tag.toString().split('.').last,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
            ),
          ),
      ],
    );

    var progressCircle = Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: planData.currentDayIndex / plan.days.length,
              strokeWidth: 6,
              backgroundColor: Colors.black12,
            ),
          ),
          Text(
            '${plan.getCompletionPercentage(planData.currentDayIndex)}%',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectPlan(plan);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 130,
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
                    progressCircle
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    difficultyBadge,
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
