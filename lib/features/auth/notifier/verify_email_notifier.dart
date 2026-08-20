import 'dart:async';

import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/router/app_router.dart';
import '../../../app/router/route_paths.dart';
import '../../../app/toast/toast.dart';
import '../../../shared/enums/rider_verify_identity_from_type.dart';
import '../../../shared/enums/role.dart';
import '../../../shared/enums/verify_email_type.dart';
import '../models/resend_otp_response_model.dart';
import '../models/verify_email_response_model.dart';
import '../models/verify_reset_email_response_model.dart';
import '../providers/auth_providers.dart';
import '../state/verify_email_state.dart';

class VerifyEmailNotifier extends AutoDisposeNotifier<VerifyEmailState> {
  Timer? _timer;
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;
  @override
  VerifyEmailState build() {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);
    return VerifyEmailState();
  }

  /// Initialize email and type, then start countdown
  void initialize(String email, VerifyEmailType type) {
    state = VerifyEmailState(email: email, type: type);
    startTimer();
  }

  /// Set digit at [index] and auto-focus next field if needed
  void setCodeAndMove(int index, String value) {
    if (value.length > 1) {
      return;
    }

    final List<String> newCode = List<String>.from(state.code);

    newCode[index] = value;
    state = state.copyWith(code: newCode);

    // Move focus to next field if digit entered and not last
    if (value.isNotEmpty && index < 5) {
      state.focusNodes[index + 1].requestFocus();
    }
  }

  /// Handle backspace: move to previous field and clear it
  void handleBackspace(int index) {
    if (index > 0) {
      // Clear current and move to previous
      final List<String> newCode = List<String>.from(state.code);
      newCode[index] = '';
      // newCode[index - 1] = '';
      state = state.copyWith(code: newCode);
      state.focusNodes[index - 1].requestFocus();
    } else {
      // First field: just clear
      final List<String> newCode = List<String>.from(state.code);
      newCode[0] = '';
      state = state.copyWith(code: newCode);
    }
  }

  /// Start 30-second resend cool down timer
  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(resendTimer: state.resendTimer, canResend: false);
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (state.resendTimer <= 1) {
        timer.cancel();
        state = state.copyWith(resendTimer: 0, canResend: true);
      } else {
        state = state.copyWith(resendTimer: state.resendTimer - 1);
      }
    });
  }

  /// Verify the entered code
  Future<void> handleVerify() async {
    if (!state.isValidCode) {
      state = state.copyWith(error: 'Please enter a 6-digit code');
      Toast.showError('Please enter a 6-digit code');
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final String enteredCode = state.code.join();
      if (enteredCode.length == 6) {
        if (state.type == VerifyEmailType.forgotPassword) {
          final VerifyResetEmailResponseModel response = await _apiClient
              .handleRequest<VerifyResetEmailResponseModel>(
                httpMethod: HttpMethod.post,
                endpoint: ApiEndpoints.verifyResetOtp,
                data: <String, String>{
                  "otp": enteredCode,
                  "email": state.email,
                },
                fromJson: VerifyResetEmailResponseModel.fromJson,
              );
          if (response.data != null &&
              response.data!.resetPasswordToken.isNotEmpty) {
            await ref
                .read(authProvider.notifier)
                .resetPassword(response.data!.resetPasswordToken);
            _appRouter.go(
              RoutePaths.resetPassword,
              extra: response.data!.resetPasswordToken,
            );
          } else {
            Toast.showError('Something went wrong!');
          }
        } else {
          final VerifyEmailResponseModel response = await _apiClient
              .handleRequest<VerifyEmailResponseModel>(
                httpMethod: HttpMethod.post,
                endpoint: ApiEndpoints.verifyOtp,
                data: <String, String>{
                  "otp": enteredCode,
                  "email": state.email,
                },
                fromJson: VerifyEmailResponseModel.fromJson,
              );

          if (response.data != null && response.data!.accessToken.isNotEmpty) {
            final Role? role = Role.fromString(response.data!.user.authRole);
            if (role != null) {
              await ref
                  .read(authProvider.notifier)
                  .access(
                    response.data!.accessToken,
                    response.data!.refreshToken,
                    role,
                  );
              switch (role) {
                case Role.user:
                  _appRouter.go(
                    RoutePaths.userAddressAdd,
                    extra: true,
                  );
                  break;
                case Role.rider:
                  _appRouter.pushReplacement(
                    RoutePaths.verifyRiderHome,
                    extra: RiderVerifyIdentityFromType.verify,
                  );
                  break;
                case Role.provider:
                  _appRouter.go(
                    RoutePaths.provider,
                  );
                  break;
              }
            } else {
              Toast.showError("Role is not identify.");
            }
          }
        }
      } else {
        state = state.copyWith(
          isSubmitting: false,
          error: 'Invalid code',
        );
        Toast.showError('Invalid code');
      }
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Something went wrong!',
      );
      AppLogger().e(e.toString());
      Toast.showError(ExceptionHandler.errorMessage(e));
    }
  }

  /// Resend verification code
  Future<void> handleResend() async {
    if (!state.canResend || state.isSubmitting) {
      return;
    }

    state = state.copyWith(isSubmitting: true);

    try {
      await _apiClient.handleRequest<ResendOtpResponseModel>(
        httpMethod: HttpMethod.post,
        endpoint: state.type == VerifyEmailType.verifyEmail
            ? ApiEndpoints.resendOtp
            : ApiEndpoints.forgotPassword,
        data: <String, String>{"email": state.email},
        fromJson: ResendOtpResponseModel.fromJson,
      );
      startTimer();
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
