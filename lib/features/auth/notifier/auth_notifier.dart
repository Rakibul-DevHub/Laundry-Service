part of '../providers/auth_providers.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState()) {
    AppLogger().d("AuthNotifier BUILD");

    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);
    final String? token = await secureStorage.read(StorageKeys.accessToken);
    AppLogger().d("AuthNotifier token : $token");
    final String? roleString = await secureStorage.read(StorageKeys.role);
    AppLogger().d("AuthNotifier roleString : $roleString");

    if (token != null && roleString != null) {
      final Role? role = Role.fromString(roleString);
      if (role != null) {
        state = AuthState(isLoggedIn: true, role: role);
        AppLogger().d("AuthNotifier state : ${state.toString()}");
        return;
      }
    }

    // If anything missing, treat as logged out
    state = const AuthState();
    AppLogger().d("AuthNotifier state : ${state.toString()}");
  }

  Future<void> access(String token, String refresh, Role role) async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.write(StorageKeys.accessToken, token);
    await secureStorage.write(StorageKeys.refreshToken, refresh);
    await secureStorage.write(StorageKeys.role, role.toJson());
    state = AuthState(isLoggedIn: true, role: role);
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
    state = AuthState(isLoggedIn: true, role: role);
  }

  Future<void> logout() async {
    final SecureStorageService secureStorage = _ref.read(secureStorageProvider);

    await secureStorage.clear();
    await secureStorage.write(
      StorageKeys.onboardingSeen,
      "true",
    );
    _ref.read(resetAppProvider)();
    // _ref.invalidate(bottomNavProvider);
  }
}
