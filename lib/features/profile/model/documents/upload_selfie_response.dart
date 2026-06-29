import 'uploaded_documents.dart';

class UploadSelfieResponse {
  final int code;
  final bool success;
  final String message;
  final UploadedDocument selfie;

  UploadSelfieResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.selfie,
  });

  factory UploadSelfieResponse.fromJson(Map<String, dynamic> json) {
    return UploadSelfieResponse(
      code: (json['code'] as num).toInt(),
      success: json['success'] as bool,
      message: json['message'] as String,
      selfie: UploadedDocument.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'success': success,
      'message': message,
      'data': selfie.toJson(),
    };
  }
}
