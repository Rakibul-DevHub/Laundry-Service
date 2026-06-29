import 'package:flutter/foundation.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/enums/role.dart';

@immutable
class SignUpState {
  final Role role;

  // Common fields
  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;

  // User-specific
  final String userName;
  final String? userNameError;
  final String userPhone;
  final String? userPhoneError;
  final String userLocation;
  final String? userLocationError;
  final DateTime? userDateOfBirth;
  final String? userGender;

  // Rider-specific
  final String riderName;
  final String? riderNameError;
  final String riderPhone;
  final String? riderPhoneError;
  final String riderLocation;
  final String? riderLocationError;
  final DateTime? riderDateOfBirth;
  final String? riderGender;

  // Provider-specific
  final String businessName;
  final String? businessNameError;
  final String ownerName;
  final String? ownerNameError;
  final String taxId;
  final String? taxIdError;
  final String providerPhone;
  final String? providerPhoneError;
  final String providerLocation;
  final String? providerLocationError;

  final bool isSubmitting;

  const SignUpState({
    this.role = Role.user,
    this.email = '',
    this.emailError,
    this.password = '',
    this.passwordError,
    this.userName = '',
    this.userNameError,
    this.userPhone = '',
    this.userPhoneError,
    this.userLocation = '',
    this.userLocationError,
    this.userDateOfBirth,
    this.userGender,
    this.riderName = '',
    this.riderNameError,
    this.riderPhone = '',
    this.riderPhoneError,
    this.riderLocation = '',
    this.riderLocationError,
    this.riderDateOfBirth,
    this.riderGender,
    this.businessName = '',
    this.businessNameError,
    this.ownerName = '',
    this.ownerNameError,
    this.taxId = '',
    this.taxIdError,
    this.providerPhone = '',
    this.providerPhoneError,
    this.providerLocation = '',
    this.providerLocationError,
    this.isSubmitting = false,
  });

  bool get isValid {
    final bool commonValid = (emailError == null && email.isNotEmpty) && (passwordError == null && password.isNotEmpty);

    // Debug: AppLogger().d common validation status
    AppLogger().d(
      '🔍 [SignUpState] Common valid: $commonValid | Email error: $emailError | Password error: $passwordError',
    );

    switch (role) {
      case Role.user:
        final bool userValid =
            (userNameError == null && userName.isNotEmpty) &&
            (userPhoneError == null && userPhone.isNotEmpty) &&
            (userLocationError == null && userLocation.isNotEmpty) &&
            userDateOfBirth != null &&
            (userGender != null && userGender!.isNotEmpty);

        if (!userValid) {
          AppLogger().d(
            '❌ [SignUpState] User invalid! '
            'NameErr: $userNameError, '
            'Name: $userName, '
            'PhoneErr: $userPhoneError, '
            'Phone: $userPhone, '
            'LocErr: $userLocationError, '
            'Loc: $userLocation, '
            'DOB: $userDateOfBirth, '
            'Gender: $userGender',
          );
        }
        return commonValid && userValid;

      case Role.rider:
        final bool riderValid =
            (riderNameError == null && riderName.isNotEmpty) &&
            (riderPhoneError == null && riderPhone.isNotEmpty) &&
            (riderLocationError == null && riderLocation.isNotEmpty) &&
            riderDateOfBirth != null &&
            (riderGender != null && riderGender!.isNotEmpty);

        if (!riderValid) {
          AppLogger().d(
            '❌ [SignUpState] Rider invalid! '
            'NameErr: $riderNameError, '
            'Name: $riderName, '
            'PhoneErr: $riderPhoneError, '
            'Phone: $riderPhone, '
            'LocErr: $riderLocationError, '
            'Loc: $riderLocation, '
            'DOB: $riderDateOfBirth, '
            'Gender: $riderGender',
          );
        }
        return commonValid && riderValid;

      case Role.provider:
        final bool providerValid =
            (businessNameError == null && businessName.isNotEmpty) &&
            (ownerNameError == null && ownerName.isNotEmpty) &&
            (taxIdError == null && taxId.isNotEmpty) &&
            (providerPhoneError == null && providerPhone.isNotEmpty) &&
            (providerLocationError == null && providerLocation.isNotEmpty);

        if (!providerValid) {
          AppLogger().d(
            '❌ [SignUpState] Provider invalid! '
            'BizErr: $businessNameError, '
            'Biz: $businessName, '
            'OwnerErr: $ownerNameError, '
            'Owner: $ownerName, '
            'TaxErr: $taxIdError, '
            'Tax: $taxId, '
            'PhoneErr: $providerPhoneError, '
            'Phone: $providerPhone, '
            'LocErr: $providerLocationError'
            'Loc: $providerLocation',
          );
        }
        return commonValid && providerValid;
    }
  }

  SignUpState copyWith({
    String? email,
    String? emailError,
    String? password,
    String? passwordError,
    String? userName,
    String? userNameError,
    String? userPhone,
    String? userPhoneError,
    String? userLocation,
    String? userLocationError,
    DateTime? userDateOfBirth,
    String? userGender,
    String? riderName,
    String? riderNameError,
    String? riderPhone,
    String? riderPhoneError,
    String? riderLocation,
    String? riderLocationError,
    DateTime? riderDateOfBirth,
    String? riderGender,
    String? businessName,
    String? businessNameError,
    String? ownerName,
    String? ownerNameError,
    String? taxId,
    String? taxIdError,
    String? providerPhone,
    String? providerPhoneError,
    String? providerLocation,
    String? providerLocationError,
    bool? isSubmitting,
  }) {
    return SignUpState(
      role: role,
      email: email ?? this.email,
      emailError: emailError,
      password: password ?? this.password,
      passwordError: passwordError,
      userName: userName ?? this.userName,
      userNameError: userNameError,
      userPhone: userPhone ?? this.userPhone,
      userPhoneError: userPhoneError,
      userLocation: userLocation ?? this.userLocation,
      userLocationError: userLocationError,
      userDateOfBirth: userDateOfBirth ?? this.userDateOfBirth,
      userGender: userGender ?? this.userGender,
      riderName: riderName ?? this.riderName,
      riderNameError: riderNameError,
      riderPhone: riderPhone ?? this.riderPhone,
      riderPhoneError: riderPhoneError,
      riderLocation: riderLocation ?? this.riderLocation,
      riderLocationError: riderLocationError,
      riderDateOfBirth: riderDateOfBirth ?? this.riderDateOfBirth,
      riderGender: riderGender ?? this.riderGender,
      businessName: businessName ?? this.businessName,
      businessNameError: businessNameError,
      ownerName: ownerName ?? this.ownerName,
      ownerNameError: ownerNameError,
      taxId: taxId ?? this.taxId,
      taxIdError: taxIdError,
      providerPhone: providerPhone ?? this.providerPhone,
      providerPhoneError: providerPhoneError,
      providerLocation: providerLocation ?? this.providerLocation,
      providerLocationError: providerLocationError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  String toString() {
    return 'SignUpState(role: $role, isSubmitting: $isSubmitting)';
  }
}
