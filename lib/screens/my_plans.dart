import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_filter_criteria.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/new_plan.dart';
import 'package:gym_partner/screens/plan_details.dart';
import 'package:gym_partner/widgets/badges/custom_filter_chip.dart';
import 'package:gym_partner/widgets/plans_list.dart';

class MyPlansScreen extends ConsumerStatefulWidget {
  const MyPlansScreen({super.key});

  @override
  ConsumerState<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends ConsumerState<MyPlansScreen> {
  MyPlansCategory _selectedFilterCriteria = MyPlansCategory.all;

  int _allPlansCount = 0;
  int _myPlansCount = 0;
  int _ongoingPlansCount = 0;
  int _downloadedPlansCount = 0;
  int _publishedPlansCount = 0;

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

  void _selectFilterCriteria(MyPlansCategory criteria) {
    setState(() {
      _selectedFilterCriteria = criteria;
    });
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(userPlansProvider);
    final userData = ref.watch(userProvider);
    final plansData = userData.plansData;

    _allPlansCount = plans.length;
    _myPlansCount = plans
        .where((plan) =>
            planFilterCriteriaConditions[MyPlansCategory.my]!(plan, userData))
        .length;
    _ongoingPlansCount = plans
        .where((plan) => planFilterCriteriaConditions[MyPlansCategory.ongoing]!(
            plan, userData))
        .length;
    _downloadedPlansCount = plans
        .where((plan) =>
            planFilterCriteriaConditions[MyPlansCategory.downloaded]!(
                plan, userData))
        .length;

    _publishedPlansCount = plans
        .where((plan) =>
            planFilterCriteriaConditions[MyPlansCategory.published]!(
                plan, userData))
        .length;

    Widget content() {
      final filterCondition =
          planFilterCriteriaConditions[_selectedFilterCriteria] ??
              (Plan plan, AppUser userData) => true;
      final filteredPlans =
          plans.where((plan) => filterCondition(plan, userData)).toList();

      final List<Plan> sortedPlans = [];

      String? recentPlanId;

      for (final planData in plansData) {
        if (planData.isRecent) {
          try {
            var foundPlan =
                filteredPlans.firstWhere((plan) => plan.id == planData.planId);
            recentPlanId = planData.planId;
            sortedPlans.add(foundPlan);
          } catch (e) {}
        }
      }

      sortedPlans
          .addAll(filteredPlans.where((plan) => plan.id != recentPlanId));

      if (sortedPlans.isEmpty) {
        return _centerMessage(
            context,
            _selectedFilterCriteria == MyPlansCategory.all
                ? 'You don\'t have any workout plans yet.'
                : 'Couldn\'t find any plans matching selected criteria.');
      } else {
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
          _filterChip(MyPlansCategory.all, _allPlansCount),
          _filterChip(MyPlansCategory.my, _myPlansCount),
          _filterChip(MyPlansCategory.ongoing, _ongoingPlansCount),
          _filterChip(MyPlansCategory.downloaded, _downloadedPlansCount),
          _filterChip(MyPlansCategory.published, _publishedPlansCount),
        ],
      ),
    );

    var listTitle = Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
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
          if (_selectedFilterCriteria != MyPlansCategory.all)
            Expanded(
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _selectFilterCriteria(MyPlansCategory.all),
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

  Widget _filterChip(MyPlansCategory criteria, int number) {
    final isSelected = _selectedFilterCriteria == criteria;
    return CustomFilterChip(
      text: planFilterCriteriaChipNames[criteria] ?? '',
      number: number,
      onTap: () => _selectFilterCriteria(criteria),
      isSelected: isSelected,
      hasTick: true,
    );
  }
}
