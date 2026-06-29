part of '../api_client.dart';

class ApiResponse {
  /// [_parseResponse] Parses the Dio response and returns a single object.
  Future<T> parseResponse<T>({
    required Response<dynamic> response,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw ExceptionHandler.handleErrorStatus(response);
    }
    if (fromJson != null) {
      if (response.data is Map<String, dynamic>) {
        return fromJson(response.data as Map<String, dynamic>);
      }
    }
    if (response.data is T) {
      return response.data as T;
    }
    throw TypeException(
      message: "Unexpected response type: ${response.runtimeType}, expected List",
      statusCode: response.statusCode,
    );
  }

  /// [_parseListResponse] Parses a Dio response and returns a list of deserialized objects.
  List<T> parseListResponse<T>({
    required Response<dynamic> response,
    T Function(Map<String, dynamic>)? fromJson,
  }) {
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw ExceptionHandler.handleErrorStatus(response);
    }

    final dynamic responseData = response.data;

    if (fromJson != null) {
      if (responseData is List) {
        return responseData.map((dynamic json) {
          if (json is Map<String, dynamic>) {
            return fromJson(json);
          } else {
            throw TypeException(
              message: "Expected Map<String, dynamic> but got ${json.runtimeType}",
              statusCode: response.statusCode,
            );
          }
        }).toList();
      } else {
        throw TypeException(
          message: "Unexpected response type: ${responseData.runtimeType}, expected List",
          statusCode: response.statusCode,
        );
      }
    }
    return <dynamic>[responseData] as List<T>;
  }
}
