// ignore_for_file: always_specify_types

class UserLocationsResponse {
  final int code;
  final bool success;
  final String message;
  final List<UserLocation> data;

  UserLocationsResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserLocationsResponse.fromJson(Map<String, dynamic> json) {
    return UserLocationsResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => UserLocation.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'success': success,
    'message': message,
    'data': data.map((UserLocation loc) => loc.toJson()).toList(),
  };
}

class UserLocation {
  final String id;
  final String userId;
  final String name;
  final String address;
  final String type;
  final bool isDefault;
  final GeoCoordinates coordinates;
  final DateTime? lastUsed;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserLocation({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.type,
    required this.isDefault,
    required this.coordinates,
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
      isDefault: json['isDefault'] as bool,
      coordinates: GeoCoordinates.fromJson(
        json['coordinates'] as Map<String, dynamic>,
      ),
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
    'isDefault': isDefault,
    'coordinates': coordinates.toJson(),
    'lastUsed': lastUsed?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  // Helper: Short address for display
  String get shortAddress {
    final List<String> parts = address.split(',');
    return parts.length >= 2 ? '${parts[0]}, ${parts[1]}' : address;
  }

  // Helper: Display label
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

  factory GeoCoordinates.fromLatLng(double latitude, double longitude) {
    return GeoCoordinates(
      type: 'Point',
      coordinates: <double>[longitude, latitude],
    );
  }
}

class LocationSearchResponse {
  final int code;
  final bool success;
  final String message;
  final List<SearchedLocation> data;

  LocationSearchResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory LocationSearchResponse.fromJson(Map<String, dynamic> json) {
    return LocationSearchResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map(
            (item) => SearchedLocation.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class SearchedLocation {
  final String placeId;
  final double latitude;
  final double longitude;
  final String name;
  final String address;

  SearchedLocation({
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
  });

  factory SearchedLocation.fromJson(Map<String, dynamic> json) {
    return SearchedLocation(
      placeId: json['place_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json['name'] as String,
      address: json['address'] as String,
    );
  }

  UserLocation toUserLocation({
    required String userId,
    required String customName,
    String type = 'saved',
    bool isDefault = false,
  }) {
    return UserLocation(
      id: '',
      userId: userId,
      name: customName,
      address: address,
      type: type,
      isDefault: isDefault,
      coordinates: GeoCoordinates.fromLatLng(latitude, longitude),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class SaveLocationRequest {
  final double latitude;
  final double longitude;
  final String address;
  final String name;
  final String type;
  final bool isDefault;

  SaveLocationRequest({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.name,
    this.type = 'saved',
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'name': name,
    'type': type,
    'isDefault': isDefault,
  };
}
