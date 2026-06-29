import 'package:flutter/foundation.dart';
import '../../../shared/enums/gender.dart';
import '../model/profile_model.dart';

@immutable
class ProfileState {
  // Existing fields from your view screen
  final ProfileModel? profile;
  final bool isLoading;
  final String? error;

  // Editable fields with validation (for edit screen only)
  final String name;
  final String? nameError;
  final String phone;
  final String? phoneError;
  final String location;
  final String? locationError;
  final int age;
  final String? ageError;
  final Gender gender;
  final String? profileImageUrl;

  final bool isSubmitting;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.name = '',
    this.nameError,
    this.phone = '',
    this.phoneError,
    this.location = '',
    this.locationError,
    this.age = 0,
    this.ageError,
    this.gender = Gender.male,
    this.profileImageUrl,
    this.isSubmitting = false,
  });

  // Factory to initialize edit state from profile model
  factory ProfileState.fromProfile(ProfileModel profile) {
    return ProfileState(
      profile: profile,
      name: profile.name,
      phone: profile.phone,
      location: profile.location,
      age: profile.age,
      gender: profile.gender,
      profileImageUrl: profile.profile,
    );
  }

  bool get isValid =>
      nameError == null &&
      phoneError == null &&
      locationError == null &&
      ageError == null &&
      name.isNotEmpty &&
      phone.isNotEmpty &&
      location.isNotEmpty &&
      age > 0;

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isLoading,
    String? error,
    String? name,
    String? nameError,
    String? phone,
    String? phoneError,
    String? location,
    String? locationError,
    int? age,
    String? ageError,
    Gender? gender,
    String? profileImageUrl,
    bool? isSubmitting,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      name: name ?? this.name,
      nameError: nameError,
      phone: phone ?? this.phone,
      phoneError: phoneError,
      location: location ?? this.location,
      locationError: locationError,
      age: age ?? this.age,
      ageError: ageError,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
