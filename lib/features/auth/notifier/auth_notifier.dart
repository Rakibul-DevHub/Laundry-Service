part of '../providers/auth_providers.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  final Completer<void> _initCompleter = Completer<void>();

  AuthNotifier(this._ref) : super(const AuthState()) {
    AppLogger().d("AuthNotifier BUILD");
    _initializeAuth();
  }

  Future<void> ensureInitialized() => _initCompleter.future;

  Future<void> _initializeAuth() async {
    try {
      final SecureStorageService secureStorage = _ref.read(
        secureStorageProvider,
      );
      String? token = await secureStorage.read(StorageKeys.accessToken);
      final String? refreshToken = await secureStorage.read(
        StorageKeys.refreshToken,
      );
      final String? roleString = await secureStorage.read(StorageKeys.role);
      AppLogger().d("AuthNotifier roleString : $roleString");

      if (token != null &&
          token.isNotEmpty &&
          !JwtUtils.isAccessTokenActive(token)) {
        if (refreshToken != null && refreshToken.isNotEmpty) {
          final bool refreshed = await _refreshSession(refreshToken);
          if (refreshed) {
            token = await secureStorage.read(StorageKeys.accessToken);
          } else {
            token = null;
          }
        } else {
          token = null;
        }
      }

      final Role? role =
          Role.fromString(roleString) ?? JwtUtils.roleFromToken(token);

      if (token != null &&
          token.isNotEmpty &&
          JwtUtils.isAccessTokenActive(token) &&
          role != null) {
        if (roleString == null || roleString.isEmpty) {
          await secureStorage.write(StorageKeys.role, role.toJson());
        }
        state = AuthState(
          isLoggedIn: true,
          role: role,
          isInitialized: true,
        );
        AppLogger().d("AuthNotifier state : ${state.toString()}");
        return;
      }

      state = const AuthState(isInitialized: true);
      AppLogger().d("AuthNotifier state : ${state.toString()}");
    } catch (e, stackTrace) {
      AppLogger().e(
        'AuthNotifier init failed',
        error: e,
        stackTrace: stackTrace,
      );
      state = const AuthState(isInitialized: true);
    } finally {
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  Future<bool> _refreshSession(String refreshToken) async {
    try {
      final ApiClient apiClient = _ref.read(apiClientProvider);
      final Map<String, dynamic> response = await apiClient.handleRequest(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.refreshToken,
        data: <String, String>{'refreshToken': refreshToken},
        fromJson: (Map<String, dynamic> json) => json,
      );
      final dynamic payload = response['data'] ?? response;
      if (payload is! Map) {
        return false;
      }
      final String? accessToken = payload['accessToken']?.toString();
      final String? newRefreshToken = payload['refreshToken']?.toString();
      if (accessToken == null || accessToken.isEmpty) {
        return false;
      }

      final SecureStorageService secureStorage = _ref.read(
        secureStorageProvider,
      );
      await secureStorage.write(StorageKeys.accessToken, accessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await secureStorage.write(StorageKeys.refreshToken, newRefreshToken);
      }
      return JwtUtils.isAccessTokenActive(accessToken);
    } catch (e, stackTrace) {
      AppLogger().e(
        'AuthNotifier token refresh failed',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> access(String token, String refresh, Role role) async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.write(StorageKeys.accessToken, token);
    await secureStorage.write(StorageKeys.refreshToken, refresh);
    await secureStorage.write(StorageKeys.role, role.toJson());
    state = AuthState(isLoggedIn: true, role: role, isInitialized: true);
  }

  Future<void> resetPassword(String token) async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.write(StorageKeys.resetPasswordToken, token);
  }

  Future<void> changePassword(String token, String refresh) async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.write(StorageKeys.accessToken, token);
    await secureStorage.write(StorageKeys.refreshToken, refresh);
  }

  Future<void> resetPasswordRemove() async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.delete(StorageKeys.resetPasswordToken);
  }

  Future<void> riderDocumentsSubmit() async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.write(StorageKeys.riderDocumentsSubmit, "true");
  }

  Future<void> loginToken(String token, String refresh, Role role) async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.write(StorageKeys.accessToken, token);
    await secureStorage.write(StorageKeys.refreshToken, refresh);
    await secureStorage.write(StorageKeys.role, role.toJson());
    state = AuthState(isLoggedIn: true, role: role, isInitialized: true);
  }

  Future<void> logout() async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);

    await secureStorage.clear();
    await secureStorage.write(
      StorageKeys.onboardingSeen,
      "true",
    );
    _ref.read(resetAppProvider)();
  }
}
