import 'package:flutter/material.dart';

List<Color> backgroundGradientColors(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  final colors = brightness == Brightness.light
      ? [
          Theme.of(context).colorScheme.primary.withOpacity(0.3),
          Theme.of(context).colorScheme.primary.withOpacity(0.05),
        ]
      : [
          Theme.of(context).colorScheme.primary.withOpacity(0.2),
          Theme.of(context).colorScheme.primary.withOpacity(0.05),
        ];
  return colors;
}

List<Color> authBackgroundGradientColors(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  final colors = brightness == Brightness.light
      ? [
          Theme.of(context).colorScheme.primary.withOpacity(0.45),
          Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ]
      : [
          Theme.of(context).colorScheme.primary.withOpacity(0.45),
          Colors.transparent,
        ];
  return colors;
}

LinearGradient backgroundGradient(BuildContext context) {
  return LinearGradient(
    colors: backgroundGradientColors(context),
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}

enum GradientDialonalOrientation { right, left }

LinearGradient authBackgroundGradient(
  BuildContext context, {
  required GradientDialonalOrientation diagonalOrientation,
}) {
  Alignment begin;
  Alignment end;
  if (diagonalOrientation == GradientDialonalOrientation.left) {
    begin = Alignment.topLeft;
    end = Alignment.bottomRight;
  } else {
    begin = Alignment.topRight;
    end = Alignment.bottomLeft;
  }
  return LinearGradient(
    colors: authBackgroundGradientColors(context),
    begin: begin,
    end: end,
  );
}
