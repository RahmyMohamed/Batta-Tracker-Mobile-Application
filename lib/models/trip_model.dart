enum TripStatus { active, completed, cancelled }

class TripModel {
  final String id;
  final String driverId;
  final String vehicleId;
  final String routeId;
  final TripStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int passengerCount;
  final List<String> stopIds;

  const TripModel({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.routeId,
    required this.status,
    required this.startedAt,
    this.endedAt,
    this.passengerCount = 0,
    this.stopIds = const [],
  });

  factory TripModel.fromMap(Map<String, dynamic> map, String id) {
    return TripModel(
      id: id,
      driverId: map['driverId'] as String? ?? '',
      vehicleId: map['vehicleId'] as String? ?? '',
      routeId: map['routeId'] as String? ?? '',
      status: TripStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => TripStatus.active,
      ),
      startedAt: _parseDate(map['startedAt']),
      endedAt: map['endedAt'] != null ? _parseDate(map['endedAt']) : null,
      passengerCount: map['passengerCount'] as int? ?? 0,
      stopIds: List<String>.from(map['stopIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
        'driverId': driverId,
        'vehicleId': vehicleId,
        'routeId': routeId,
        'status': status.name,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'passengerCount': passengerCount,
        'stopIds': stopIds,
      };

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}
