import 'package:drop_n_fresh/core/extensions/date_time_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/router/app_router.dart';
import '../../../app/router/route_paths.dart';
import '../../../app/toast/toast.dart';
import '../../../core/utils/app_validation.dart';
import '../../../shared/enums/role.dart';
import '../../../shared/enums/verify_email_type.dart';
import '../models/register_response_model.dart';
import '../state/sign_up_state.dart';

class SignUpNotifier extends AutoDisposeFamilyNotifier<SignUpState, Role> {
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;
  @override
  SignUpState build(Role role) {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);
    return SignUpState(role: role);
  }

  // === COMMON FIELDS ===
  void setEmail(String email) {
    state = state.copyWith(email: email, emailError: null);
  }

  void emailValidate() {
    final String? error = AppValidation.validateEmail(state.email);
    state = state.copyWith(emailError: error);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, passwordError: null);
  }

  void passwordValidate() {
    final String? error = AppValidation.validatePassword(state.password);
    state = state.copyWith(passwordError: error);
  }

  // === USER FIELDS ===
  void setUserFirstName(String name) {
    state = state.copyWith(userFirstName: name, userFirstNameError: null);
  }

  void userFirstNameValidate() {
    final String? error =
        state.userFirstName.trim().isEmpty ? 'First name is required' : null;
    state = state.copyWith(userFirstNameError: error);
  }

  void setUserLastName(String name) {
    state = state.copyWith(userLastName: name, userLastNameError: null);
  }

  void userLastNameValidate() {
    final String? error =
        state.userLastName.trim().isEmpty ? 'Last name is required' : null;
    state = state.copyWith(userLastNameError: error);
  }

  void setUserPhone(String phone) {
    state = state.copyWith(userPhone: phone, userPhoneError: null);
  }

  void userPhoneValidate() {
    final String? error = state.userPhone.isEmpty ? 'Phone is required' : null;
    state = state.copyWith(userPhoneError: error);
  }

  void setUserLocation(String loc) {
    state = state.copyWith(userLocation: loc, userLocationError: null);
  }

  void userLocationValidate() {
    final String? error = state.userLocation.isEmpty
        ? 'Location is required'
        : null;
    state = state.copyWith(userLocationError: error);
  }

  void setUserDateOfBirth(DateTime? dob) {
    state = state.copyWith(userDateOfBirth: dob);
  }

  void setUserGender(String gender) {
    state = state.copyWith(userGender: gender);
  }

  // === RIDER FIELDS ===
  void setRiderName(String name) {
    state = state.copyWith(riderName: name, riderNameError: null);
  }

  void riderNameValidate() {
    final String? error = state.riderName.isEmpty ? 'Name is required' : null;
    state = state.copyWith(riderNameError: error);
  }

  void setRiderPhone(String phone) {
    state = state.copyWith(riderPhone: phone, riderPhoneError: null);
  }

  void riderPhoneValidate() {
    final String? error = state.riderPhone.isEmpty ? 'Phone is required' : null;
    state = state.copyWith(riderPhoneError: error);
  }

  void setRiderLocation(String loc) {
    state = state.copyWith(riderLocation: loc, riderLocationError: null);
  }

  void riderLocationValidate() {
    final String? error = state.riderLocation.isEmpty
        ? 'Location is required'
        : null;
    state = state.copyWith(riderLocationError: error);
  }

  void setRiderDateOfBirth(DateTime? dob) {
    state = state.copyWith(riderDateOfBirth: dob);
  }

  void setRiderGender(String gender) {
    state = state.copyWith(riderGender: gender);
  }

  // === PROVIDER FIELDS ===
  void setBusinessName(String name) {
    state = state.copyWith(businessName: name, businessNameError: null);
  }

  void businessNameValidate() {
    final String? error = state.businessName.isEmpty
        ? 'Business name is required'
        : null;
    state = state.copyWith(businessNameError: error);
  }

  void setOwnerName(String name) {
    state = state.copyWith(ownerName: name, ownerNameError: null);
  }

  void ownerNameValidate() {
    final String? error = state.ownerName.isEmpty
        ? 'Owner name is required'
        : null;
    state = state.copyWith(ownerNameError: error);
  }

  void setTaxId(String id) {
    state = state.copyWith(taxId: id, taxIdError: null);
  }

  void taxIdValidate() {
    final String? error = state.taxId.isEmpty ? 'Tax ID is required' : null;
    state = state.copyWith(taxIdError: error);
  }

  void setProviderPhone(String phone) {
    state = state.copyWith(providerPhone: phone, providerPhoneError: null);
  }

  void providerPhoneValidate() {
    final String? error = state.providerPhone.isEmpty
        ? 'Phone is required'
        : null;
    state = state.copyWith(providerPhoneError: error);
  }

  void setProviderLocation(String loc) {
    state = state.copyWith(providerLocation: loc, providerLocationError: null);
  }

  void providerLocationValidate() {
    final String? error = state.providerLocation.isEmpty
        ? 'Location is required'
        : null;
    state = state.copyWith(providerLocationError: error);
  }

  // === SIGN UP ===
  Future<void> handleSignUp() async {
    // Validate all fields based on role
    switch (state.role) {
      case Role.user:
        userFirstNameValidate();
        userLastNameValidate();
        userPhoneValidate();
        emailValidate();
        userLocationValidate();
        passwordValidate();
      case Role.rider:
        emailValidate();
        passwordValidate();
        riderNameValidate();
        riderPhoneValidate();
        riderLocationValidate();
      case Role.provider:
        emailValidate();
        passwordValidate();
        businessNameValidate();
        ownerNameValidate();
        taxIdValidate();
        providerPhoneValidate();
        providerLocationValidate();
    }

    if (!state.isValid) {
      return;
    }

    state = state.copyWith(isSubmitting: true);
    try {
      final Map<String, Object?> data = <String, Object?>{};

      switch (state.role) {
        case Role.user:
          data.addAll(<String, Object?>{
            "firstName": state.userFirstName.trim(),
            "lastName": state.userLastName.trim(),
            "fullName": state.userFullName,
            "phoneNumber": state.userPhone,
            "email": state.email,
            "password": state.password,
            "address": state.userLocation,
            "dateOfBirth": state.userDateOfBirth?.formattedDate,
            "acceptTerms": true, // Required
            "role": "user",
          });
          break;
        case Role.rider:
          data.addAll(<String, Object?>{
            "fullName": state.riderName,
            "phoneNumber": state.riderPhone,
            "email": state.email,
            "password": state.password,
            "address": state.riderLocation,
            "gender": state.riderGender?.toLowerCase(),
            "dateOfBirth": state.riderDateOfBirth?.formattedDate,
            "acceptTerms": true, // Required
            "authRole": "rider",
          });
          break;
        case Role.provider:
          data.addAll(<String, Object?>{
            "businessInfo": <String, String>{
              "businessName": state.businessName,
              "ownerName": state.ownerName,
              "taxId": state.taxId,
            },
            "phoneNumber": state.providerPhone,
            "email": state.email,
            "address": state.providerLocation,
            "password": state.password,
            "acceptTerms": true, // Required
            "authRole": "provider",
          });
          break;
      }

      await _apiClient.handleRequest<RegistrationResponseModel>(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.register,
        data: data,
        fromJson: RegistrationResponseModel.fromJson,
      );

      /// backend server do not taking or givin the verification anymore
      // if (response.data?.verificationToken != null &&
      //     response.data!.verificationToken.isNotEmpty) {
      // await ref
      //     .read(authProvider.notifier)
      //     .registerToken(response.data!.verificationToken);
      _appRouter.pushReplacement(
        "${RoutePaths.verifyEmail}/${state.email}",
        extra: VerifyEmailType.verifyEmail,
      );
      // } else {
      //   Toast.showError('Something went wrong!');
      // }
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
