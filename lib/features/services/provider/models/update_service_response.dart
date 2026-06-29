import 'service_list_response.dart';

class UpdateServiceResponse {
  final int code;
  final bool success;
  final String message;
  final ProviderService data;

  UpdateServiceResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateServiceResponse.fromJson(Map<String, dynamic> json) {
    return UpdateServiceResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ProviderService.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
