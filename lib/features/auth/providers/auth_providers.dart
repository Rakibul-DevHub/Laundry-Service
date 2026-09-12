import 'dart:async';

import 'package:drop_n_fresh/core/storage/secure_storage_service.dart';
import 'package:drop_n_fresh/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/jwt_utils.dart';
import '../../../shared/enums/role.dart';
import '../notifier/change_password_notifier.dart';
import '../notifier/delete_account_notifier.dart';
import '../notifier/reset_password_notifier.dart';
import '../notifier/sign_in_notifier.dart';
import '../notifier/sign_up_notifier.dart';
import '../notifier/verify_email_notifier.dart';
import '../state/change_password_state.dart';
import '../state/delete_account_state.dart';
import '../state/reset_password_state.dart';
import '../state/sign_in_state.dart';
import '../state/sign_up_state.dart';
import '../state/verify_email_state.dart';

part '../state/auth_state.dart';
part '../notifier/auth_notifier.dart';

final StateNotifierProvider<AuthNotifier, AuthState> authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((
      // ignore: deprecated_member_use
      StateNotifierProviderRef<AuthNotifier, AuthState> ref,
    ) {
      return AuthNotifier(ref);
    });

// sign in provider
final AutoDisposeNotifierProvider<SignInNotifier, SignInState> signInProvider =
    NotifierProvider.autoDispose<SignInNotifier, SignInState>(
      () => SignInNotifier(),
    );

// verify email provider
final AutoDisposeNotifierProvider<VerifyEmailNotifier, VerifyEmailState>
verifyEmailProvider =
    NotifierProvider.autoDispose<VerifyEmailNotifier, VerifyEmailState>(
      () => VerifyEmailNotifier(),
    );

// sign up provider
final AutoDisposeNotifierProviderFamily<SignUpNotifier, SignUpState, Role>
signUpProvider = NotifierProvider.autoDispose
    .family<SignUpNotifier, SignUpState, Role>(
      SignUpNotifier.new,
    );

// reset password provider
final AutoDisposeNotifierProvider<ResetPasswordNotifier, ResetPasswordState>
resetPasswordProvider =
    AutoDisposeNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
      ResetPasswordNotifier.new,
    );

// change password provider
final AutoDisposeNotifierProvider<ChangePasswordNotifier, ChangePasswordState>
changePasswordProvider =
    AutoDisposeNotifierProvider<ChangePasswordNotifier, ChangePasswordState>(
      ChangePasswordNotifier.new,
    );

// delete account provider
final AutoDisposeNotifierProvider<DeleteAccountNotifier, DeleteAccountState>
deleteAccountProvider =
    AutoDisposeNotifierProvider<DeleteAccountNotifier, DeleteAccountState>(
      DeleteAccountNotifier.new,
    );
