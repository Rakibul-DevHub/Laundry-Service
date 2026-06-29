import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/profile_state.dart';
import '../model/profile_model.dart';
import '../../../shared/enums/gender.dart';

class ProfileNotifier extends AutoDisposeNotifier<ProfileState> {
  @override
  ProfileState build() {
    Future<dynamic>.microtask(() => _fetchProfile());
    return const ProfileState(isLoading: true);
  }

  Future<void> _fetchProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Your API call here
      // final profile = await apiClient.getProfile();
      // For demo, using mock data
      const ProfileModel mockProfile = ProfileModel.demoProfile;

      state = ProfileState.fromProfile(mockProfile).copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load profile',
        isLoading: false,
      );
    }
  }

  void refreshProfile() => _fetchProfile();

  // Edit methods
  void setName(String name) =>
      state = state.copyWith(name: name, nameError: null, error: null);
  void setPhone(String phone) =>
      state = state.copyWith(phone: phone, phoneError: null, error: null);
  void setLocation(String location) => state = state.copyWith(
    location: location,
    locationError: null,
    error: null,
  );
  void setAge(int age) =>
      state = state.copyWith(age: age, ageError: null, error: null);
  void setGender(Gender gender) =>
      state = state.copyWith(gender: gender, error: null);
  void setProfileImageUrl(String? imageUrl) =>
      state = state.copyWith(profileImageUrl: imageUrl, error: null);

  void validateName() => state = state.copyWith(
    nameError: state.name.isEmpty ? 'Name is required' : null,
  );
  void validatePhone() => state = state.copyWith(
    phoneError: state.phone.isEmpty ? 'Phone is required' : null,
  );
  
  void validateLocation() => state = state.copyWith(
    locationError: state.location.isEmpty ? 'Location is required' : null,
  );

  void validateAge() {
    String? error;
    if (state.age <= 0) {
      error = 'Age must be greater than 0';
    } else if (state.age > 120) {
      error = 'Please enter a valid age';
    }
    state = state.copyWith(ageError: error);
  }

  Future<void> saveProfile() async {
    validateName();
    validatePhone();
    validateLocation();
    // validateAge();

    if (!state.isValid) {
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      // Upload image first if changed
      final String? newImageUrl = state.profileImageUrl;
      if (state.profileImageUrl != state.profile?.profile) {
        // Upload image and get URL
        // newImageUrl = await uploadImage(state.profileImageUrl!);
      }

      // Update profile
      final ProfileModel updatedProfile = ProfileModel(
        profile: newImageUrl,
        name: state.name,
        email: state.profile!.email, // Keep original email
        phone: state.phone,
        location: state.location,
        age: state.age,
        gender: state.gender,
      );

      state = ProfileState.fromProfile(updatedProfile);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update profile',
        isSubmitting: false,
      );
    }
  }
}
