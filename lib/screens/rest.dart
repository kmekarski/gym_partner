import 'package:flutter/material.dart';

class RestScreen extends StatefulWidget {
  const RestScreen({
    super.key,
    required this.onFinishRest,
  });

  final void Function() onFinishRest;

  @override
  State<RestScreen> createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            child: Text('skip rest'), onPressed: widget.onFinishRest),
      ),
    );
  }
}
