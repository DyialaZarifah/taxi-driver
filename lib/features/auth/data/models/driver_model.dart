// lib/features/auth/data/models/driver_model.dart
class DriverModel {
  final int id;
  final String firstname;
  final String lastname;
  final String fullname;
  final String username;
  final String email;
  final String phone;
  final String accountType;
  final String status;
  final String driverStatus;

  const DriverModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.accountType,
    required this.status,
    required this.driverStatus,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: (json['id'] ?? 0) as int,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      fullname: json['fullname'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      accountType: json['account_type'] ?? 'driver',
      status: json['status'] ?? 'inactive',
      driverStatus: json['driver_status'] ?? 'inactive',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'fullname': fullname,
      'username': username,
      'email': email,
      'phone': phone,
      'account_type': accountType,
      'status': status,
      'driver_status': driverStatus,
    };
  }

  bool get isActive => status == 'active' && driverStatus == 'active';

  String get displayName => fullname.isNotEmpty ? fullname : username;

  String get initial =>
      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'D';
}