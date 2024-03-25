import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/providers/public_plans_provider.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/my_plans.dart';
import 'package:gym_partner/screens/settings.dart';
import 'package:gym_partner/screens/shared_plans.dart';
import 'package:gym_partner/screens/workout_history.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  var _selectedPageIndex = 0;

  @override
  void initState() {
    ref.read(userProvider.notifier).getUserData();
    ref.read(userPlansProvider.notifier).getUserPlans();
    ref.read(publicPlansProvider.notifier).getPlans();
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MyPlansScreen();
    if (_selectedPageIndex == 1) {
      activePage = WorkoutHistoryScreen();
    }
    switch (_selectedPageIndex) {
      case 0:
        activePage = const MyPlansScreen();
      case 1:
        activePage = const SharedPlansScreen();
      case 2:
        activePage = WorkoutHistoryScreen();
      case 3:
        activePage = const SettingsScreen();
      default:
        activePage = const MyPlansScreen();
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          tabBarItem(context, icon: Icons.event_note, text: 'My plans'),
          tabBarItem(context, icon: Icons.event_note, text: 'Browse plans'),
          tabBarItem(context, icon: Icons.history, text: 'History'),
          tabBarItem(context, icon: Icons.settings, text: 'Settings'),
        ],
      ),
      body: activePage,
    );
  }

  BottomNavigationBarItem tabBarItem(BuildContext context,
      {required IconData icon, required String text}) {
    return BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        icon: Icon(icon),
        label: text);
  }
}
