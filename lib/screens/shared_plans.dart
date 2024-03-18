import 'package:flutter/material.dart';

class SharedPlansScreen extends StatelessWidget {
  const SharedPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other users\' workout plans'),
      ),
      body: const Center(
        child: Text('shared plans...'),
      ),
    );
  }
}
