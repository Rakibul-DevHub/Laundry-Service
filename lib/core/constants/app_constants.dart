/// [AppConstants] APP related constants
class AppConstants {
  AppConstants._();
  // Base URL with version from external backend
  // static const String baseUrl = 'https://api.dropnfreshapp.com/api/v1';

  //live server: https://api.dropnfreshapp.com

  /**static const String baseUrl =
      'https://api.dropnfreshapp.com/api/v1';*/

  static const String baseUrl =
      "https://zrz9f9td-8010.inc1.devtunnels.ms/api/v1";


  /// S3 bucket used for profile and other uploaded media.
  static const String imageBaseUrl =
      'https://dropnfresh-prod.s3.us-east-1.amazonaws.com/';

  static String? resolveMediaUrl(dynamic value) {
    final String? path = _mediaPath(value);
    if (path == null) {
      return null;
    }
    if (path.startsWith('http://') ||
        path.startsWith('https://') ||
        path.startsWith('data:') ||
        path.startsWith('file:')) {
      return path;
    }
    final String relative = path.startsWith('/') ? path.substring(1) : path;
    return '$imageBaseUrl$relative';
  }

  static String? _mediaPath(dynamic value) {
    if (value == null || value is bool || value is num) {
      return null;
    }

    String? path;
    if (value is String) {
      path = value;
    } else if (value is Map) {
      path = (value['url'] ??
              value['src'] ??
              value['filePath'] ??
              value['path'] ??
              value['profilePicture'])
          ?.toString();
    } else {
      return null;
    }

    final String trimmed = path?.trim() ?? '';
    if (trimmed.isEmpty ||
        trimmed == 'null' ||
        trimmed == 'undefined' ||
        trimmed == 'false') {
      return null;
    }
    return trimmed;
  }

  // Base URL for socket connection
  static String get socketBaseUrl => baseUrl;
  // Timeout durations
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  // HTTP headers
  static const String contentType = 'application/json';
  static const String authHeaderKey = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
