import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/utils/time_format.dart';
import 'package:gym_partner/widgets/badges/circle_icon.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';

class FinishedWorkoutScreen extends ConsumerStatefulWidget {
  const FinishedWorkoutScreen({
    super.key,
    required this.day,
    required this.timeInSeconds,
  });

  final PlanDay day;
  final int timeInSeconds;

  @override
  ConsumerState<FinishedWorkoutScreen> createState() =>
      _FinishedWorkoutScreenState();
}

class _FinishedWorkoutScreenState extends ConsumerState<FinishedWorkoutScreen> {
  void _goToMyPlans() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userProvider).username;
    final numOfExercises = widget.day.exercises.length;
    int numOfSets = 0;
    for (final exercise in widget.day.exercises) {
      numOfSets += exercise.numOfSets;
    }
    final timeString = timeFormat(widget.timeInSeconds);
    var headerTitle = Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: 'Nice job, ', // default text style
        style: Theme.of(context).textTheme.displaySmall,
        children: [
          TextSpan(
              text: username,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
    var bottomButton = WideButton(
      onPressed: _goToMyPlans,
      text: 'Go to my plans',
    );
    var headerMessage = Text(
      'Your workout is over, keep improving your training skills.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),
    );
    var statsContainer = Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                statRow(Icons.fitness_center, numOfExercises.toString(),
                    numOfExercises > 1 ? 'Exercises' : 'Exercise'),
                statRow(Icons.repeat, numOfSets.toString(),
                    numOfSets > 1 ? 'Sets' : 'Set'),
              ],
            ),
            statRow(Icons.schedule, timeString, ''),
          ],
        ),
      ),
    );
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 36),
            Icon(
              Icons.done,
              size: 150,
              color: Theme.of(context).colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  headerTitle,
                  const SizedBox(height: 16),
                  headerMessage,
                  const SizedBox(height: 32),
                  statsContainer,
                ],
              ),
            ),
            const Spacer(),
            bottomButton,
          ],
        ),
      ),
    );
  }

  Widget statRow(IconData icon, String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          CircleIcon(iconData: icon),
          const SizedBox(width: 10),
          Text(
            '$value $label',
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
