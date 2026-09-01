import 'dart:io';

import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/router/app_router.dart';
import '../../../app/toast/toast.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/enums/gender.dart';
import '../../../shared/models/user_model.dart';
import '../model/profile_update_response.dart';
import '../model/rider_profile_response.dart';
import '../state/rider_profile_state.dart';

class RiderProfileNotifier extends AutoDisposeNotifier<RiderProfileState> {
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;

  @override
  RiderProfileState build() {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);

    Future<dynamic>.microtask(() => _fetchProfile());
    return RiderProfileState.initial;
  }

  Future<void> _fetchProfile() async {
    state = state.copyWith(
      profileValue: const AsyncLoading<User>(),
      error: null,
    );

    try {
      final RiderProfileResponse response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.get,
        endpoint: ApiEndpoints.riderProfile,
        fromJson: RiderProfileResponse.fromJson,
      );

      state = state.copyWith(profileValue: AsyncData<User>(response.data));
      setName(response.data.fullName);
      setPhone(response.data.phoneNumber ?? '');
      setLocation(response.data.address.address);
      final Gender? gender = Gender.fromString(response.data.profile?.gender);
      if (gender != null) {
        setGender(gender);
      }
    } catch (e) {
      AppLogger().e(e.toString(), error: e);
      state = state.copyWith(
        profileValue: AsyncError<User>(e, StackTrace.current),
        error: 'Failed to load profile',
      );
    }
  }

  void refreshProfile() => _fetchProfile();

  // ===== Form field setters (with error clearing) =====
  void setName(String value) => state = state.copyWith(
    name: value,
    nameError: null,
    error: null,
  );

  void setPhone(String value) => state = state.copyWith(
    phone: value,
    phoneError: null,
    error: null,
  );

  void setLocation(String value) => state = state.copyWith(
    location: value,
    locationError: null,
    error: null,
  );

  // void setAge(int value) => state = state.copyWith(
  //   age: value,
  //   ageError: null,
  //   error: null,
  // );

  void setGender(Gender value) => state = state.copyWith(
    gender: value,
    error: null,
  );

  void setProfileImage(File? value) => state = state.copyWith(
    profileImage: value,
    error: null,
  );

  // ===== Validation =====
  void validateName() => state = state.copyWith(
    nameError: state.name.isEmpty ? 'Name is required' : null,
  );

  void validatePhone() => state = state.copyWith(
    phoneError: state.phone.isEmpty ? 'Phone is required' : null,
  );

  void validateLocation() => state = state.copyWith(
    locationError: state.location.isEmpty ? 'Location is required' : null,
  );
  void validateGender() => state = state.copyWith(
    error: state.gender == null ? 'Gender is required' : null,
  );

  // void validateAge() {
  //   String? error;
  //   if (state.age <= 0) {
  //     error = 'Age must be greater than 0';
  //   } else if (state.age > 120) {
  //     error = 'Please enter a valid age';
  //   }
  //   state = state.copyWith(ageError: error);
  // }

  // ===== Save profile =====
  Future<void> saveProfile() async {
    validateName();
    validatePhone();
    validateLocation();
    validateGender();

    if (!state.isValid) {
      return;
    }

    try {
      state = state.copyWith(isSubmitting: true, error: null);

      final ProfileUpdateResponse response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.patch,
        endpoint: ApiEndpoints.riderProfile,
        fromJson: ProfileUpdateResponse.fromJson,
        data: <String, Object?>{
          "fullName": state.name,
          "phoneNumber": state.phone,
          "address": state.location,
          "gender": state.gender?.name,
        },
      );
      state = state.copyWith(profileValue: AsyncData<User>(response.data));
      Toast.showSuccess(response.message);
      _appRouter.pop();
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(
        error: null,
        isSubmitting: false,
      );
    }
  }

  Future<void> saveProfilePicture() async {
    if (state.profileImage == null) {
      return;
    }

    try {
      state = state.copyWith(isProfileSubmitting: true, error: null);
      final Map<String, dynamic> response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.patch,
        endpoint: ApiEndpoints.riderProfilePicture,
        fileFields: <String, List<File>>{
          "profilePicture": <File>[state.profileImage!],
        },
      );
      final User? user = state.profileValue.value?.copyWith(
        profilePicture: AppConstants.resolveMediaUrl(
          (response['data'] as Map<String, dynamic>)['profilePicture'],
        ),
      );
      if (user != null) {
        state = state.copyWith(profileValue: AsyncData<User>(user));
      }
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(
        isProfileSubmitting: false,
      );
    }
  }
}
