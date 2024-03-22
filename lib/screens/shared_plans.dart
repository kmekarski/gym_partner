import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/providers/public_plans_provider.dart';
import 'package:gym_partner/screens/plan_details.dart';
import 'package:gym_partner/widgets/plans_list.dart';

class SharedPlansScreen extends ConsumerStatefulWidget {
  const SharedPlansScreen({super.key});

  @override
  ConsumerState<SharedPlansScreen> createState() => _SharedPlansScreenState();
}

class _SharedPlansScreenState extends ConsumerState<SharedPlansScreen> {
  final _searchController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    var searchbar = SearchBar(
      controller: _searchController,
      leading: Icon(Icons.search),
      trailing: [Icon(Icons.close)],
      hintText: 'Search for plans...',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Other users\' workout plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            searchbar,
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
