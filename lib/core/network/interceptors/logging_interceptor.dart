import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs every API request and response to console.
/// Only logs in DEBUG mode (not in production).
class LoggingInterceptor extends Interceptor {
  /// Called BEFORE request is sent
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── REQUEST ──────────────────────────────');
      debugPrint('│ ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────────');
    }
    handler.next(options);
  }

  /// Called AFTER response is received
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── RESPONSE ─────────────────────────────');
      debugPrint('│ Status: ${response.statusCode}');
      debugPrint('│ URL: ${response.realUri}');
      debugPrint('└─────────────────────────────────────────');
    }
    handler.next(response);
  }

  /// Called when request FAILS
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── ERROR ────────────────────────────────');
      debugPrint('│ Type: ${err.type}');
      debugPrint('│ Message: ${err.message}');
      debugPrint('│ URL: ${err.requestOptions.uri}');
      debugPrint('└─────────────────────────────────────────');
    }
    handler.next(err);
  }
}
