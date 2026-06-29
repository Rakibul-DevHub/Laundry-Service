import 'uploaded_documents.dart';

class UploadNidResponse {
  final int code;
  final bool success;
  final String message;
  final NidUploadData data;

  UploadNidResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory UploadNidResponse.fromJson(Map<String, dynamic> json) {
    return UploadNidResponse(
      code: (json['code'] as num).toInt(),
      success: json['success'] as bool,
      message: json['message'] as String,
      data: NidUploadData.fromJson(
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

class NidUploadData {
  final UploadedDocument nidFront;
  final UploadedDocument nidBack;

  NidUploadData({
    required this.nidFront,
    required this.nidBack,
  });

  factory NidUploadData.fromJson(Map<String, dynamic> json) {
    return NidUploadData(
      nidFront: UploadedDocument.fromJson(
        json['nidFront'] as Map<String, dynamic>,
      ),
      nidBack: UploadedDocument.fromJson(
        json['nidBack'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nidFront': nidFront.toJson(),
      'nidBack': nidBack.toJson(),
    };
  }
}

