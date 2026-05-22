/// Base exception class for the app
abstract class AppException implements Exception {
  final String message;

  const AppException({required this.message});

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when there is no internet connection
class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection.'});
}

/// Thrown when server returns an error response
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({required super.message, this.statusCode});
}

/// Thrown when local storage operation fails
class CacheException extends AppException {
  const CacheException({super.message = 'Failed to access local storage.'});
}

/// Thrown when authentication fails
class AuthException extends AppException {
  const AuthException({required super.message});
}
