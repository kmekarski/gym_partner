import 'package:flutter/material.dart';
import 'package:gym_partner/screens/my_plans.dart';
import 'package:gym_partner/screens/settings.dart';
import 'package:gym_partner/screens/shared_plans.dart';
import 'package:gym_partner/screens/workout_history.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MyPlansScreen();
    if (_selectedPageIndex == 1) {
      activePage = const WorkoutHistoryScreen();
    }
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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          tabBarItem(context, icon: Icons.event_note, text: 'My plans'),
          tabBarItem(context, icon: Icons.event_note, text: 'Shared plans'),
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
