class ChangePasswordResponseModel {
  final int code;
  final bool success;
  final String message;
  final ChangePasswordData? data;

  ChangePasswordResponseModel({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      code: json['code'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ChangePasswordData.fromJson(json['data'] as Map<String, dynamic>)
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

class ChangePasswordData {
  final String accessToken;
  final String refreshToken;

  ChangePasswordData({required this.accessToken, required this.refreshToken});

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) {
    return ChangePasswordData(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
