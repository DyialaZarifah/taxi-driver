// lib/features/auth/data/models/login_response.dart
import 'driver_model.dart';

class LoginResponse {
  final String token;
  final String tokenType;
  final DriverModel user;

  const LoginResponse({
    required this.token,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return LoginResponse(
      token: data['token'] as String,
      tokenType: data['token_type'] ?? 'Bearer',
      user: DriverModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }
}