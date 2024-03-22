import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/providers/public_plans_provider.dart';
import 'package:gym_partner/screens/plan_details.dart';
import 'package:gym_partner/widgets/custom_filter_chip.dart';
import 'package:gym_partner/widgets/plans_list.dart';
import 'package:gym_partner/widgets/shared_plans_filters.dart';

class SharedPlansScreen extends ConsumerStatefulWidget {
  const SharedPlansScreen({super.key});

  @override
  ConsumerState<SharedPlansScreen> createState() => _SharedPlansScreenState();
}

class _SharedPlansScreenState extends ConsumerState<SharedPlansScreen> {
  final _searchController = TextEditingController();
  List<PlanTag> _selectedTags = [];
  PlanDifficulty? _selectedDifficulty;
  List<Plan> _filteredPlans = [];

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

  void _applyFilters() {
    final plans = ref.read(publicPlansProvider);
    setState(() {
      _filteredPlans = _filterPlans(plans);
    });
  }

  void _onSearchChanged() {
    const Duration debounceTime = Duration(milliseconds: 300);

    Future.delayed(debounceTime, () {
      _applyFilters();
    });
  }

  List<Plan> _filterPlans(List<Plan> plans) {
    final searchQuery = _searchController.text;
    return _filterPlansByQuery(searchQuery,
        _filterPlansBySelectedDifficulty(_filterPlansBySelectedTags(plans)));
  }

  List<Plan> _filterPlansByQuery(String searchQuery, List<Plan> plans) {
    final query = searchQuery.toLowerCase();
    if (query.isEmpty) {
      return plans;
    }
    return plans
        .where((plan) => plan.name.toLowerCase().contains(query))
        .toList();
  }

  List<Plan> _filterPlansBySelectedTags(List<Plan> plans) {
    if (_selectedTags.isEmpty) {
      return plans;
    }
    return plans
        .where((plan) => _selectedTags.every((tag) => plan.tags.contains(tag)))
        .toList();
  }

  List<Plan> _filterPlansBySelectedDifficulty(List<Plan> plans) {
    if (_selectedDifficulty == null) {
      return plans;
    }
    return plans
        .where((plan) => _selectedDifficulty == plan.difficulty)
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

  void _showFiltersModal() async {
    final selectedFilters =
        await showModalBottomSheet<Map<PlanFilterCriteria, dynamic>>(
            isScrollControlled: true,
            context: context,
            builder: (context) => SharedPlansFilters(
                  tags: _selectedTags,
                  difficulty: _selectedDifficulty,
                ));

    _selectedDifficulty = selectedFilters?[PlanFilterCriteria.difficulty];
    _selectedTags = selectedFilters?[PlanFilterCriteria.tags] ?? [];

    _applyFilters();
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
                  onPressed: _showFiltersModal,
                  icon: Icon(Icons.tune),
                ),
              ],
            ),
            // if (_showFilters) filtersSection,
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
