class CreateServiceResponse {
  final int code;
  final bool success;
  final String message;
  final dynamic data; // Service ID if created

  CreateServiceResponse({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateServiceResponse.fromJson(Map<String, dynamic> json) {
    return CreateServiceResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
    );
  }
}
