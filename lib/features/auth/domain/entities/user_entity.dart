import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// User entity represents the core business object.
/// This is pure Dart — no Flutter, no Hive, no external dependencies.
@freezed
sealed class UserEntity with _$UserEntity {
  /// Private constructor needed for custom getters
  const UserEntity._();

  const factory UserEntity({
    required String id,
    required String name,
    required String email,
    @Default(false) bool isAuthenticated,
  }) = _UserEntity;

  /// Empty/Unathunthicated user
  const factory UserEntity.empty() = _EmptyUserEntity;

  /// Check if user is authenticated
  /// Works for both variants
  bool get isLoggedIn =>
      this is _UserEntity && (this as _UserEntity).isAuthenticated;

  /// Get user name safely
  /// Returns empty string for empty user
  String get displayName => switch (this) {
    _UserEntity(name: final name) => name,
    _EmptyUserEntity() => '',
  };

  /// Get user email safely
  /// Returns empty string for empty user
  String get displayEmail => switch (this) {
    _UserEntity(email: final email) => email,
    _EmptyUserEntity() => '',
  };
}
