import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'interceptors/logging_interceptor.dart';

/// Creates and configures the Dio HTTP client.
/// Single source of truth for all API configuration.
/// Every API call in the app goes through this client.
class DioClient {
  DioClient._();

  static Dio? _dio;

  /// Get the Dio instance (creates one if it doesn't exist)
  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  /// Create and configure Dio
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(LoggingInterceptor());

    return dio;
  }

  /// Converts DioException to our custom AppException.
  /// Call this in every repository catch block.
  /// Keeps error handling consistent across the app.
  AppException handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException(
          message: 'Connection timed out. Please try again',
        );
      case DioExceptionType.connectionError:
        return const NetworkException(message: 'No internet connection');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response);
        return ServerException(message: message, statusCode: statusCode);
      default:
        return NetworkException(
          message: error.message ?? 'An unexpected error occured',
        );
    }
  }

  /// Extract error message from server response
  String _extractErrorMessage(Response? response) {
    if (response == null) return 'Server error occured.';
    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ??
            data['error'] as String? ??
            'Server error occured.';
      }
      return 'Server error occured';
    } catch (e) {
      return 'Server error occured';
    }
  }
}
