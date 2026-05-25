import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Retrieves the currently authenticated user.
/// Returns UserEntity if authenticated.
/// Returns UserEntity.empty() if not authenticated.
/// Called when app starts to restore auth state.

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<UserEntity> call() async {
    return await _repository.getCurrentUser();
  }
}
