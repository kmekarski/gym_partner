import 'package:flutter/material.dart';

LinearGradient authGradient(BuildContext context) => LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary.withOpacity(0.4),
        Theme.of(context).colorScheme.primary.withOpacity(0.10),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
