import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/providers/public_plans_provider.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/widgets/plans_list.dart';

class SharedPlansScreen extends ConsumerStatefulWidget {
  const SharedPlansScreen({super.key});

  @override
  ConsumerState<SharedPlansScreen> createState() => _SharedPlansScreenState();
}

class _SharedPlansScreenState extends ConsumerState<SharedPlansScreen> {
  late Future<void> _plansFuture;

  @override
  void initState() {
    _plansFuture = ref.read(publicPlansProvider.notifier).getPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(publicPlansProvider);
    print(plans);

    Widget content() {
      if (plans.isEmpty) {
        return _centerMessage(
            context, 'Couldn\'t find any other user\s plans.');
      } else {
        return PlansList(
          type: PlansListType.public,
          plans: plans,
          onSelectPlan: (plan) => {},
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Other users\' workout plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FutureBuilder(
            future: _plansFuture,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : content();
            }),
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
