part of "../api_client.dart";

/// [AuthInterceptor] Interceptor to add authorization headers to requests
class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorage;

  AuthInterceptor({required this.secureStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final bool isRefreshRequest =
        options.path.contains('refresh-token') ||
        options.uri.path.contains('refresh-token');
    if (isRefreshRequest) {
      super.onRequest(options, handler);
      return;
    }

    final String? token = await secureStorage.read(StorageKeys.accessToken);
    final String? resetPasswordToken = await secureStorage.read(
      StorageKeys.resetPasswordToken,
    );

    if (resetPasswordToken != null) {
      AppLogger().d(
        'Adding auth reset password token to request $resetPasswordToken',
      );
      options.headers[AppConstants.authHeaderKey] =
          '${AppConstants.bearerPrefix}$resetPasswordToken';
    } else if (token != null) {
      AppLogger().d('Adding auth token to request $token');
      options.headers[AppConstants.authHeaderKey] =
          '${AppConstants.bearerPrefix}$token';
    }

    super.onRequest(options, handler);
  }
}
