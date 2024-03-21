import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/new_plan.dart';
import 'package:gym_partner/screens/plan_details.dart';
import 'package:gym_partner/widgets/plans_list.dart';

class MyPlansScreen extends ConsumerStatefulWidget {
  const MyPlansScreen({super.key});

  @override
  ConsumerState<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends ConsumerState<MyPlansScreen> {
  void _selectPlan(BuildContext context, Plan plan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlanDetailsScreen(plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(userPlansProvider);
    final plansData = ref.watch(userProvider).plansData;

    Widget content() {
      if (plans.isEmpty) {
        return _centerMessage(
            context, 'You haven\'t created any workout plans yet.');
      } else {
        final recentPlanId =
            plansData.firstWhere((planData) => planData.isRecent).planId;
        final recentPlan = plans.firstWhere((plan) => plan.id == recentPlanId);
        final restOfPlans = plans.where((plan) => plan.id != recentPlanId);
        final sortedPlans = [recentPlan, ...restOfPlans];
        return PlansList(
            plans: sortedPlans,
            onSelectPlan: (plan) => _selectPlan(context, plan));
      }
    }

    var appBar = AppBar(
      title: const Text(
        'My workout plans',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
      ),
      actions: [
        IconButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewPlanScreen(),
                  ),
                ),
            icon: const Icon(Icons.add))
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: content(),
      ),
    );
  }

  Widget _centerMessage(BuildContext context, String text) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
