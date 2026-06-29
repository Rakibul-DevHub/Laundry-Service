// ignore_for_file: always_specify_types

class DefaultLocationResponse {
  final int code;
  final bool success;
  final String message;
  final UserLocation? data; // Nullable: null if no default location

  DefaultLocationResponse({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory DefaultLocationResponse.fromJson(Map<String, dynamic> json) {
    return DefaultLocationResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? UserLocation.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class UserLocation {
  final String id;
  final String userId;
  final String name;
  final String address;
  final String type;
  final GeoCoordinates coordinates;
  final bool isDefault;
  final DateTime? lastUsed;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserLocation({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.type,
    required this.coordinates,
    required this.isDefault,
    this.lastUsed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      id: json['_id'] as String,
      userId: json['user'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
      coordinates: GeoCoordinates.fromJson(
        json['coordinates'] as Map<String, dynamic>,
      ),
      isDefault: json['isDefault'] as bool,
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'user': userId,
    'name': name,
    'address': address,
    'type': type,
    'coordinates': coordinates.toJson(),
    'isDefault': isDefault,
    'lastUsed': lastUsed?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  String get shortAddress {
    final List<String> parts = address.split(',');
    if (parts.length >= 2) {
      return '${parts[0].trim()}, ${parts[1].trim()}';
    }
    return parts.isNotEmpty ? parts[0].trim() : address;
  }

  String get displayLabel => '$name • $shortAddress';
}

class GeoCoordinates {
  final String type;
  final List<double> coordinates;

  GeoCoordinates({
    required this.type,
    required this.coordinates,
  });

  factory GeoCoordinates.fromJson(Map<String, dynamic> json) {
    final List<double> coords = (json['coordinates'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    return GeoCoordinates(
      type: json['type'] as String,
      coordinates: coords,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'coordinates': coordinates,
  };

  double get latitude => coordinates[1];

  double get longitude => coordinates[0];
}
