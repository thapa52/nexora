import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API-related constants for network requests.
/// Sensitive values are loaded from .env file (never committed to git).
class ApiConstants {
  ApiConstants._();

  // Base URL — loaded from environment file
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  // Endpoints
  static const String topStories = '/topstories.json';
  static const String newStories = '/newstories.json';
  static const String bestStories = '/beststories.json';
  static const String item = '/item';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
