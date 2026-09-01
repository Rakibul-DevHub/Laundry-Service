part of '../api_client.dart';

class ApiRequest {
  /// [sendRequest] Sends the network request using the appropriate HTTP method.
  Future<Response<dynamic>> sendRequest(
    {
      required Dio dio,
      required HttpMethod httpMethod,
      required String endpoint,
      Map<String, dynamic>? queryParameters,
      dynamic data,
      Map<String, List<File>>? fileFields
    }
  ) async {
    final dynamic body = _prepareData(data, fileFields);
    final Options? options = _requestOptions(fileFields);
    switch (httpMethod) {
      case HttpMethod.get:
        return await dio.get(endpoint, queryParameters: queryParameters);
      case HttpMethod.post:
        return await dio.post(
          endpoint,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case HttpMethod.put:
        return await dio.put(
          endpoint,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case HttpMethod.patch:
        return await dio.patch(
          endpoint,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case HttpMethod.delete:
        return await dio.delete(
          endpoint,
          queryParameters: queryParameters,
          data: data,
        );
    }
  }

  Options? _requestOptions(Map<String, List<File>>? fileFields) {
    if (fileFields == null || fileFields.isEmpty) {
      return null;
    }
    return Options(contentType: Headers.multipartFormDataContentType);
  }

  /// [prepareData]  Prepares data for request, including handling multipart file uploads.
  dynamic _prepareData(dynamic data, Map<String, List<File>>? fileFields) {
    if (fileFields == null || fileFields.isEmpty) {
      return data;
    }

    final FormData formData = FormData.fromMap(
      data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    for (final MapEntry<String, List<File>> entry in fileFields.entries) {
      final String fieldName = entry.key;
      final List<File> files = entry.value;

      for (final File file in files) {
        formData.files.add(
          MapEntry<String, MultipartFile>(
            fieldName,
            MultipartFile.fromFileSync(
              file.path,
              contentType: DioMediaType('image', _imageSubtype(file.path)),
              filename: file.uri.pathSegments.last,
            ),
          ),
        );
      }
    }
    return formData;
  }

  String _imageSubtype(String path) {
    final String ext = path.split('.').last.toLowerCase();
    if (ext == 'jpg') {
      return 'jpeg';
    }
    if (ext == 'png' || ext == 'jpeg' || ext == 'gif' || ext == 'webp') {
      return ext;
    }
    return 'jpeg';
  }
}