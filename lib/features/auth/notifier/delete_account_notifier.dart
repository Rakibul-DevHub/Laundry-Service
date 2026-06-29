import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/router/app_router.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/utils/app_validation.dart';
import '../providers/auth_providers.dart';
import '../state/delete_account_state.dart';

class DeleteAccountNotifier extends AutoDisposeNotifier<DeleteAccountState> {
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;
  @override
  DeleteAccountState build() {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);
    return const DeleteAccountState(isWarningScreen: true);
  }

  void setPassword(String password) {
    state = state.copyWith(
      password: password,
      passwordError: null,
      isSuccess: false,
    );
  }

  void changeWarningScreenState(bool value) {
    state = state.copyWith(
      isWarningScreen: value,
    );
  }

  void validatePassword() {
    final String? error = AppValidation.validatePassword(state.password);
    state = state.copyWith(passwordError: error);
  }

  Future<void> deleteAccount() async {
    validatePassword();

    if (!state.isValid) {
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
    );

    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.delete,
        endpoint: ApiEndpoints.account,
        data: <String, String>{"password": state.password},
      );
      state = state.copyWith(isSubmitting: false, isSuccess: true);
      await ref.read(authProvider.notifier).logout();
      await Future<dynamic>.delayed(const Duration(milliseconds: 500));
      _appRouter.go(RoutePaths.signIn);
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      state = state.copyWith(isSubmitting: false, isSuccess: false);
    }
  }
}
