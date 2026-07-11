import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/utils/app_logger.dart';
import 'exceptions/exceptions.dart';

part "./endpoints/api_endpoints.dart";
part "./exceptions/exception_handler.dart";
part "./interceptors/auth_interceptor.dart";
part "./interceptors/logging_interceptor.dart";
part "./request/api_request.dart";
part "./response/api_response.dart";
// part of this api client classes
part 'http_method.dart';

/// API client for making HTTP requests
class ApiClient {
  final Dio _dio;

  ApiClient({
    required Dio dio,
    required LoggingInterceptor loggingInterceptor,
    required AuthInterceptor authInterceptor,
  }) : _dio = dio {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      responseType: ResponseType.json,
      contentType: AppConstants.contentType,
    );

    // Add interceptors
    _dio.interceptors.add(authInterceptor);
    _dio.interceptors.add(loggingInterceptor);
  }

  /// [handleRequest] Handles network requests that return a single object or primitive value.
  Future<T> handleRequest<T>({
    required HttpMethod httpMethod,
    required String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, List<File>>? fileFields,
  }) async {
    try {
      final Response<dynamic> response = await ApiRequest().sendRequest(
        dio: _dio,
        httpMethod: httpMethod,
        endpoint: endpoint,
        queryParameters: queryParameters,
        data: data,
        fileFields: fileFields,
      );
      return ApiResponse().parseResponse<T>(
        response: response,
        fromJson: fromJson,
      );
    } on DioException catch (exception) {
      throw ExceptionHandler.handleDioError(exception);
    } catch (exception) {
      throw UnknownException(
        message: "Unexpected Error: ${exception.toString()}",
      );
    }
  }

  /// [handleListRequest] network requests that return a list of objects.
  Future<List<T>> handleListRequest<T>({
    required HttpMethod httpMethod,
    required String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, List<File>>? fileFields,
  }) async {
    try {
      final Response<dynamic> response = await ApiRequest().sendRequest(
        dio: _dio,
        httpMethod: httpMethod,
        endpoint: endpoint,
        queryParameters: queryParameters,
        data: data,
        fileFields: fileFields,
      );
      return ApiResponse().parseListResponse<T>(
        response: response,
        fromJson: fromJson,
      );
    } on DioException catch (exception) {
      throw ExceptionHandler.handleDioError(exception);
    } catch (exception) {
      throw UnknownException(
        message: "Unexpected Error: ${exception.toString()}",
      );
    }
  }
}
