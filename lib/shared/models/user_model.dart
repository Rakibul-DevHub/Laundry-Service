import 'package:drop_n_fresh/core/constants/app_constants.dart';

import 'rider_documents_model.dart';

class User {
  final String id;
  // Personal info
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final String displayName;
  final String authRole;
  final String status;

  // Nested objects
  final Address address;
  final UserVerification? verification;
  final RiderVerification? riderVerification;
  final Profile? profile;
  final BusinessInfo? businessInfo;
  final Preferences? preferences;
  final UserStats? stats;

  // Verification flags
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isResetPassword;
  final bool isAdmin;
  final bool isVerified;
  final bool? isLocked;
  final bool? mfaEnabled;

  // Timestamps (kept as ISO strings for safety)
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.profilePicture,
    required this.displayName,
    required this.authRole,
    required this.status,
    required this.address,
    this.verification,
    this.riderVerification,
    this.profile,
    this.businessInfo,
    this.preferences,
    this.stats,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isResetPassword,
    required this.isAdmin,
    required this.isVerified,
    this.isLocked,
    this.mfaEnabled,
    this.createdAt,
    this.updatedAt,
  });

  static dynamic _readProfilePicture(Map<String, dynamic> json) {
    final dynamic topLevel = json['profilePicture'];
    if (topLevel is String && topLevel.trim().isNotEmpty) {
      return topLevel;
    }
    if (topLevel is Map) {
      return topLevel;
    }

    final dynamic nested = json['profile'];
    if (nested is Map) {
      final dynamic nestedPicture = nested['profilePicture'];
      if (nestedPicture is String && nestedPicture.trim().isNotEmpty) {
        return nestedPicture;
      }
      if (nestedPicture is Map) {
        return nestedPicture['url'] ?? nestedPicture['filePath'];
      }
    }
    return null;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      fullName: (json['fullName'] ?? json['name'] ?? '').toString(),
      profilePicture: AppConstants.resolveMediaUrl(
        _readProfilePicture(json),
      ),
      email: json['email'].toString(),
      phoneNumber: json['phoneNumber'] is String
          ? json['phoneNumber'] as String?
          : null,
      firstName: json['firstName'] is String
          ? json['firstName'] as String?
          : null,
      lastName: json['lastName'] is String ? json['lastName'] as String? : null,
      displayName: (json['displayName'] ??
              json['fullName'] ??
              json['name'] ??
              '')
          .toString(),
      authRole: (json['authRole'] ?? json['role'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      address: json['address'] is Map<String, dynamic>
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : Address(),
      verification: json['verification'] == null
          ? null
          : UserVerification.fromJson(
              json['verification'] as Map<String, dynamic>,
            ),
      riderVerification: json['riderVerification'] == null
          ? null
          : RiderVerification.fromJson(
              json['riderVerification'] as Map<String, dynamic>,
            ),
      profile: json['profile'] is Map<String, dynamic>
          ? Profile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      businessInfo: json['businessInfo'] != null
          ? BusinessInfo.fromJson(json['businessInfo'] as Map<String, dynamic>)
          : null,
      preferences: json['preferences'] != null
          ? Preferences.fromJson(
              json['preferences'] as Map<String, dynamic>,
            )
          : null,
      stats: json['stats'] != null
          ? UserStats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      isResetPassword: json['isResetPassword'] as bool? ?? false,
      isAdmin: json['isAdmin'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      isLocked: json['isLocked'] as bool?,
      mfaEnabled: json['mfaEnabled'] as bool?,
      createdAt: json['createdAt'] is String
          ? json['createdAt'] as String?
          : null,
      updatedAt: json['updatedAt'] is String
          ? json['updatedAt'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'firstName': firstName,
    'lastName': lastName,
    'profilePicture': profilePicture,
    'displayName': displayName,
    'authRole': authRole,
    'status': status,
    'address': address.toJson(),
    'verification': verification?.toJson(),
    'profile': profile?.toJson(),
    'BusinessInfo': businessInfo?.toJson(),
    'preferences': preferences?.toJson(),
    'stats': stats?.toJson(),
    'isEmailVerified': isEmailVerified,
    'isPhoneVerified': isPhoneVerified,
    'isResetPassword': isResetPassword,
    'isAdmin': isAdmin,
    'isVerified': isVerified,
    'isLocked': isLocked,
    'mfaEnabled': mfaEnabled,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? profilePicture,
    String? displayName,
    String? authRole,
    String? status,
    Address? address,
    UserVerification? verification,
    RiderVerification? riderVerification,
    Profile? profile,
    BusinessInfo? businessInfo,
    Preferences? preferences,
    UserStats? stats,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isResetPassword,
    bool? isAdmin,
    bool? isVerified,
    bool? isLocked,
    bool? mfaEnabled,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      displayName: displayName ?? this.displayName,
      authRole: authRole ?? this.authRole,
      status: status ?? this.status,
      address: address ?? this.address,
      verification: verification ?? this.verification,
      riderVerification: riderVerification ?? this.riderVerification,
      profile: profile ?? this.profile,
      businessInfo: businessInfo ?? this.businessInfo,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isResetPassword: isResetPassword ?? this.isResetPassword,
      isAdmin: isAdmin ?? this.isAdmin,
      isVerified: isVerified ?? this.isVerified,
      isLocked: isLocked ?? this.isLocked,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Address {
  final Coordinates? coordinates;
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;

  Address({
    this.coordinates,
    this.street,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  String get address =>
      "$street${(street != null ? " " : "")}$city${(city != null ? " " : "")}$state${(state != null ? " " : "")}$country${(country != null ? " " : "")}$zipCode${(zipCode != null ? " " : "")}";

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>)
          : null,
      street: json['street'] is String ? json['street'] as String? : null,
      city: json['city'] is String ? json['city'] as String? : null,
      state: json['state'] is String ? json['state'] as String? : null,
      country: json['country'] is String ? json['country'] as String? : null,
      zipCode: json['zipCode'] is String ? json['zipCode'] as String? : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'coordinates': coordinates?.toJson(),
    'street': street,
    'city': city,
    'state': state,
    'country': country,
    'zipCode': zipCode,
  };
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'latitude': latitude,
    'longitude': longitude,
  };
}

class UserVerification {
  final VerificationStatus email;
  final VerificationStatus phone;

  UserVerification({required this.email, required this.phone});

  factory UserVerification.fromJson(Map<String, dynamic> json) {
    return UserVerification(
      email: json['email'] != null
          ? VerificationStatus.fromJson(json['email'] as Map<String, dynamic>)
          : VerificationStatus(verified: false, verifiedAt: null),
      phone: json['phone'] != null
          ? VerificationStatus.fromJson(json['phone'] as Map<String, dynamic>)
          : VerificationStatus(verified: false, verifiedAt: null),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email.toJson(),
    'phone': phone.toJson(),
  };
}

class RiderVerification {
  final String verificationStatus;
  final List<dynamic> rejectionReasons;
  final int rating;
  final int totalRatings;
  final int totalDeliveries;
  final int completedDeliveries;
  final int cancelledDeliveries;
  final bool isActive;
  final bool isSuspended;
  final Nid? nid;
  final DrivingLicense? drivingLicense;
  final Insurance? insurance;
  final Selfie? selfie;
  final Vehicle? vehicle;
  final DateTime? submittedAt;

  RiderVerification({
    required this.verificationStatus,
    required this.rating,
    required this.totalRatings,
    required this.rejectionReasons,
    required this.totalDeliveries,
    required this.completedDeliveries,
    required this.cancelledDeliveries,
    required this.isActive,
    required this.isSuspended,
    this.submittedAt,
    this.nid,
    this.drivingLicense,
    this.insurance,
    this.selfie,
    this.vehicle,
  });

  factory RiderVerification.fromJson(Map<String, dynamic> json) {
    return RiderVerification(
      verificationStatus: json['verificationStatus'] as String,
      rejectionReasons: json['rejectionReasons'] as List<dynamic>,
      totalDeliveries: json['totalDeliveries'] as int,
      completedDeliveries: json['completedDeliveries'] as int,
      cancelledDeliveries: json['cancelledDeliveries'] as int,
      rating: json['rating'] as int,
      totalRatings: json['totalRatings'] as int,
      isActive: json['isActive'] as bool,
      isSuspended: json['isSuspended'] as bool,
      submittedAt: DateTime.tryParse(json['submittedAt'] as String? ?? ''),
      nid: json['nid'] == null
          ? null
          : Nid.fromJson(json['nid'] as Map<String, dynamic>),
      drivingLicense: json['drivingLicense'] == null
          ? null
          : DrivingLicense.fromJson(
              json['drivingLicense'] as Map<String, dynamic>,
            ),
      insurance: json['insurance'] == null
          ? null
          : Insurance.fromJson(
              json['insurance'] as Map<String, dynamic>,
            ),
      selfie: json['selfie'] == null
          ? null
          : Selfie.fromJson(
              json['selfie'] as Map<String, dynamic>,
            ),
      vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(
              json['vehicle'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nid': nid?.toJson(),
    'drivingLicense': drivingLicense?.toJson(),
    'insurance': insurance?.toJson(),
    'selfie': selfie?.toJson(),
    'vehicle': vehicle?.toJson(),
  };
}

class VerificationStatus {
  final bool verified;
  final String? verifiedAt; // ISO 8601 string or null

  VerificationStatus({required this.verified, this.verifiedAt});

  factory VerificationStatus.fromJson(Map<String, dynamic> json) {
    return VerificationStatus(
      verified: json['verified'] as bool? ?? false,
      verifiedAt: json['verifiedAt'] is String
          ? json['verifiedAt'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'verified': verified,
    'verifiedAt': verifiedAt,
  };
}

class Profile {
  final String? gender;
  final String? dateOfBirth;

  Profile({this.gender, this.dateOfBirth});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      gender: json['gender'] is String ? json['gender'] as String? : null,
      dateOfBirth: json['dateOfBirth'] is String
          ? json['dateOfBirth'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'gender': gender,
    'dateOfBirth': dateOfBirth,
  };
}

class BusinessInfo {
  final String businessName;
  final String ownerName;
  final String taxId;
  final String verificationStatus;
  final bool isVerified;

  BusinessInfo({
    required this.businessName,
    required this.ownerName,
    required this.taxId,
    required this.verificationStatus,
    required this.isVerified,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(
      businessName: json['businessName'].toString(),
      ownerName: json['ownerName'].toString(),
      taxId: json['taxId'].toString(),
      verificationStatus: json['verificationStatus'].toString(),
      isVerified: json['isVerified'] as bool? ?? false,
      // gender: json['gender'] is String ? json['gender'] as String? : null,
    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
    "businessName": businessName,
    "ownerName": ownerName,
    "taxId": taxId,
    "verificationStatus": verificationStatus,
    "isVerified": isVerified,
  };
}

class Preferences {
  final Notifications? notifications;
  final Privacy? privacy;
  final String? language;
  final String? timezone;
  final String? currency;

  Preferences({
    this.notifications,
    this.privacy,
    this.language,
    this.timezone,
    this.currency,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      notifications: json['notifications'] != null
          ? Notifications.fromJson(
              json['notifications'] as Map<String, dynamic>,
            )
          : null,
      privacy: json['privacy'] != null
          ? Privacy.fromJson(json['privacy'] as Map<String, dynamic>)
          : null,
      language: json['language'] is String ? json['language'] as String? : null,
      timezone: json['timezone'] is String ? json['timezone'] as String? : null,
      currency: json['currency'] is String ? json['currency'] as String? : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'notifications': notifications?.toJson(),
    'privacy': privacy?.toJson(),
    'language': language,
    'timezone': timezone,
    'currency': currency,
  };
}

class Notifications {
  final bool email;
  final bool sms;
  final bool push;
  final bool marketing;

  Notifications({
    this.email = false,
    this.sms = false,
    this.push = false,
    this.marketing = false,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      email: json['email'] as bool? ?? false,
      sms: json['sms'] as bool? ?? false,
      push: json['push'] as bool? ?? false,
      marketing: json['marketing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email,
    'sms': sms,
    'push': push,
    'marketing': marketing,
  };
}

class Privacy {
  final String? profileVisibility;
  final bool showEmail;
  final bool showPhone;

  Privacy({
    this.profileVisibility,
    this.showEmail = false,
    this.showPhone = false,
  });

  factory Privacy.fromJson(Map<String, dynamic> json) {
    return Privacy(
      profileVisibility: json['profileVisibility'] is String
          ? json['profileVisibility'] as String?
          : null,
      showEmail: json['showEmail'] as bool? ?? false,
      showPhone: json['showPhone'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'profileVisibility': profileVisibility,
    'showEmail': showEmail,
    'showPhone': showPhone,
  };
}

class UserStats {
  final int loginCount;
  final int profileViews;
  final int lastActivityScore;

  UserStats({
    this.loginCount = 0,
    this.profileViews = 0,
    this.lastActivityScore = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      loginCount: json['loginCount'] as int? ?? 0,
      profileViews: json['profileViews'] as int? ?? 0,
      lastActivityScore: json['lastActivityScore'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'loginCount': loginCount,
    'profileViews': profileViews,
    'lastActivityScore': lastActivityScore,
  };
}
