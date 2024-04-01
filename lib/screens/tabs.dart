import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/providers/public_plans_provider.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/my_plans.dart';
import 'package:gym_partner/screens/settings.dart';
import 'package:gym_partner/screens/shared_plans.dart';
import 'package:gym_partner/screens/splash.dart';
import 'package:gym_partner/screens/workout_history.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  var _selectedPageIndex = 0;
  bool _isFetching = true;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() async {
    await ref.read(userProvider.notifier).getUserData();
    await ref.read(userPlansProvider.notifier).getUserPlans();
    await ref.read(publicPlansProvider.notifier).getPlans();

    setState(() {
      _isFetching = false;
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MyPlansScreen();
    switch (_selectedPageIndex) {
      case 0:
        activePage = const MyPlansScreen();
      case 1:
        activePage = const SharedPlansScreen();
      case 2:
        activePage = const WorkoutHistoryScreen();
      case 3:
        activePage = const SettingsScreen();
      default:
        activePage = const MyPlansScreen();
    }
    var bottomNavigationBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedPageIndex,
      onTap: _selectPage,
      items: [
        tabBarItem(context, icon: Icons.event_note, text: 'My plans'),
        tabBarItem(context, icon: Icons.public, text: 'Others\' plans'),
        tabBarItem(context, icon: Icons.history, text: 'History'),
        tabBarItem(context, icon: Icons.settings, text: 'Settings'),
      ],
    );
    return Scaffold(
      bottomNavigationBar: _isFetching ? null : bottomNavigationBar,
      body: Stack(
        children: [
          activePage,
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: _isFetching ? 0 : -MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const SplashScreen(),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem tabBarItem(BuildContext context,
      {required IconData icon, required String text}) {
    return BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        icon: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Icon(icon),
        ),
        label: text);
  }
}
