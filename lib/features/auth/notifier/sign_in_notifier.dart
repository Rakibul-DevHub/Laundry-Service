import 'package:drop_n_fresh/app/api/exceptions/exceptions.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/shared/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/router/app_router.dart';
import '../../../app/router/route_paths.dart';
import '../../../app/toast/toast.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/app_validation.dart';
import '../../../shared/enums/rider_verify_identity_from_type.dart';
import '../../../shared/enums/role.dart';
import '../../../shared/enums/verify_email_type.dart';
import '../models/sign_in_response_model.dart';
import '../providers/auth_providers.dart';
import '../state/sign_in_state.dart';

class SignInNotifier extends AutoDisposeNotifier<SignInState> {
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;
  @override
  SignInState build() {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);
    return const SignInState();
  }

  void setEmail(String email) {
    state = state.copyWith(
      email: email,
      emailError: null,
    );
  }

  void emailValidate() {
    final String? error = AppValidation.validateEmail(state.email);
    state = state.copyWith(emailError: error);
  }

  void setPassword(String password) {
    state = state.copyWith(
      password: password,
      passwordError: null,
    );

    AppLogger().e("setPassword : ${state.toString()}");
  }

  void passwordValidate() {
    final String? error = AppValidation.validatePassword(state.password);
    state = state.copyWith(passwordError: error);
    AppLogger().e("passwordValidate : ${state.toString()}");
  }

  Future<void> handleSignIn() async {
    final String? emailError = AppValidation.validateEmail(state.email);
    final String? passwordError = AppValidation.validatePassword(
      state.password,
    );

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );

    if (emailError != null || passwordError != null) {
      return;
    }

    state = state.copyWith(isSubmitting: true);

    try {
      if (state.email.isNotEmpty && state.password.isNotEmpty) {
        state = state.copyWith(
          isSubmitting: true,
          emailError: null,
          passwordError: null,
        );
        final SignInResponseModel response = await _apiClient
            .handleRequest<SignInResponseModel>(
              httpMethod: HttpMethod.post,
              endpoint: ApiEndpoints.login,
              data: <String, String>{
                "email": state.email,
                "password": state.password,
              },
              fromJson: SignInResponseModel.fromJson,
            );

        if (response.data != null && response.data!.accessToken.isNotEmpty) {
          if (response.data!.user.verification?.email.verified == false) {
            _appRouter.pushReplacement(
              "${RoutePaths.verifyEmail}/${response.data!.user.email}",
              extra: VerifyEmailType.verifyEmail,
            );
            Toast.showWarning(response.message);
          } else {
            final Role? role = Role.fromString(response.data!.user.authRole);
            if (role != null) {
              await ref
                  .read(authProvider.notifier)
                  .loginToken(
                    response.data!.accessToken,
                    response.data!.refreshToken,
                    role,
                  );
              switch (role) {
                case Role.user:
                  _appRouter.go(
                    RoutePaths.user,
                  );
                  break;
                case Role.rider:
                  final RiderVerification? documents =
                      response.data!.user.riderVerification;

                  if (documents != null &&
                      (documents.nid != null &&
                          documents.drivingLicense != null &&
                          documents.insurance != null &&
                          documents.vehicle != null &&
                          documents.selfie != null)) {
                    if ((documents.verificationStatus == "unverified")) {
                      _appRouter.pushReplacement(
                        RoutePaths.verifyRiderHome,
                        extra: RiderVerifyIdentityFromType.verify,
                      );
                    } else {
                      await ref
                          .read(authProvider.notifier)
                          .riderDocumentsSubmit();
                      _appRouter.go(
                        RoutePaths.rider,
                      );
                    }
                  } else {
                    _appRouter.pushReplacement(
                      RoutePaths.verifyRiderHome,
                      extra: RiderVerifyIdentityFromType.verify,
                    );
                  }
                case Role.provider:
                  _appRouter.go(
                    RoutePaths.provider,
                  );
                  break;
              }
            } else {
              Toast.showError("Role is not identify");
            }
          }
        } else {
          Toast.showError("Something is wrong! Try again");
        }
      } else {
        Toast.showWarning("Email or password empty!");
      }
    } on UnauthorizedException catch (exception) {
      Toast.showError(exception.message);
    } on ForbiddenException catch (exception) {
      if (exception.response is Map<String, dynamic>) {
        if (((exception.response
                    as Map<String, dynamic>)['canResendVerification']
                as bool?) ==
            true) {
          Toast.showWarning(exception.message);
          _appRouter.pushReplacement(
            "${RoutePaths.verifyEmail}/${((exception.response as Map<String, dynamic>)['email'] as String)}",
            extra: VerifyEmailType.verifyEmail,
          );
        } else {
          Toast.showError(exception.message);
        }
      } else {
        Toast.showError(exception.message);
      }
    } catch (e) {
      Toast.showError('Something went wrong');
      AppLogger().e(ExceptionHandler.errorMessage(e), error: e);
    } finally {
      state = state.copyWith(
        isSubmitting: false,
        // error: 'Something went wrong',
      );
    }
  }

  Future<void> handleForgotPassword() async {
    try {
      final String? validation = AppValidation.validateEmail(state.email);
      if (validation != null) {
        state = state.copyWith(
          emailError: validation,
          // error: validation,
          isForgotPopupOpen: false,
        );
      } else {
        state = state.copyWith(
          emailError: null,
          // error: null,
          isForgotPopupOpen: true,
        );
      }
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      AppLogger().e(ExceptionHandler.errorMessage(e), error: e);
    }
  }

  Future<void> handleSendOtp() async {
    try {
      state = state.copyWith(
        isSendOtpSubmitting: true,
        isForgotPopupOpen: false,
      );

      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.forgotPassword,
        data: <String, String>{"email": state.email},
      );
      _appRouter.pushReplacement(
        "${RoutePaths.verifyEmail}/${state.email}",
        extra: VerifyEmailType.forgotPassword,
      );
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      AppLogger().e(ExceptionHandler.errorMessage(e), error: e);
    } finally {
      state = state.copyWith(
        isSendOtpSubmitting: false,
        isForgotPopupOpen: false,
      );
    }
  }

  Future<void> handleResetForgotPopup() async {
    state = state.copyWith(
      isForgotPopupOpen: false,
      isSendOtpSubmitting: false,
    );
  }

  Future<void> handleGoogleSignIn() async {
    Toast.showInfo("Coming soon");
  }

  Future<void> handleAppleSignIn() async {
    Toast.showInfo("Coming soon");
  }
}
