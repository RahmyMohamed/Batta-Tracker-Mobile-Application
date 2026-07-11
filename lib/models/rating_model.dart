class RatingModel {
  final String id;
  final String passengerId;
  final String driverId;
  final String tripId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  const RatingModel({
    required this.id,
    required this.passengerId,
    required this.driverId,
    required this.tripId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory RatingModel.fromMap(Map<String, dynamic> map, String id) {
    return RatingModel(
      id: id,
      passengerId: map['passengerId'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      tripId: map['tripId'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      comment: map['comment'] as String?,
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'passengerId': passengerId,
        'driverId': driverId,
        'tripId': tripId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };
}
