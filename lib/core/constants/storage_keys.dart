/// [StorageKeys] Centralized storage keys to avoid duplication and typos
class StorageKeys {
  StorageKeys._();
  // Secure storage keys (sensitive data)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  static const String resetPasswordToken = 'reset_password_token';

  static const String riderDocumentsSubmit = 'rider_documents_submit';

  static const String role = 'role';

  static const String userId = 'userId';

  static const String interestPage = 'interestPage';
  static const String shopCompletePage = 'shopCompletePage';

  // storage keys (non-sensitive data)
  static const String themeMode = 'theme_mode';
  static const String currentUser = 'current_user';
  static const String appSettings = 'app_settings';

  static const String onboardingSeen = 'onboarding_seen';
}
