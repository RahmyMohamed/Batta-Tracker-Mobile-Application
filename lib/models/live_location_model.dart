class LiveLocationModel {
  final String vehicleId;
  final String tripId;
  final String driverId;
  final double latitude;
  final double longitude;
  final double? speed;
  final double? heading;
  final DateTime timestamp;

  const LiveLocationModel({
    required this.vehicleId,
    required this.tripId,
    required this.driverId,
    required this.latitude,
    required this.longitude,
    this.speed,
    this.heading,
    required this.timestamp,
  });

  factory LiveLocationModel.fromMap(Map<String, dynamic> map, String vehicleId) {
    return LiveLocationModel(
      vehicleId: vehicleId,
      tripId: map['tripId'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      speed: (map['speed'] as num?)?.toDouble(),
      heading: (map['heading'] as num?)?.toDouble(),
      timestamp: _parseDate(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() => {
        'tripId': tripId,
        'driverId': driverId,
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
        'heading': heading,
        'timestamp': timestamp.toIso8601String(),
      };

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}
