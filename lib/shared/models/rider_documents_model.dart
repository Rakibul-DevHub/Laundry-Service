class RiderDocumentsModelResponse {
  final int code;
  final bool success;
  final String message;
  final RiderDocumentsModel data;

  RiderDocumentsModelResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory RiderDocumentsModelResponse.fromJson(Map<String, dynamic> json) {
    return RiderDocumentsModelResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: RiderDocumentsModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class RiderDocumentsModel {
  final String verificationStatus;
  final bool isResubmitEnabled;
  final DateTime? submittedAt;
  final Nid? nid;
  final DrivingLicense? drivingLicense;
  final Insurance? insurance;
  final Selfie? selfie;
  final Vehicle? vehicle;

  RiderDocumentsModel({
    required this.verificationStatus,
    this.isResubmitEnabled = false,
    this.submittedAt,
    this.nid,
    this.drivingLicense,
    this.insurance,
    this.selfie,
    this.vehicle,
  });

  factory RiderDocumentsModel.fromJson(Map<String, dynamic> json) {
    return RiderDocumentsModel(
      verificationStatus: json['verificationStatus'] as String,
      isResubmitEnabled: json['isResubmitEnabled'] as bool? ?? false,
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

  RiderDocumentsModel copyWith({
    String? verificationStatus,
    bool? isResubmitEnabled,
    DateTime? submittedAt,
    Nid? nid,
    DrivingLicense? drivingLicense,
    Insurance? insurance,
    Selfie? selfie,
    Vehicle? vehicle,
  }) {
    return RiderDocumentsModel(
      verificationStatus: verificationStatus ?? this.verificationStatus,
      submittedAt: submittedAt ?? this.submittedAt,
      isResubmitEnabled: isResubmitEnabled ?? this.isResubmitEnabled,
      nid: nid ?? this.nid,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      insurance: insurance ?? this.insurance,
      selfie: selfie ?? this.selfie,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'verificationStatus': verificationStatus,
      'isResubmitEnabled': isResubmitEnabled,
      'submittedAt': submittedAt,
      'nid': nid?.toJson(),
      'drivingLicense': drivingLicense?.toJson(),
      'insurance': insurance?.toJson(),
      'selfie': selfie?.toJson(),
      'vehicle': vehicle?.toJson(),
    };
  }
}

class Nid {
  final DocumentSide front;
  final DocumentSide back;

  Nid({
    required this.front,
    required this.back,
  });

  factory Nid.fromJson(Map<String, dynamic> json) {
    return Nid(
      front: DocumentSide.fromJson(json['front'] as Map<String, dynamic>),
      back: DocumentSide.fromJson(json['back'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'front': front.toJson(),
      'back': back.toJson(),
    };
  }
}

class DrivingLicense {
  final DocumentSide front;
  final DocumentSide back;

  DrivingLicense({
    required this.front,
    required this.back,
  });

  factory DrivingLicense.fromJson(Map<String, dynamic> json) {
    return DrivingLicense(
      front: DocumentSide.fromJson(json['front'] as Map<String, dynamic>),
      back: DocumentSide.fromJson(json['back'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'front': front.toJson(),
      'back': back.toJson(),
    };
  }
}

class Insurance {
  final DocumentSide document;
  const Insurance({
    required this.document,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) {
    return Insurance(
      document: DocumentSide.fromJson(json['document'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'document': document.toJson(),
    };
  }
}

class Selfie {
  final DocumentSide image;
  const Selfie({
    required this.image,
  });

  factory Selfie.fromJson(Map<String, dynamic> json) {
    return Selfie(
      image: DocumentSide.fromJson(json['image'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'image': image.toJson(),
    };
  }
}

class Vehicle {
  final DocumentSide image;
  final String vehicleType;
  final String model;
  final String manufacturer;
  final String yearOfManufacture;
  final String color;
  final String numberPlate;
  const Vehicle({
    required this.image,
    required this.vehicleType,
    required this.model,
    required this.manufacturer,
    required this.yearOfManufacture,
    required this.color,
    required this.numberPlate,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      image: DocumentSide.fromJson(json['image'] as Map<String, dynamic>),
      vehicleType: json['vehicleType'] as String,
      model: json['model'] as String,
      manufacturer: json['manufacturer'] as String,
      yearOfManufacture: json['yearOfManufacture'] as String,
      color: json['color'] as String,
      numberPlate: json['numberPlate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'image': image.toJson(),
      'vehicleType': vehicleType,
      'model': model,
      'manufacturer': manufacturer,
      'yearOfManufacture': yearOfManufacture,
      'color': color,
      'numberPlate': numberPlate,
    };
  }
}

class DocumentSide {
  final String filename;
  final String url;
  final DateTime uploadedAt;
  final String status;

  DocumentSide({
    required this.filename,
    required this.url,
    required this.uploadedAt,
    required this.status,
  });

  factory DocumentSide.fromJson(Map<String, dynamic> json) {
    return DocumentSide(
      filename: json['filename'] as String,
      url: json['url'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'filename': filename,
      'url': url,
      'uploadedAt': uploadedAt.toIso8601String(),
      'status': status,
    };
  }
}
