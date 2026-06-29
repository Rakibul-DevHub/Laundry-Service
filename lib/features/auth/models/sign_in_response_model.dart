import '../../../shared/models/user_model.dart';

class SignInResponseModel {
  final int code;
  final bool success;
  final String message;
  final SignInData? data;

  SignInResponseModel({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      code: json['code'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] is String ? json['message'] as String : '',
      data: json['data'] != null
          ? SignInData.fromJson(json['data'] as Map<String, dynamic>)
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

class SignInData {
  final User user;
  final String accessToken;
  final String refreshToken;

  SignInData({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory SignInData.fromJson(Map<String, dynamic> json) {
    return SignInData(
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
