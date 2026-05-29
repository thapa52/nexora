import 'package:nexora/core/errors/exceptions.dart';
import 'package:nexora/features/auth/domain/entities/user_entity.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repository.dart';

/// Fake implementation of AuthRepository for testing.
/// Simulates real behavior without Hive or SecureStorage.
/// Tests can verify use case logic independently.
class FakeAuthRepository implements AuthRepository {
  // Simulated database
  final Map<String, Map<String, String>> _users = {};
  String? _currentToken;

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Check if user already exists
    if (_users.containsKey(email)) {
      throw const AuthException(
        message: 'An account with this email already exists.',
      );
    }

    // Save user
    _users[email] = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password': password,
    };

    // Set token
    _currentToken = 'token_$email';

    return UserEntity(
      id: _users[email]!['id']!,
      name: name,
      email: email,
      isAuthenticated: true,
    );
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    // User not found
    if (!_users.containsKey(email)) {
      throw const AuthException(message: 'No account found with this email.');
    }

    // Wrong password
    if (_users[email]!['password'] != password) {
      throw const AuthException(
        message: 'Incorrect password. Please try again.',
      );
    }

    // Set token
    _currentToken = 'token_$email';

    return UserEntity(
      id: _users[email]!['id']!,
      name: _users[email]!['name']!,
      email: email,
      isAuthenticated: true,
    );
  }

  @override
  Future<void> logout() async {
    _currentToken = null;
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    if (_currentToken == null) {
      return const UserEntity.empty();
    }

    final email = _currentToken!.replaceFirst('token_', '');
    if (!_users.containsKey(email)) {
      return const UserEntity.empty();
    }

    return UserEntity(
      id: _users[email]!['id']!,
      name: _users[email]!['name']!,
      email: email,
      isAuthenticated: true,
    );
  }
}
