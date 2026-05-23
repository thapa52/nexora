import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Handles all local storage operations for authentication.
/// Talks directly to Hive (user data) and FlutterSecureStorage (token).
/// Only the repository calls this — never the UI or domain layer.

abstract class AuthLocalDatasource {
  /// Save user data to Hive
  Future<void> saveUser(UserModel user);

  /// Get user by email from Hive
  Future<UserModel?> getUserByEmail(String email);

  /// Save auth token securely
  Future<void> saveToken(String token);

  /// Get stored auth token
  Future<String?> getToken();

  /// Delete auth token (logout)
  Future<void> deleteToken();

  /// Get current user data using stored token
  Future<UserModel?> getCurrentUser();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage _secureStorage;

  static const String _usersBoxName = 'user';

  AuthLocalDatasourceImpl({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Get or open the Hive users box
  Future<Box> _getUsersBox() async {
    if (Hive.isBoxOpen(_usersBoxName)) {
      return Hive.box(_usersBoxName);
    }
    return await Hive.openBox(_usersBoxName);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final box = await _getUsersBox();
      await box.put(user.email, user.toMap());
    } catch (e) {
      throw const CacheException(message: 'Failed to save user data');
    }
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final box = await _getUsersBox();
      final userData = box.get(email);
      if (userData == null) return null;
      return UserModel.fromMap(Map<dynamic, dynamic>.from(userData));
    } catch (e) {
      throw const CacheException(message: 'Failed to read user data');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: AppConstants.authTokenKey, value: token);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to save authentication token.',
      );
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return _secureStorage.read(key: AppConstants.authTokenKey);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to read authentication token.',
      );
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: AppConstants.authTokenKey);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to delete authentication token.',
      );
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      // Token format: "token_email@example.com"
      // Extract email from token
      final email = token.replaceFirst('token_', '');
      return await getUserByEmail(email);
    } catch (e) {
      throw const CacheException(message: 'Failed to get current user.');
    }
  }
}
