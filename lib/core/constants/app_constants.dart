/// [AppConstants] APP related constants
class AppConstants {
  AppConstants._();
  // Base URL with version from external backend
  // static const String baseUrl = 'https://api.dropnfreshapp.com/api/v1';
  static const String baseUrl =
      'https://zrz9f9td-8010.inc1.devtunnels.ms/api/v1';
  //  Base URL for images
  // static const String imageBaseUrl = 'https://api.dropnfreshapp.com/';
  static const String imageBaseUrl =
      'https://zrz9f9td-8010.inc1.devtunnels.ms/';
  // Base URL for socket connection
  // static const String socketBaseUrl = 'https://api.dropnfreshapp.com';
  static const String socketBaseUrl =
      'https://zrz9f9td-8010.inc1.devtunnels.ms/api/v1';
  // Timeout durations
  static const int connectTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
  // HTTP headers
  static const String contentType = 'application/json';
  static const String authHeaderKey = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
