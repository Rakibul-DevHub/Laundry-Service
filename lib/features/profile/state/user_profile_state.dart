import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/enums/gender.dart';
import '../../../shared/models/user_model.dart';

@immutable
class UserProfileState {
  final AsyncValue<User> profileValue;
  final bool isSubmitting;
  final bool isProfileSubmitting;
  final String? error;

  // Form fields (mirroring profile but mutable during edit)
  final String name;
  final String phone;
  final String location;
  final Gender? gender;
  final File? profileImage;

  // Validation errors
  final String? nameError;
  final String? phoneError;
  final String? locationError;
  final String? ageError;

  const UserProfileState({
    required this.profileValue,
    this.isSubmitting = false,
    this.isProfileSubmitting = false,
    this.error,
    this.name = '',
    this.phone = '',
    this.location = '',
    this.gender,
    this.profileImage,
    this.nameError,
    this.phoneError,
    this.locationError,
    this.ageError,
  });

  bool get isValid =>
      nameError == null &&
      phoneError == null &&
      locationError == null &&
      name.isNotEmpty &&
      phone.isNotEmpty &&
      location.isNotEmpty;

  UserProfileState copyWith({
    AsyncValue<User>? profileValue,
    bool? isSubmitting,
    bool? isProfileSubmitting,
    String? error,
    String? name,
    String? phone,
    String? location,
    Gender? gender,
    File? profileImage,
    String? nameError,
    String? phoneError,
    String? locationError,
    String? ageError,
  }) {
    return UserProfileState(
      profileValue: profileValue ?? this.profileValue,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isProfileSubmitting: isProfileSubmitting ?? this.isProfileSubmitting,
      error: error ?? this.error,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      nameError: nameError ?? this.nameError,
      phoneError: phoneError ?? this.phoneError,
      locationError: locationError ?? this.locationError,
      ageError: ageError ?? this.ageError,
    );
  }

  // Initial loading state
  static const UserProfileState initial = UserProfileState(
    profileValue: AsyncLoading<User>(),
    name: '',
    phone: '',
    location: '',
  );
}
