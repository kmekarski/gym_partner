import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/firebase_options.dart';
import 'package:gym_partner/screens/auth.dart';
import 'package:gym_partner/screens/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 113, 19, 19));
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: colorScheme,
        cardTheme: const CardTheme().copyWith(
          elevation: 0,
          color: colorScheme.primaryContainer.withOpacity(0.8),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const TabsScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
