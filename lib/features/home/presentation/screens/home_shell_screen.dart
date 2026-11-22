import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/home_navigation_bar.dart';

/// The four tabs: trips, my bookings, notifications, account.
class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: HomeNavigationBar(
        currentIndex: shell.currentIndex,
        // Tapping the current tab again goes back to its first page.
        onSelect: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}
