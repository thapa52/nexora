import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Handles new user registration.
/// Takes name, email, and password.
/// Returns newly created UserEntity.

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }

    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and Password cannot be empty');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    return await _repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
