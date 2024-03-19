import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/widgets/plan_tag_badge.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.plan, required this.onSelectPlan});

  final Plan plan;
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
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  numOfDaysIndicator,
                ],
              ),
              const SizedBox(height: 8),
              tags,
            ],
          ),
        ),
      ),
    );
  }
}
