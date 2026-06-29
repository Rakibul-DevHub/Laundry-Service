import '../../../shared/models/user_model.dart';

class ProfileUpdateResponse {
  final int code;
  final bool success;
  final String message;
  final User data;

  ProfileUpdateResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      code: json['code'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] is String ? json['message'] as String : '',
      data: User.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}
