import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_notifier.dart';
import '../../../../core/extensions/context_extentions.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

/// Register Screen
/// Handles new user registration with name, email, and password.
/// Uses Riverpod for state management.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(authNotifierProvider.notifier)
        .register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
  }

  /// Validates confirm password matches password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes
    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user.isLoggedIn) {
            context.showSuccessSnackBar(
              'Welcome to ${AppConstants.appName}, ${user.displayName}',
            );
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
                  const SizedBox(height: 40),

                  /// Name field
                  AuthTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 20),

                  /// Email field
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),

                  /// Password field
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Create a password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 20),

                  /// Confirm password field
                  AuthTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: _validateConfirmPassword,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 32),

                  /// Register button
                  AuthButton(
                    text: 'Create Account',
                    onPressed: _onRegister,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 24),

                  /// Login link
                  _buildLoginLink(),
                  const SizedBox(height: 24),
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
        //  App Icon
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.person_add_rounded,
            color: AppColors.primary,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Create Account',
          style: AppTextStyles.displayMedium.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Join ${AppConstants.appName} to get started',
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate back to login screen
            GoRouter.of(context).pop();
          },
          child: Text(
            'Login',
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
