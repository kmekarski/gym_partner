import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan_tag.dart';

class PlanTagBadge extends StatelessWidget {
  PlanTagBadge(this.tag, {super.key});

  final PlanTag tag;

  final Map<PlanTag, IconData> tagIcons = {
    PlanTag.beginner: Icons.directions_walk,
    PlanTag.intermediate: Icons.directions_run,
    PlanTag.expert: Icons.sports_gymnastics,
    PlanTag.strength: Icons.fitness_center,
    PlanTag.cardio: Icons.favorite,
    PlanTag.yoga: Icons.self_improvement,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              tagIcons[tag],
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              tag.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
