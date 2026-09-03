// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/core/constants/app_constants.dart';

class UserServiceResponse {
  final int code;
  final bool success;
  final String message;
  final UserServiceData data;

  UserServiceResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserServiceResponse.fromJson(Map<String, dynamic> json) {
    return UserServiceResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: UserServiceData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

//  Data wrapper with services + pagination
class UserServiceData {
  final List<UserServiceModel> services;
  final PaginationInfo pagination;

  UserServiceData({
    required this.services,
    required this.pagination,
  });

  factory UserServiceData.fromJson(Map<String, dynamic> json) {
    return UserServiceData(
      services: json['services'] == null
          ? []
          : (json['services'] as List)
                .map(
                  (item) =>
                      UserServiceModel.fromJson(item as Map<String, dynamic>),
                )
                .toList(),
      pagination: PaginationInfo.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'services': services.map((UserServiceModel s) => s.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

class UserServiceModel {
  final String serviceId;
  final String providerId;
  final String providerName;
  final String? providerProfilePicture;
  final String businessName;
  final num providerRating;
  final int providerTotalRatings;
  final ProviderAddress address;
  final ServiceCategorySummary serviceCategory;
  final String description;
  final String estimateTime;

  UserServiceModel({
    required this.serviceId,
    required this.providerId,
    required this.providerName,
    this.providerProfilePicture,
    required this.businessName,
    required this.providerRating,
    required this.providerTotalRatings,
    required this.address,
    required this.serviceCategory,
    required this.description,
    required this.estimateTime,
  });

  factory UserServiceModel.fromJson(Map<String, dynamic> json) {
    return UserServiceModel(
      serviceId: json['serviceId'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerProfilePicture: AppConstants.resolveMediaUrl(
        json['providerProfilePicture'],
      ),
      businessName: json['businessName'] as String,
      providerRating: _parseNum(json['providerRating']),
      providerTotalRatings: json['providerTotalRatings'] as int,
      address: ProviderAddress.fromJson(
        json['address'] as Map<String, dynamic>,
      ),
      serviceCategory: ServiceCategorySummary.fromJson(
        json['serviceCategory'] as Map<String, dynamic>? ?? {},
      ),
      description: json['description'] as String,
      estimateTime: json['estimateTime'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'serviceId': serviceId,
    'providerId': providerId,
    'providerName': providerName,
    'providerProfilePicture': providerProfilePicture,
    'businessName': businessName,
    'providerRating': providerRating,
    'providerTotalRatings': providerTotalRatings,
    'address': address.toJson(),
    'serviceCategory': serviceCategory.toJson(),
    'description': description,
    'estimateTime': estimateTime,
  };

  static num _parseNum(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Helper: short address for display
  String get shortAddress => '${address.city}, ${address.state}';
}

class ProviderAddress {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final Coordinates coordinates;

  ProviderAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.coordinates,
  });

  factory ProviderAddress.fromJson(Map<String, dynamic> json) {
    return ProviderAddress(
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      zipCode: json['zipCode'] as String,
      coordinates: json['coordinates'] == null
          ? Coordinates(latitude: 000, longitude: 000)
          : Coordinates.fromJson(
              json['coordinates'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'street': street,
    'city': city,
    'state': state,
    'country': country,
    'zipCode': zipCode,
    'coordinates': coordinates.toJson(),
  };
}

//  Coordinates Model
class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'latitude': latitude,
    'longitude': longitude,
  };
}

//  Re-use existing ServiceCategorySummary or create new one
class ServiceCategorySummary {
  final String id;
  final String name;
  final String slug;
  final String icon;

  ServiceCategorySummary({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
  });

  factory ServiceCategorySummary.fromJson(Map<String, dynamic> json) {
    return ServiceCategorySummary(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      icon: (json['icon'] as String? ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'slug': slug,
    'icon': icon,
  };
}

//  Pagination Model
class PaginationInfo {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationInfo({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
  };

  bool get hasMore => page < totalPages;
}
