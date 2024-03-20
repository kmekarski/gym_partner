import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_partner/models/exercise.dart';
import 'package:numberpicker/numberpicker.dart';

class NewPlanExerciseCard extends StatefulWidget {
  const NewPlanExerciseCard(
      {super.key,
      required this.exercise,
      required this.index,
      required this.onXTap});

  final int index;
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
        padding: const EdgeInsets.only(top: 4, right: 4, bottom: 16, left: 4),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 16, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.index + 1}. ${widget.exercise.name}',
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
            const Divider(),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                picker(
                    'Sets',
                    _numberOfSets,
                    1,
                    10,
                    1,
                    (value) => setState(() {
                          _numberOfSets = value;
                        })),
                picker(
                    'Reps',
                    _numberOfReps,
                    1,
                    20,
                    1,
                    (value) => setState(() {
                          _numberOfReps = value;
                        })),
                picker(
                  'Rest time',
                  _restTime,
                  10,
                  240,
                  10,
                  (value) => setState(() {
                    _restTime = value;
                  }),
                  textMapper: (numberText) => '${numberText}s',
                  width: 114,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget picker(
    String text,
    int value,
    int minValue,
    int maxValue,
    int step,
    void Function(int value) onChanged, {
    double width = 94,
    String Function(String numberText)? textMapper,
  }) {
    final buttonStyle = IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer);
    const double iconSize = 16;
    const double buttonSize = 32;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: IconButton(
                  onPressed: () => {
                    if (value > minValue) {onChanged(value - step)}
                  },
                  iconSize: iconSize,
                  style: buttonStyle,
                  icon: const Icon(Icons.remove),
                ),
              ),
              Text(
                textMapper != null
                    ? textMapper(value.toString())
                    : value.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: IconButton(
                  onPressed: () => {
                    if (value < maxValue) {onChanged(value + step)}
                  },
                  iconSize: iconSize,
                  style: buttonStyle,
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
