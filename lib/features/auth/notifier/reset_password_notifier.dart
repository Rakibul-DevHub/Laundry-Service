import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/router/app_router.dart';
import '../../../app/router/route_paths.dart';
import '../../../app/toast/toast.dart';
import '../../../core/utils/app_validation.dart';
import '../providers/auth_providers.dart';
import '../state/reset_password_state.dart';

class ResetPasswordNotifier extends AutoDisposeNotifier<ResetPasswordState> {
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;

  @override
  ResetPasswordState build() {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);
    return const ResetPasswordState();
  }

  void setNewPassword(String password) {
    state = state.copyWith(
      newPassword: password,
      newPasswordError: null,
      generalError: null,
    );
  }

  void setConfirmPassword(String password) {
    state = state.copyWith(
      confirmPassword: password,
      confirmPasswordError: null,
      generalError: null,
    );
  }

  void validateNewPassword() {
    final String? error = AppValidation.validatePassword(state.newPassword);
    state = state.copyWith(newPasswordError: error);
  }

  void validateConfirmPassword() {
    final String? error = AppValidation.validateConfirmPassword(
      state.newPassword,
      state.confirmPassword,
    );

    state = state.copyWith(confirmPasswordError: error);
  }

  Future<void> resetPassword(String token) async {
    // Validate fields
    validateNewPassword();
    validateConfirmPassword();

    if (!state.isValid) {
      return;
    }

    try {
      state = state.copyWith(isSubmitting: true, generalError: null);
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.resetPassword,
            data: <String, String>{
              "password": state.newPassword,
              "confirmPassword": state.confirmPassword,
            },
          );
      await ref.read(authProvider.notifier).resetPasswordRemove();
      Toast.showSuccess(response['message'] as String);
      _appRouter.go(
        RoutePaths.signIn,
      );
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
