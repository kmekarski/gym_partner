import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/providers/public_plans_provider.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/tabs.dart';
import 'package:gym_partner/widgets/gradients/background_gradient.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  final double progressIndicatorSize = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(gradient: backgroundGradient(context)),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: progressIndicatorSize,
              width: progressIndicatorSize,
              child: const CircularProgressIndicator(
                strokeWidth: 5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'We are loading your data...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
