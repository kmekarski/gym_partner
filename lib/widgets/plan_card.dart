import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/widgets/plan_tag_badge.dart';

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
        const Icon(
          Icons.calendar_month,
          size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          '${plan.days.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );

    var tags = Row(
      children: [
        for (PlanTag tag in plan.tags) PlanTagBadge(tag),
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
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectPlan(plan);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: SizedBox(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    progressCircle
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tags,
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
