import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user_entity.dart';
import 'auth_providers.dart';

part 'auth_notifier.g.dart';

/// The AuthNotifier manages the authentication state of the application.
/// It uses AsyncNotifier to handle loading and error states automatically.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<UserEntity> build() async {
    // Initializing: Check if a user is already logged in
    return _init();
  }

  Future<UserEntity> _init() async {
    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    return await getCurrentUser();
  }

  /// Handle Login
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final loginUseCase = ref.read(loginUseCaseProvider);
      return await loginUseCase(email: email, password: password);
    });
  }

  /// Handle Registration
  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final registerUseCase = ref.read(registerUseCaseProvider);
      return await registerUseCase(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  /// Handle Logout
  Future<void> logout() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();
      return const UserEntity.empty();
    });
  }
}
