import '../repositories/auth_repository.dart';

/// Handles user logout.
/// Clears stored authentication data.
/// No parameters needed — logs out current user.

class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<void> call() async {
    await _repository.logout();
  }
}
