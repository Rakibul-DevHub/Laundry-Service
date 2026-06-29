part of "../api_client.dart";


/// [LoggingInterceptor] Interceptor for logging API requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger().i(
      <String, dynamic>{
        "TYPE": "ON_REQUEST",
        'Method': options.method,
        'Uri': options.uri,
        'Headers': options.headers,
        "queryParameters": options.queryParameters,
        'Data': options.data,
      }.toString(),
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger().d(
      <String, dynamic>{
        "TYPE": "ON_RESPONSE",
        'Method': response.requestOptions.method,
        'Uri': response.requestOptions.uri,
        'Headers': response.requestOptions.headers,
        'Data': response.data,
      }.toString(),
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger().i(
      <String, dynamic>{
        "TYPE": "ON_ERROR",
        'Method': err.response?.requestOptions.method,
        'Uri': err.response?.requestOptions.uri,
        'Headers': err.response?.requestOptions.headers,
        'Message': err.message,
        "Status Code": err.response?.statusCode,
        "Error Response Data": err.response?.data,
      }.toString(),
    );
    super.onError(err, handler);
  }
}
