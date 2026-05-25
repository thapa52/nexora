import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Handles user login.
/// Takes email and password.
/// Returns authenticated UserEntity.

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    // Business logic can be added here
    // e.g., validate email format before calling repository
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty');
    }
    return await _repository.login(email: email, password: password);
  }
}
