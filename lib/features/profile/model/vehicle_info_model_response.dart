class VehicleUploadResponse {
  final int code;
  final bool success;
  final String message;
  final VehicleUploadData? data;

  VehicleUploadResponse({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory VehicleUploadResponse.fromJson(Map<String, dynamic> json) {
    return VehicleUploadResponse(
      code: json['code'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] is String ? json['message'] as String : '',
      data: json['data'] != null
          ? VehicleUploadData.fromJson(json['data'] as Map<String, dynamic>)
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

class VehicleUploadData {
  final VehicleImage? image;
  final String vehicleType;
  final String model;
  final String manufacturer;
  final String yearOfManufacture;
  final String color;
  final String numberPlate;

  VehicleUploadData({
    this.image,
    required this.vehicleType,
    required this.model,
    required this.manufacturer,
    required this.yearOfManufacture,
    required this.color,
    required this.numberPlate,
  });

  factory VehicleUploadData.fromJson(Map<String, dynamic> json) {
    return VehicleUploadData(
      image: json['image'] != null
          ? VehicleImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      vehicleType: json['vehicleType'] is String
          ? json['vehicleType'] as String
          : '',
      model: json['model'] is String ? json['model'] as String : '',
      manufacturer: json['manufacturer'] is String
          ? json['manufacturer'] as String
          : '',
      yearOfManufacture: json['yearOfManufacture'] is String
          ? json['yearOfManufacture'] as String
          : '',
      color: json['color'] is String ? json['color'] as String : '',
      numberPlate: json['numberPlate'] is String
          ? json['numberPlate'] as String
          : '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'image': image?.toJson(),
    'vehicleType': vehicleType,
    'model': model,
    'manufacturer': manufacturer,
    'yearOfManufacture': yearOfManufacture,
    'color': color,
    'numberPlate': numberPlate,
  };
}

class VehicleImage {
  final String filename;
  final String url; // Automatically trimmed during parsing
  final String uploadedAt; // ISO 8601 datetime string
  final String status;

  VehicleImage({
    required this.filename,
    required this.url,
    required this.uploadedAt,
    required this.status,
  });

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    // CRITICAL: Trim URL to handle trailing spaces (common in S3/local stack responses)
    final String rawUrl = json['url'] is String ? json['url'] as String : '';
    return VehicleImage(
      filename: json['filename'] is String ? json['filename'] as String : '',
      url: rawUrl.trim(), // 🔑 Fixes whitespace issues in your example
      uploadedAt: json['uploadedAt'] is String
          ? json['uploadedAt'] as String
          : '',
      status: json['status'] is String ? json['status'] as String : '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'filename': filename,
    'url': url,
    'uploadedAt': uploadedAt,
    'status': status,
  };
}
