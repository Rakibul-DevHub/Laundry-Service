import 'uploaded_documents.dart';

class UploadInsuranceResponse {
  final int code;
  final bool success;
  final String message;
  final UploadedDocument insurance;

  UploadInsuranceResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.insurance,
  });

  factory UploadInsuranceResponse.fromJson(Map<String, dynamic> json) {
    return UploadInsuranceResponse(
      code: (json['code'] as num).toInt(),
      success: json['success'] as bool,
      message: json['message'] as String,
      insurance: UploadedDocument.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'success': success,
      'message': message,
      'data': insurance.toJson(),
    };
  }
}
