import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_notifier.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

/// Login Screen
/// Handles user authentication with email and password.
/// Uses Riverpod for state management.
/// Navigates to home on success, shows error on failure.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Call auth notifier
    ref
        .read(authNotifierProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes
    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user.isLoggedIn) {
            context.showSuccessSnackBar('Welcome back, ${user.displayName}!');
            // Navigation will be handled by GoRouter redirect
          }
        },
        error: (error, _) {
          context.showErrorSnackBar(error.toString());
        },
      );
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding * 1.5,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  _buildHeader(),
                  SizedBox(height: 40),

                  // Email Field
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  SizedBox(height: 20),

                  // password Field
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outlined,
                    isPassword: true,
                    validator: Validators.password,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 32),

                  // Login Button
                  AuthButton(
                    text: 'Login',
                    onPressed: _onLogin,
                    isLoading: isLoading,
                  ),
                  SizedBox(height: 24),

                  // ─── Register Link ─────────────────
                  _buildRegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Icon
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.rocket_launch_rounded,
            color: AppColors.primary,
            size: 32,
          ),
        ),
        SizedBox(height: 24),

        // Title
        Text(
          'Welcome Back',
          style: AppTextStyles.displayMedium.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),

        // Subtitle
        Text(
          'Sign in to continue to ${AppConstants.appName}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to register screen
            // Will be connected with GoRouter later
          },
          child: Text(
            'Register',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
