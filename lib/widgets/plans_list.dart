import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/widgets/plan_card.dart';

class PlansList extends ConsumerWidget {
  const PlansList({super.key, required this.plans, required this.onSelectPlan});

  final List<Plan> plans;
  final void Function(Plan plan) onSelectPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansData = ref.watch(userProvider).plansData;

    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (ctx, index) {
        final planData = plansData.firstWhere(
          (data) => data.planId == plans[index].id,
        );
        return PlanCard(
          plan: plans[index],
          planData: planData,
          onSelectPlan: onSelectPlan,
        );
      },
    );
  }
}
