import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/widgets/plan_card.dart';

enum PlansListType {
  private,
  public,
}

class PlansList extends ConsumerWidget {
  const PlansList({
    super.key,
    required this.type,
    required this.plans,
    required this.onSelectPlan,
  });

  final PlansListType type;
  final List<Plan> plans;
  final void Function(Plan plan) onSelectPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (type == PlansListType.private) {
      final plansData = ref.watch(userProvider).plansData;
      return ListView.builder(
        itemCount: plans.length,
        itemBuilder: (ctx, index) {
          for (final planData in plansData) {}
          final planData = plansData.firstWhere(
            (data) => data.planId == plans[index].id,
          );
          return PlanCard(
            type: type,
            plan: plans[index],
            planData: planData,
            onSelectPlan: onSelectPlan,
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: plans.length,
        itemBuilder: (ctx, index) {
          return PlanCard(
            type: type,
            plan: plans[index],
            onSelectPlan: onSelectPlan,
          );
        },
      );
    }
  }
}
