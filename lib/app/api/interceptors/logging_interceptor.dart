part of "../api_client.dart";

/// [LoggingInterceptor] Interceptor for logging API requests and responses
class LoggingInterceptor extends Interceptor {
  // Use a pretty encoder so your API payload isn't an unreadable single line
  final JsonEncoder _encoder = JsonEncoder.withIndent('  ', _toEncodable);

  static Object? _toEncodable(dynamic object) {
    if (object is FormData) {
      return <String, dynamic>{
        'fields': object.fields
            .map(
              (MapEntry<String, String> field) => <String, String>{
                field.key: field.value,
              },
            )
            .toList(),
        'files': object.files
            .map(
              (MapEntry<String, MultipartFile> file) => <String, String?>{
                'field': file.key,
                'filename': file.value.filename,
              },
            )
            .toList(),
      };
    }
    return object.toString();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger().i(
      _encoder.convert(<String, dynamic>{
        "TYPE": "ON_REQUEST",
        'Method': options.method,
        'Uri': options.uri.toString(),
        'Headers': options.headers,
        "queryParameters": options.queryParameters,
        'Data': options.data,
      }),
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response,
      ResponseInterceptorHandler handler,
      ) {
    AppLogger().d(
      _encoder.convert(<String, dynamic>{
        "TYPE": "ON_RESPONSE",
        'Method': response.requestOptions.method,
        'Uri': response.requestOptions.uri.toString(),
        'Headers': response.requestOptions.headers,
        'Data': response.data,
      }),
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Changed .i to .e so this actually logs as an Error
    AppLogger().e(
      _encoder.convert(<String, dynamic>{
        "TYPE": "ON_ERROR",
        'Method': err.response?.requestOptions.method,
        'Uri': err.response?.requestOptions.uri.toString(),
        'Headers': err.response?.requestOptions.headers,
        'Message': err.message,
        "Status Code": err.response?.statusCode,
        "Error Response Data": err.response?.data,
      }),
      error: err,
      stackTrace: err.stackTrace,
    );
    super.onError(err, handler);
  }
}