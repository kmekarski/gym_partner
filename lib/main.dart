import 'package:flutter/material.dart';
import 'package:gym_partner/screens/auth.dart';
import 'package:gym_partner/screens/tabs.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthScreen(),
    );
  }
}
