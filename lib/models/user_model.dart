enum UserRole { passenger, driver }

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final String? photoUrl;
  final String? selectedStopId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.photoUrl,
    this.selectedStopId,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => UserRole.passenger,
      ),
      photoUrl: map['photoUrl'] as String?,
      selectedStopId: map['selectedStopId'] as String?,
      createdAt: _parseDate(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? _parseDate(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'phone': phone,
        'role': role.name,
        'photoUrl': photoUrl,
        'selectedStopId': selectedStopId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  UserModel copyWith({
    String? name,
    String? phone,
    String? photoUrl,
    String? selectedStopId,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role,
      photoUrl: photoUrl ?? this.photoUrl,
      selectedStopId: selectedStopId ?? this.selectedStopId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}
