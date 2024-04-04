import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    super.key,
    required this.iconData,
    this.size = 20,
  });

  final IconData iconData;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final backgroundColor = brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
        : Theme.of(context).colorScheme.primaryContainer;
    final foregroundColor = Theme.of(context).colorScheme.onPrimaryContainer;
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: size,
          backgroundColor: backgroundColor,
        ),
        Icon(
          iconData,
          size: size,
          color: foregroundColor,
        ),
      ],
    );
  }
}
