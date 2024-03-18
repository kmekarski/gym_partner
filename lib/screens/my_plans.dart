import 'package:flutter/material.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My workout plans'),
      ),
      body: const Center(
        child: Text('my plans...'),
      ),
    );
  }
}
