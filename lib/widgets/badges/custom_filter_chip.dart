import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  const CustomFilterChip({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
    this.number,
    this.hasTick = false,
  });

  final String text;
  final int? number;
  final void Function() onTap;
  final bool isSelected;
  final bool hasTick;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isSelectedBackgroundColor = brightness == Brightness.light
        ? Colors.grey.shade400
        : Colors.grey.shade700;
    final isUnselectedBackgroundColor = brightness == Brightness.light
        ? Colors.grey.shade300
        : Colors.grey.shade800;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? isSelectedBackgroundColor
                : isUnselectedBackgroundColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              if (hasTick && isSelected)
                const Row(
                  children: [
                    Icon(Icons.done),
                    SizedBox(width: 4),
                  ],
                ),
              Text(
                text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
              if (number != null)
                Row(
                  children: [
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      child: Text(
                        number.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
