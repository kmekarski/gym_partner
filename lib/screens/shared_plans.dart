import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/providers/public_plans_provider.dart';
import 'package:gym_partner/screens/plan_details.dart';
import 'package:gym_partner/widgets/custom_filter_chip.dart';
import 'package:gym_partner/widgets/plans_list.dart';

class SharedPlansScreen extends ConsumerStatefulWidget {
  const SharedPlansScreen({super.key});

  @override
  ConsumerState<SharedPlansScreen> createState() => _SharedPlansScreenState();
}

class _SharedPlansScreenState extends ConsumerState<SharedPlansScreen> {
  final _searchController = TextEditingController();
  List<Plan> _filteredPlans = [];
  bool _showFilters = false;

  @override
  void initState() {
    _filteredPlans = ref.read(publicPlansProvider);
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text;

    const Duration debounceTime = Duration(milliseconds: 300);

    Future.delayed(debounceTime, () {
      final plans = ref.read(publicPlansProvider);
      setState(() {
        _filteredPlans = _filterPlans(searchQuery, plans);
      });
    });
  }

  List<Plan> _filterPlans(String searchQuery, List<Plan> plans) {
    final query = searchQuery.toLowerCase();
    if (query.isEmpty) {
      return plans;
    }
    return plans
        .where((plan) => plan.name.toLowerCase().contains(query))
        .toList();
  }

  void _selectPlan(Plan plan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlanDetailsScreen(
          type: PlansListType.public,
          plan: plan,
        ),
      ),
    );
  }

  void _toggleShowFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    var searchbar = Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: SearchBar(
        controller: _searchController,
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.search),
        ),
        trailing: [
          IconButton(
            onPressed: () => _searchController.clear(),
            icon: const Icon(Icons.close),
          ),
        ],
        hintText: 'Search for plans...',
      ),
    );

    var filterChips = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Text(
                  'Tags:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final tag in PlanTag.values)
                        CustomFilterChip(
                            text: planTagStrings[tag] ?? '',
                            onTap: () {},
                            isSelected: false)
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Text(
                  'Difficulty:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final difficulty in PlanDifficulty.values)
                        CustomFilterChip(
                            text: planDifficultyStrings[difficulty] ?? '',
                            onTap: () {},
                            isSelected: false)
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Other users\' workout plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: searchbar),
                IconButton(
                  onPressed: _toggleShowFilters,
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
            if (_showFilters) filterChips,
            Expanded(
              child: _buildContent(_filteredPlans),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<Plan> plans) {
    if (plans.isEmpty) {
      return _centerMessage(
          context,
          _searchController.text.isEmpty
              ? 'Couldn\'t find any other user\'s plans.'
              : 'Couldn\'t find any plans matching your criteria.');
    } else {
      return PlansList(
        type: PlansListType.public,
        plans: plans,
        onSelectPlan: _selectPlan,
      );
    }
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
