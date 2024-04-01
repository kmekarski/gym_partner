import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/providers/public_plans_provider.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/tabs.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  final double progressIndicatorSize = 32;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: progressIndicatorSize,
              width: progressIndicatorSize,
              child: const CircularProgressIndicator(),
            ),
            const SizedBox(height: 16),
            Text(
              'We are loading your data...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
