import 'package:flutter/material.dart';

class FinishedWorkoutScreen extends StatefulWidget {
  const FinishedWorkoutScreen({super.key});

  @override
  State<FinishedWorkoutScreen> createState() => _FinishedWorkoutScreenState();
}

class _FinishedWorkoutScreenState extends State<FinishedWorkoutScreen> {
  void _goToMyPlans() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('finished!'),
            ElevatedButton(
              onPressed: _goToMyPlans,
              child: const Text('go to my plans'),
            ),
          ],
        ),
      ),
    );
  }
}
