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
  final double rowsGap = 4;

  @override
  Widget build(BuildContext context) {
    final tagsString = widget.workoutInHistory.tags
        .map((tag) => planTagStrings[tag])
        .join(', ');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, right: 4, bottom: 16, left: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(dateFormat
                      .format(widget.workoutInHistory.timestamp.toDate())),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workoutInHistory.planName,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      SizedBox(height: rowsGap),
                      Text(tagsString),
                    ],
                  ),
                  Spacer(),
                  stat('Exercises',
                      widget.workoutInHistory.numOfExercises.toString()),
                  stat('Sets', widget.workoutInHistory.numOfSets.toString()),
                  stat('Time',
                      timeFormat(widget.workoutInHistory.timeInSeconds)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stat(String title, String value) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          SizedBox(height: rowsGap),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
