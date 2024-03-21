import 'package:flutter/material.dart';

class FormBadge extends StatefulWidget {
  FormBadge({
    super.key,
    required this.text,
    required this.onTap,
    required this.selectedBackgroundColor,
    required this.unselectedBackgroundColor,
    this.width,
    this.height = 42,
    this.isSelected = false,
    this.selectedTextColor = Colors.black,
    this.unselectedTextColor = Colors.grey,
    this.margin = const EdgeInsets.only(right: 8),
  })  : hasX = false,
        onXTap = (() => {});

  const FormBadge.withX({
    super.key,
    required this.text,
    required this.onTap,
    required this.onXTap,
    required this.selectedBackgroundColor,
    required this.unselectedBackgroundColor,
    this.width,
    this.height = 40,
    this.isSelected = false,
    this.selectedTextColor = Colors.black,
    this.unselectedTextColor = Colors.grey,
    this.margin = const EdgeInsets.only(right: 8),
  }) : hasX = true;

  final String text;
  final bool hasX;
  final EdgeInsets margin;
  final void Function() onTap;
  final void Function() onXTap;
  final double? width;
  final double height;

  final bool isSelected;

  final Color selectedTextColor;
  final Color selectedBackgroundColor;
  final Color unselectedTextColor;
  final Color unselectedBackgroundColor;

  @override
  State<FormBadge> createState() => _FormBadgeState();
}

class _FormBadgeState extends State<FormBadge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.width == null
              ? const EdgeInsets.symmetric(horizontal: 18)
              : EdgeInsets.only(left: widget.hasX ? 16 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: widget.isSelected
                ? widget.selectedBackgroundColor
                : widget.unselectedBackgroundColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: widget.isSelected
                          ? widget.selectedTextColor
                          : widget.unselectedTextColor,
                      fontSize: 16,
                    ),
              ),
              if (widget.hasX) const Spacer(),
              if (widget.hasX)
                IconButton(
                  onPressed: widget.onXTap,
                  icon: Icon(
                    Icons.close,
                    color: widget.isSelected
                        ? widget.selectedTextColor
                        : widget.unselectedTextColor,
                  ),
                  iconSize: 18,
                ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
