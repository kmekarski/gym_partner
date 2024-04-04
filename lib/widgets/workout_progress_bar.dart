import 'package:flutter/material.dart';

class WorkoutProgressBar extends StatelessWidget {
  const WorkoutProgressBar({
    super.key,
    required this.totalSetsCount,
    required this.currentSetIndex,
    required this.isRest,
  });

  final int totalSetsCount;
  final int currentSetIndex;
  final bool isRest;

  @override
  Widget build(BuildContext context) {
    final activeSetColor = Theme.of(context).colorScheme.secondary;
    final finishedSetColor = Theme.of(context).colorScheme.primary;
    final unfinishedSetColor = Theme.of(context).colorScheme.primaryContainer;

    Color barColor(int index) {
      if (index > currentSetIndex) {
        return unfinishedSetColor;
      }
      if (index == currentSetIndex && !isRest) {
        return activeSetColor;
      }
      if (index <= currentSetIndex) {
        return finishedSetColor;
      } else {
        return unfinishedSetColor;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < totalSetsCount; i++)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 8,
                decoration: BoxDecoration(
                    color: barColor(i),
                    borderRadius: BorderRadius.circular(20)),
              ),
            )
        ],
      ),
    );
  }
}
