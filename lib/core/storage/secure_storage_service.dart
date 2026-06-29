import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/app_logger.dart';

/// A secure storage service for storing sensitive data like tokens.
///
/// Uses the `flutter_secure_storage` plugin with platform-specific options.
/// Implements the Singleton pattern to ensure a single instance throughout the app.
///
/// Example usage:
/// ```dart
/// await SecureStorageService().write('token', 'abc123');
/// final token = await SecureStorageService().read('token');
/// ```
class SecureStorageService {
  // Singleton instance
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  /// Factory constructor to return the singleton instance.
  factory SecureStorageService() => _instance;

  /// Internal instance of [FlutterSecureStorage] with platform-specific configuration.
  final FlutterSecureStorage _storage;

  /// Private constructor with secure options for Android and iOS.
  SecureStorageService._internal()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(enforceBiometrics: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );

  /// Writes a [value] to secure storage for the given [key].
  Future<void> write(String key, String? value) async {
    AppLogger().i("WRITE SECURE STORAGE --> key: $key || saveValue : $value");
    await _storage.write(key: key, value: value);
  }

  /// Reads and returns the value associated with the given [key].
  ///
  /// Returns `null` if the key does not exist.
  Future<String?> read(String key) async {
    final String? retrieveValue = await _storage.read(key: key);
    AppLogger().i(
      "READ SECURE STORAGE --> key: $key || retrieveValue : $retrieveValue",
    );
    return await _storage.read(key: key);
  }

  /// Deletes the value associated with the given [key].
  Future<void> delete(String key) async {
    AppLogger().i("DELETE SECURE STORAGE --> key: $key");
    await _storage.delete(key: key);
  }

  /// Clears all stored key-value pairs from secure storage.
  Future<void> clear() async {
    AppLogger().i("CLEAR SECURE STORAGE");
    await _storage.deleteAll();
  }

  /// Checks whether a given [key] exists in secure storage.
  Future<bool> containsKey(String key) async {
    final Map<String, String> all = await _storage.readAll();
    final bool isContain = all.containsKey(key);
    AppLogger().i("CONTAINS KEY SECURE STORAGE --> key: $key || isContain : $isContain");
    return isContain;
  }
}
