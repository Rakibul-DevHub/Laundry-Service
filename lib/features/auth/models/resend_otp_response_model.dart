class ResendOtpResponseModel {
  final int code;
  final bool success;
  final String message;
  final ResendOtpData? data;

  ResendOtpResponseModel({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      code: json['code'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ResendOtpData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ResendOtpData {
  final String verificationToken;

  ResendOtpData({required this.verificationToken});

  factory ResendOtpData.fromJson(Map<String, dynamic> json) {
    return ResendOtpData(
      verificationToken: json['verificationToken'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'verificationToken': verificationToken,
    };
  }
}
