import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_partner/models/exercise.dart';
import 'package:numberpicker/numberpicker.dart';

class NewPlanExerciseCard extends StatefulWidget {
  const NewPlanExerciseCard(
      {super.key, required this.exercise, required this.onXTap});

  final Exercise exercise;
  final void Function(Exercise exercise) onXTap;

  @override
  State<NewPlanExerciseCard> createState() => _NewPlanExerciseCardState();
}

class _NewPlanExerciseCardState extends State<NewPlanExerciseCard> {
  int _numberOfSets = 3;
  int _numberOfReps = 10;
  int _restTime = 120;

  @override
  Widget build(BuildContext context) {
    final bodyPartsString = widget.exercise.bodyParts
        .map((bodyPart) => bodyPart.toString().split('.').last)
        .join(', ');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exercise.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(bodyPartsString),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => widget.onXTap(widget.exercise),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Sets'),
                      NumberPicker(
                        axis: Axis.horizontal,
                        minValue: 1,
                        maxValue: 10,
                        value: _numberOfSets,
                        onChanged: (value) => setState(() {
                          _numberOfSets = value;
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Reps'),
                      NumberPicker(
                        axis: Axis.horizontal,
                        minValue: 1,
                        maxValue: 20,
                        value: _numberOfReps,
                        onChanged: (value) => setState(() {
                          _numberOfReps = value;
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Rest time'),
                      NumberPicker(
                        axis: Axis.horizontal,
                        minValue: 10,
                        maxValue: 240,
                        step: 10,
                        value: _restTime,
                        onChanged: (value) => setState(() {
                          _restTime = value;
                        }),
                        textMapper: (numberText) => '${numberText}s',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
