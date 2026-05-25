// Data layer representation of a User.
// Knows how to convert to/from Map (for Hive storage).
// Domain layer (UserEntity) knows nothing about storage.
// This model handles all serialization logic.

import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  /// Convert from Map (reading from Hive)
  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  /// Convert to Map (saving to Hive)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }

  /// Convert to Domain Entity (data → domain)
  UserEntity toEntity() {
    return UserEntity(id: id, name: name, email: email, isAuthenticated: true);
  }
}
