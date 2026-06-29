// location_update_response.dart

class LocationUpdateResponse {
  final int code;
  final bool success;
  final String message;

  LocationUpdateResponse({
    required this.code,
    required this.success,
    required this.message,
  });

  factory LocationUpdateResponse.fromJson(Map<String, dynamic> json) {
    return LocationUpdateResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'success': success,
      'message': message,
    };
  }
}
