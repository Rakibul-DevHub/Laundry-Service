import 'package:drop_n_fresh/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/enums/role.dart';
import 'auth_providers.dart';

part '../state/auth_flow_decision.dart';

/// Determines the next screen after splash
/// Used by [SplashScreen] to decide navigation
final FutureProvider<AuthFlowDecision> authFlowProvider =
    FutureProvider<AuthFlowDecision>((
      // ignore: deprecated_member_use
      FutureProviderRef<AuthFlowDecision> ref,
    ) async {
      AppLogger().d("authFlowProvider");

      await Future.wait(<Future<void>>[
        Future<void>.delayed(const Duration(seconds: 5)),
        ref.read(authProvider.notifier).ensureInitialized(),
      ]);

      final AuthState auth = ref.read(authProvider);
      final SecureStorageService secureStorage = ref.read(
        secureStorageProvider,
      );
      final String? riderDocumentsSubmit = await secureStorage.read(
        StorageKeys.riderDocumentsSubmit,
      );
      AppLogger().d(
        "authFlowProvider ==> isLoggedIn : ${auth.isLoggedIn} || role : ${auth.role}",
      );

      if (auth.isLoggedIn && auth.role != null) {
        if (auth.role == Role.rider && riderDocumentsSubmit != "true") {
          AppLogger().d("authFlowProvider ==> rider document didn't submit");
          return const AuthFlowDecision.goToRiderDocuments();
        }
        AppLogger().d("authFlowProvider ==> Logged in → go to home");
        return AuthFlowDecision.goToHome(role: auth.role!);
      }

      final String? hasSeenOnboarding = await secureStorage.read(
        StorageKeys.onboardingSeen,
      );

      if (hasSeenOnboarding != "true") {
        AppLogger().d("authFlowProvider ==> First time → show onboarding");
        return const AuthFlowDecision.goToOnboarding();
      }

      AppLogger().d(
        "authFlowProvider ==> Returning user, not logged in → login",
      );
      return const AuthFlowDecision.goToLogin();
    });
