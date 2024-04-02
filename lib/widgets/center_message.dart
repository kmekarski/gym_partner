import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenterMessage extends StatelessWidget {
  const CenterMessage({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
