import 'service_list_response.dart';

class ServiceDetailResponse {
  final int code;
  final bool success;
  final String message;
  final ProviderService data; // Same model as list, just single item

  ServiceDetailResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ProviderService.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
