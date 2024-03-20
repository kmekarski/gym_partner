import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan_tag.dart';

class PlanBadge extends StatelessWidget {
  PlanBadge(this.tag, {super.key});

  final PlanTag tag;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
