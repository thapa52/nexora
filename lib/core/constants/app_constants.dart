/// App-wide constant values used across the entire application.
/// Using a private constructor prevents instantiation.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Nexora';
  static const String versionName = '1.0.0';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';

  // Pagination
  static const int pageSize = 20;

  // Animation Duration
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);

  // UI
  static const double borderRadius = 12.0;
  static const double defaultPadding = 16.0;
}
