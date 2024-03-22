import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_filter_criteria.dart';
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
  PlanFilterCriteria _selectedFilterCriteria = PlanFilterCriteria.all;

  void _selectPlan(BuildContext context, Plan plan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlanDetailsScreen(
          type: PlansListType.private,
          plan: plan,
        ),
      ),
    );
  }

  void _selectFilterCriteria(PlanFilterCriteria criteria) {
    setState(() {
      _selectedFilterCriteria = criteria;
    });
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
        final List<Plan> sortedPlans = [];

        String? recentPlanId;

        for (final planData in plansData) {
          if (planData.isRecent) {
            recentPlanId = planData.planId;
            sortedPlans
                .add(plans.firstWhere((plan) => plan.id == planData.planId));
          }
        }

        sortedPlans.addAll(plans.where((plan) => plan.id != recentPlanId));

        return PlansList(
            type: PlansListType.private,
            plans: sortedPlans,
            onSelectPlan: (plan) => _selectPlan(context, plan));
      }
    }

    var appBar = AppBar(
      title: const Text(
        'My workout plans',
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

    var filterChips = Container(
      height: 44,
      margin: const EdgeInsets.only(top: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _filterButton(PlanFilterCriteria.all, 11),
          _filterButton(PlanFilterCriteria.my, 22),
          _filterButton(PlanFilterCriteria.ongoing, 3),
          _filterButton(PlanFilterCriteria.downloaded, 44),
        ],
      ),
    );

    var listTitle = Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            planFilterCriteriaTitleNames[_selectedFilterCriteria] ?? '',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (_selectedFilterCriteria != PlanFilterCriteria.all)
            Expanded(
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _selectFilterCriteria(PlanFilterCriteria.all),
                    child: Row(
                      children: [
                        Text(
                          'See all',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            filterChips,
            listTitle,
            Expanded(
              child: content(),
            ),
          ],
        ),
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

  Widget _filterButton(PlanFilterCriteria criteria, int number) {
    final isSelected = _selectedFilterCriteria == criteria;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () => _selectFilterCriteria(criteria),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(isSelected ? 0.16 : 0.08),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Text(
                planFilterCriteriaChipNames[criteria] ?? '',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: _selectedFilterCriteria == criteria
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
