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
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: size,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.15),
        ),
        Icon(
          iconData,
          size: size,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ],
    );
  }
}
