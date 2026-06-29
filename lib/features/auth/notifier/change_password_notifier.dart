import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/config/strings.dart';
import '../../../core/utils/app_validation.dart';
import '../models/change_password_response_model.dart';
import '../providers/auth_providers.dart';
import '../state/change_password_state.dart';

class ChangePasswordNotifier extends AutoDisposeNotifier<ChangePasswordState> {
  late final ApiClient _apiClient;
  @override
  ChangePasswordState build() {
    _apiClient = ref.read(apiClientProvider);
    return const ChangePasswordState();
  }

  void setOldPassword(String password) {
    state = state.copyWith(
      oldPassword: password,
      oldPasswordError: null,
      isSuccess: false,
    );
  }

  void setNewPassword(String password) {
    state = state.copyWith(
      newPassword: password,
      newPasswordError: null,
      isSuccess: false,
    );
  }

  void setConfirmPassword(String password) {
    state = state.copyWith(
      confirmPassword: password,
      confirmPasswordError: null,
      isSuccess: false,
    );
  }

  void setResetSuccess() {
    state = state.copyWith(
      isSuccess: false,
    );
  }

  void validateOldPassword() {
    final String? error = AppValidation.validateRequired(
      state.oldPassword,
      fieldName: AppStrings.changePasswordOld,
    );
    state = state.copyWith(oldPasswordError: error);
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

  Future<void> changePassword() async {
    // Validate all fields
    validateOldPassword();
    validateNewPassword();
    validateConfirmPassword();

    if (!state.isValid) {
      return;
    }

    try {
      state = state.copyWith(
        isSubmitting: true,
      );
      final ChangePasswordResponseModel response = await _apiClient
          .handleRequest<ChangePasswordResponseModel>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.changePassword,
            data: <String, String>{
              "currentPassword": state.oldPassword,
              "password": state.newPassword,
              "confirmPassword": state.confirmPassword,
            },
            fromJson: ChangePasswordResponseModel.fromJson,
          );
      if ((response.data?.accessToken != null &&
              response.data!.accessToken.isNotEmpty) &&
          response.data?.refreshToken != null &&
          response.data!.refreshToken.isNotEmpty) {
        ref
            .read(authProvider.notifier)
            .changePassword(
              response.data!.accessToken,
              response.data!.refreshToken,
            );
        Toast.showSuccess(response.message);
        state = state.copyWith(isSubmitting: false, isSuccess: true);
      } else {
        Toast.showError("Something went wrong!! Try again");
        state = state.copyWith(isSubmitting: false, isSuccess: false);
      }
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      state = state.copyWith(isSubmitting: false, isSuccess: false);
    }
  }
}
