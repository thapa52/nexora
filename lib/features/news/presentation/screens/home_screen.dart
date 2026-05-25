import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

/// Temporary home screen to test auth flow.
/// Will be replaced with actual news feed later.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nexora'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Center(
        child: authState.when(
          data:
              (user) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome ${user.displayName}!',
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(user.displayEmail, style: AppTextStyles.bodyMedium),
                ],
              ),
          error: (error, _) => Text('Error $error'),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
