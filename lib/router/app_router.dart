import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/providers/auth_notifier.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/news/presentation/screens/home_screen.dart';

part 'app_router.g.dart';

/// Route path constants
/// Using constants prevents typos in route names
class RoutePaths {
  RoutePaths._();

  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: RoutePaths.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Still loading auth state — don't redirect yet
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull?.isLoggedIn ?? false;
      final currentPath = state.matchedLocation;

      final isOnAuthPage =
          currentPath == RoutePaths.login || currentPath == RoutePaths.register;

      // Not logged in and not on auth page → go to login
      if (!isLoggedIn && !isOnAuthPage) {
        return RoutePaths.login;
      }

      // Logged in and on auth page → go to home
      if (isLoggedIn && isOnAuthPage) {
        return RoutePaths.home;
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Route not found: ${state.error}')),
        ),
  );
}
