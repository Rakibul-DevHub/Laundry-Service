import 'package:drop_n_fresh/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/enums/role.dart';

part '../state/auth_flow_decision.dart';

/// Determines the next screen after splash
/// Used by [SplashScreen] to decide navigation
final FutureProvider<AuthFlowDecision> authFlowProvider =
    FutureProvider<AuthFlowDecision>((
      // ignore: deprecated_member_use
      FutureProviderRef<AuthFlowDecision> ref,
    ) async {
      AppLogger().d("authFlowProvider");

      await Future<dynamic>.delayed(const Duration(seconds: 5));

      final SecureStorageService secureStorage = ref.read(
        secureStorageProvider,
      );

      // 1. Check if user is logged in
      final String? token = await secureStorage.read(StorageKeys.accessToken);
      final String? roleString = await secureStorage.read(StorageKeys.role);
      final String? riderDocumentsSubmit = await secureStorage.read(
        StorageKeys.riderDocumentsSubmit,
      );
      final Role? role = Role.fromString(roleString);
      AppLogger().d("authFlowProvider ==> token : $token || role : $role");

      if (token != null && role != null) {
        if (role == Role.rider && riderDocumentsSubmit != "true") {
          // Logged in →  rider document didn't submit
          AppLogger().d("authFlowProvider ==> rider document didn't submit");
          return const AuthFlowDecision.goToRiderDocuments();
        }
        // Logged in → go to home
        AppLogger().d("authFlowProvider ==> Logged in → go to home");
        return AuthFlowDecision.goToHome(role: role);
      }

      // 2. Check if onboarding was seen
      final String? hasSeenOnboarding = await secureStorage.read(
        StorageKeys.onboardingSeen,
      );

      if (hasSeenOnboarding != "true") {
        // First time → show onboarding
        AppLogger().d("authFlowProvider ==> // First time → show onboarding");
        return const AuthFlowDecision.goToOnboarding();
      }

      AppLogger().d(
        "authFlowProvider ==> // Returning user, not logged in → login",
      );
      // 3. Returning user, not logged in → login
      return const AuthFlowDecision.goToLogin();
    });
