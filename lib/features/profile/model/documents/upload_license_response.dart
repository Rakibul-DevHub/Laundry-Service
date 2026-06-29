import 'uploaded_documents.dart';

class UploadLicenseResponse {
  final int code;
  final bool success;
  final String message;
  final LicenseUploadData data;

  UploadLicenseResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory UploadLicenseResponse.fromJson(Map<String, dynamic> json) {
    return UploadLicenseResponse(
      code: (json['code'] as num).toInt(),
      success: json['success'] as bool,
      message: json['message'] as String,
      data: LicenseUploadData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
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

class LicenseUploadData {
  final UploadedDocument licenseFront;
  final UploadedDocument licenseBack;

  LicenseUploadData({
    required this.licenseFront,
    required this.licenseBack,
  });

  factory LicenseUploadData.fromJson(Map<String, dynamic> json) {
    return LicenseUploadData(
      licenseFront: UploadedDocument.fromJson(
        json['licenseFront'] as Map<String, dynamic>,
      ),
      licenseBack: UploadedDocument.fromJson(
        json['licenseBack'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'licenseFront': licenseFront.toJson(),
      'licenseBack': licenseBack.toJson(),
    };
  }
}

