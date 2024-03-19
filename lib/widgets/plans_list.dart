import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/widgets/plan_card.dart';

class PlansList extends ConsumerWidget {
  const PlansList({super.key, required this.plans, required this.onSelectPlan});

  final List<Plan> plans;
  final void Function(Plan plan) onSelectPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (ctx, index) => PlanCard(
        plan: plans[index],
        onSelectPlan: onSelectPlan,
      ),
    );
  }
}
