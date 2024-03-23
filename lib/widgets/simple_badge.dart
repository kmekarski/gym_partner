import 'package:flutter/material.dart';

class SimpleBadge extends StatelessWidget {
  const SimpleBadge(
      {super.key,
      required this.text,
      required this.textColor,
      required this.backgroundColor});

  final String text;
  final Color textColor;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: backgroundColor),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: textColor,
            ),
      ),
    );
  }
}
