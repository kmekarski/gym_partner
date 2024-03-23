import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    required this.label,
    this.icon = null,
    required this.onPressed,
  });

  final void Function() onPressed;
  final Icon? icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: icon == null
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              onPressed: onPressed,
              child: label,
            )
          : ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              onPressed: onPressed,
              icon: icon!,
              label: label,
            ),
    );
  }
}
