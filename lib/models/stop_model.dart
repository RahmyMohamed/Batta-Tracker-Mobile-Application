class StopModel {
  final String id;
  final String name;
  final String nameSi;
  final String nameTa;
  final double latitude;
  final double longitude;
  final int order;
  final bool isCustom;

  const StopModel({
    required this.id,
    required this.name,
    required this.nameSi,
    required this.nameTa,
    required this.latitude,
    required this.longitude,
    required this.order,
    this.isCustom = false,
  });

  factory StopModel.fromMap(Map<String, dynamic> map, String id) {
    return StopModel(
      id: id,
      name: map['name'] as String? ?? '',
      nameSi: map['nameSi'] as String? ?? map['name'] as String? ?? '',
      nameTa: map['nameTa'] as String? ?? map['name'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      order: map['order'] as int? ?? 0,
      isCustom: map['isCustom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'nameSi': nameSi,
        'nameTa': nameTa,
        'latitude': latitude,
        'longitude': longitude,
        'order': order,
        'isCustom': isCustom,
      };

  String localizedName(String locale) {
    switch (locale) {
      case 'si':
        return nameSi;
      case 'ta':
        return nameTa;
      default:
        return name;
    }
  }
}
