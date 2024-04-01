import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/firebase_options.dart';
import 'package:gym_partner/screens/auth.dart';
import 'package:gym_partner/screens/splash.dart';
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
    final colorScheme = ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 219, 41, 174));
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: colorScheme,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: colorScheme.primary,
              width: 1,
            ),
          ),
        ),
        cardTheme: const CardTheme().copyWith(
            elevation: 0,
            color: colorScheme.primaryContainer.withOpacity(0.7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: colorScheme.primary.withOpacity(0.2), width: 2))),
        inputDecorationTheme: const InputDecorationTheme().copyWith(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          filled: true,
          fillColor: colorScheme.primaryContainer.withOpacity(0.7),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: colorScheme.primary.withOpacity(0.2), width: 2.0),
            borderRadius: BorderRadius.circular(24),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        appBarTheme: const AppBarTheme().copyWith(
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 26),
        ),
        searchBarTheme: const SearchBarThemeData().copyWith(
          elevation: const MaterialStatePropertyAll(0),
          backgroundColor:
              MaterialStateProperty.all(Colors.black.withOpacity(0.08)),
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
