// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://taxi.coda.sy/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Driver
  static const String driverStatus = '/driver/status';
  static const String driverTrips = '/driver/trips';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Storage
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
}