import '../entities/user_entity.dart';

/// Abstract repository interface for authentication.
/// This is a CONTRACT — it defines WHAT the auth system can do.
/// It does NOT define HOW it does it.

abstract class AuthRepository {
  /// Register a new user
  /// Returns UserEntity on success
  /// Throws exception on failure
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  /// Login with email and password
  /// Returns UserEntity on success
  /// Throws exception on failure
  Future<UserEntity> login({required String email, required String password});

  /// Logout current user
  /// Clears stored token and user data
  Future<void> logout();

  /// Check if user is currently authenticated
  /// Returns UserEntity if token exists
  /// Returns UserEntity.empty() if not authenticated
  Future<UserEntity> getCurrentUser();
}
