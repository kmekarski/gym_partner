import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan.dart';

class PlanDetailsScreen extends StatelessWidget {
  const PlanDetailsScreen({super.key, required this.plan});

  final Plan plan;

  @override
  Widget build(BuildContext context) {
    print(plan.days);
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
      ),
      body: Center(
        child: Column(
          children: [
            Text(plan.name),
            Text('${plan.days.length} day(s)'),
          ],
        ),
      ),
    );
  }
}
