class VerifyResetEmailResponseModel {
  final int code;
  final bool success;
  final String message;
  final VerificationData? data;

  VerifyResetEmailResponseModel({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyResetEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyResetEmailResponseModel(
      code: json['code'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] is String ? json['message'] as String : '',
      data: json['data'] != null
          ? VerificationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class VerificationData {
  final String resetPasswordToken;

  VerificationData({
    required this.resetPasswordToken,
  });

  factory VerificationData.fromJson(Map<String, dynamic> json) {
    return VerificationData(
      resetPasswordToken: json['resetPasswordToken'] is String
          ? json['resetPasswordToken'] as String
          : '',
    );
  }
}
