import 'package:flutter/material.dart';
import 'package:gym_partner/models/body_part.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_exercise.dart';

class PlanExerciseRow extends StatelessWidget {
  const PlanExerciseRow({
    super.key,
    required this.exercise,
    required this.index,
    this.dividerColor,
  });

  final PlanExercise exercise;
  final int index;
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) Divider(color: dividerColor),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${exercise.exercise.name}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                      exercise.exercise.bodyParts
                          .map((e) => bodyPartStrings[e])
                          .join(', '),
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              Text(
                '${exercise.numOfReps}x${exercise.numOfSets}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 22, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ],
    );
  }
}
