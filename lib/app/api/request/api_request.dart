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
    switch (httpMethod) {
      case HttpMethod.get:
        return await dio.get(endpoint, queryParameters: queryParameters);
      case HttpMethod.post:
        return await dio.post(endpoint, data: _prepareData(data, fileFields));
      case HttpMethod.put:
        return await dio.put(endpoint, data: _prepareData(data, fileFields));
      case HttpMethod.patch:
        return await dio.patch(endpoint, data: _prepareData(data, fileFields));
      case HttpMethod.delete:
        return await dio.delete(
          endpoint,
          queryParameters: queryParameters,
          data: data,
        );
    }
  }

  /// [prepareData]  Prepares data for request, including handling multipart file uploads.
  dynamic _prepareData(dynamic data, Map<String, List<File>>? fileFields) {
    final FormData formData = FormData.fromMap(
      data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    if (fileFields != null && fileFields.isNotEmpty) {
      for (final MapEntry<String, List<File>> entry in fileFields.entries) {
        final String fieldName = entry.key;
        final List<File> files = entry.value;

        for (final File file in files) {
          formData.files.add(
            MapEntry<String, MultipartFile>(
              fieldName,
              MultipartFile.fromFileSync(
                file.path,
                contentType: DioMediaType(
                  'image',
                  file.path.split('.').last.toLowerCase(),
                ),
                filename: file.uri.pathSegments.last,
              ),
            ),
          );
        }
      }
    }
    if (fileFields != null && fileFields.isNotEmpty) {
      return formData;
    } else {
      return data;
    }
  }
}