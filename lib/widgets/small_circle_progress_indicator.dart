import 'package:flutter/material.dart';

class SmallCircleProgressIndicator extends StatelessWidget {
  const SmallCircleProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
