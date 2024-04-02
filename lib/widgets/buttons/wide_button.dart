import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    this.label = null,
    this.icon = null,
    this.text = null,
    required this.onPressed,
  });

  final void Function() onPressed;
  final Icon? icon;
  final Widget? label;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: icon == null
          ? ElevatedButton(
              onPressed: onPressed,
              child: label ??
                  Text(
                    text ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: icon!,
              label: label ??
                  Text(
                    text ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
            ),
    );
  }
}
