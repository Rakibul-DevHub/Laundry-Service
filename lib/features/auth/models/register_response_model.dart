class RegistrationResponseModel {
  final int code;
  final bool success;
  final String message;
  final RegistrationData? data;

  RegistrationResponseModel({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResponseModel(
      code: json['code'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? RegistrationData.fromJson(json['data'] as Map<String, dynamic>)
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

class RegistrationData {
  final String verificationToken;

  RegistrationData({required this.verificationToken});

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      verificationToken: json['verificationToken'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'verificationToken': verificationToken,
    };
  }
}
