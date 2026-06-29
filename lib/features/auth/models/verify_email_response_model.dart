import '../../../shared/models/user_model.dart';

class VerifyEmailResponseModel {
  final int code;
  final bool success;
  final String message;
  final VerificationData? data;

  VerifyEmailResponseModel({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponseModel(
      code: json['code'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] is String ? json['message'] as String : '',
      data: json['data'] != null
          ? VerificationData.fromJson(json['data'] as Map<String, dynamic>)
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

class VerificationData {
  final User user;
  final String accessToken;
  final String refreshToken;

  VerificationData({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory VerificationData.fromJson(Map<String, dynamic> json) {
    return VerificationData(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] is String
          ? json['accessToken'] as String
          : '',
      refreshToken: json['refreshToken'] is String
          ? json['refreshToken'] as String
          : '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user': user.toJson(),
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}
