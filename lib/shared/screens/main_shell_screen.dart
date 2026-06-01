import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../router/app_router.dart';

/// Shell screen that wraps home and bookmarks with bottom navigation.
/// The child parameter is the currently selected screen from GoRouter.
class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculatSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(
              Icons.bookmark_rounded,
              color: AppColors.primary,
            ),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }

  int _calculatSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RoutePaths.bookmarks)) return 1;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(RoutePaths.home);
        break;
      case 1:
        GoRouter.of(context).go(RoutePaths.bookmarks);
        break;
    }
  }
}
