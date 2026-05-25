import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

/// Concrete implementation of AuthRepository.
/// This is where domain meets data.
///
/// Flow:
///   UI → UseCase → AuthRepository (abstract)
///                        ↓
///              AuthRepositoryImpl (this file)
///                        ↓
///              AuthLocalDatasource → Hive/SecureStorage
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _datasource;

  const AuthRepositoryImpl(this._datasource);

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Check if user already exists
    final existingUser = await _datasource.getUserByEmail(email);
    if (existingUser != null) {
      throw const AuthException(
        message: 'An account with this email already exists.',
      );
    }

    // Create new user model
    final userModel = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    // Save user to Hive
    await _datasource.saveUser(userModel);

    // Generate and save token
    final token = 'token_$email';
    await _datasource.saveToken(token);

    // Return domain entity
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    // Find user by email
    final user = await _datasource.getUserByEmail(email);

    // User not found
    if (user == null) {
      throw const AuthException(message: 'No account found with this email.');
    }

    // Wrong password
    if (user.password != password) {
      throw const AuthException(
        message: 'Incorrect password. Please try again.',
      );
    }

    // Generate and save token
    final token = 'token_$email';
    await _datasource.saveToken(token);

    // Return domain entity
    return user.toEntity();
  }

  @override
  Future<void> logout() async {
    await _datasource.deleteToken();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final user = await _datasource.getCurrentUser();

    if (user == null) {
      return const UserEntity.empty();
    }

    // Return domain entity
    return user.toEntity();
  }
}
