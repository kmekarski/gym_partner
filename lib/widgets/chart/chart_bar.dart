import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    Key? key,
    required this.fullHeight,
    required this.width,
    required this.fill,
    required this.topLabel,
    required this.bottomLabel,
    required this.topLabelFontSize,
  }) : super(key: key);

  final double fullHeight;
  final double width;
  final double fill;
  final String topLabel;
  final String bottomLabel;
  final double topLabelFontSize;

  final double labelsHeight = 64;

  @override
  Widget build(BuildContext context) {
    final barHeight = (fullHeight - labelsHeight) * fill;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            topLabel,
            style: TextStyle(
              fontSize: topLabelFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: (3.5 * barHeight).round()),
            builder: (context, value, _) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: barHeight * value,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bottomLabel,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
