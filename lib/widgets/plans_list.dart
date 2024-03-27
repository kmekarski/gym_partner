import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/user_plan_data.dart';
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
    final plansData = ref.watch(userProvider).plansData;

    Widget? listItemBuilder(BuildContext ctx, int index) {
      if (type == PlansListType.private) {
        final planData = plansData.firstWhere(
          (data) => data.planId == plans[index].id,
        );
        return PlanCard(
          type: type,
          plan: plans[index],
          planData: planData,
          onSelectPlan: onSelectPlan,
        );
      } else {
        return PlanCard(
          type: type,
          plan: plans[index],
          onSelectPlan: onSelectPlan,
        );
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plans.length,
      itemBuilder: listItemBuilder,
    );
  }
}
