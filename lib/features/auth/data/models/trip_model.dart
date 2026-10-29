// lib/features/auth/data/models/trip_model.dart

class TripModel {
  final int id; // هذا هو offer_id
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final double distanceKm;
  final double price;
  final String currency;
  final String status;
  final String riderName;
  final String riderPhone;

  const TripModel({
    required this.id,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.distanceKm,
    required this.price,
    required this.currency,
    required this.status,
    required this.riderName,
    required this.riderPhone,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    // ✨ السحر هنا: إذا كانت البيانات داخل كائن اسمه "trip"، نستخدمه. وإلا نستخدم الجذر.
    final tripData = json['trip'] is Map<String, dynamic> ? json['trip'] as Map<String, dynamic> : json;

    final pickupObj = tripData['pickup'] is Map ? tripData['pickup'] : {};
    final dropoffObj = tripData['dropoff'] is Map ? tripData['dropoff'] : {};
    final riderObj = tripData['rider'] is Map ? tripData['rider'] : {};

    // تحويل المسافة من متر إلى كم إذا لزم الأمر
    double parseDistance() {
      if (tripData['distance_km'] != null) return (tripData['distance_km'] as num).toDouble();
      if (tripData['estimated_distance_meters'] != null) return (tripData['estimated_distance_meters'] as num).toDouble() / 1000;
      return 0.0;
    }

    return TripModel(
      // الـ id هنا هو الـ offer_id (من الجذر أو من trip)
      id: (json['id'] ?? tripData['id'] ?? 0) as int,

      pickupAddress: tripData['pickup_address'] ?? tripData['origin'] ?? 'موقع الانطلاق',
      dropoffAddress: tripData['dropoff_address'] ?? tripData['destination'] ?? 'موقع الوصول',

      pickupLat: (tripData['pickup_lat'] ?? pickupObj['latitude'] ?? 0).toDouble(),
      pickupLng: (tripData['pickup_lng'] ?? pickupObj['longitude'] ?? 0).toDouble(),
      dropoffLat: (tripData['dropoff_lat'] ?? dropoffObj['latitude'] ?? 0).toDouble(),
      dropoffLng: (tripData['dropoff_lng'] ?? dropoffObj['longitude'] ?? 0).toDouble(),

      distanceKm: parseDistance(),
      price: (tripData['price'] ?? tripData['estimated_fare'] ?? tripData['fare'] ?? 0).toDouble(),
      currency: tripData['currency_code'] ?? tripData['currency'] ?? 'SYP',

      // حالة العرض (pending, accepted...) من الجذر، أو حالة الرحلة
      status: json['status'] ?? tripData['status'] ?? 'pending',

      riderName: riderObj['fullname'] ?? tripData['rider_name'] ?? 'راكب',
      riderPhone: riderObj['phone'] ?? tripData['rider_phone'] ?? '',
    );
  }
}