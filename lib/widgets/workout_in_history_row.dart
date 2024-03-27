import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/workout_in_history.dart';
import 'package:gym_partner/utils/time_format.dart';
import 'package:intl/intl.dart';

class WorkoutInHistoryRow extends StatefulWidget {
  WorkoutInHistoryRow({
    super.key,
    required this.workoutInHistory,
  });

  final WorkoutInHistory workoutInHistory;

  @override
  State<WorkoutInHistoryRow> createState() => _WorkoutInHistoryRowState();
}

class _WorkoutInHistoryRowState extends State<WorkoutInHistoryRow> {
  final dateFormat = DateFormat('dd MMMM yyyy \'at\' hh:mm');

  @override
  Widget build(BuildContext context) {
    final tagsString = widget.workoutInHistory.tags
        .map((tag) => planTagStrings[tag])
        .join(', ');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(widget.workoutInHistory.timestamp.toDate())),
            const SizedBox(height: 4),
            Text(
              widget.workoutInHistory.planName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            if (tagsString != '') Text(tagsString),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stat('Exercises',
                      widget.workoutInHistory.numOfExercises.toString()),
                  const VerticalDivider(),
                  stat('Sets', widget.workoutInHistory.numOfSets.toString()),
                  const VerticalDivider(),
                  stat('Time',
                      timeFormat(widget.workoutInHistory.timeInSeconds)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget stat(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
