enum VehicleStatus { available, full, delayed, outOfService }

class VehicleModel {
  final String id;
  final String plateNumber;
  final String driverId;
  final String routeId;
  final VehicleStatus status;
  final int capacity;
  final int currentPassengers;
  final String? model;
  final String? color;
  final double? rating;

  const VehicleModel({
    required this.id,
    required this.plateNumber,
    required this.driverId,
    required this.routeId,
    required this.status,
    this.capacity = 20,
    this.currentPassengers = 0,
    this.model,
    this.color,
    this.rating,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map, String id) {
    return VehicleModel(
      id: id,
      plateNumber: map['plateNumber'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      routeId: map['routeId'] as String? ?? '',
      status: VehicleStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => VehicleStatus.available,
      ),
      capacity: map['capacity'] as int? ?? 20,
      currentPassengers: map['currentPassengers'] as int? ?? 0,
      model: map['model'] as String?,
      color: map['color'] as String?,
      rating: (map['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'plateNumber': plateNumber,
        'driverId': driverId,
        'routeId': routeId,
        'status': status.name,
        'capacity': capacity,
        'currentPassengers': currentPassengers,
        'model': model,
        'color': color,
        'rating': rating,
      };

  VehicleModel copyWith({
    VehicleStatus? status,
    int? currentPassengers,
    double? rating,
  }) {
    return VehicleModel(
      id: id,
      plateNumber: plateNumber,
      driverId: driverId,
      routeId: routeId,
      status: status ?? this.status,
      capacity: capacity,
      currentPassengers: currentPassengers ?? this.currentPassengers,
      model: model,
      color: color,
      rating: rating ?? this.rating,
    );
  }
}
