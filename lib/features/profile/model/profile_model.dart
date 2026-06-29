import 'dart:io';

import '../../../core/config/images.dart';
import '../../../shared/enums/gender.dart';

class ProfileModel {
  final File? profileImage;
  final String? profile;
  final String name;
  final String email;
  final String phone;
  final String location;
  final int age;
  final Gender gender;

  const ProfileModel({
    this.profileImage,
    this.profile,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.age,
    required this.gender,
  });

  static const ProfileModel demoProfile = ProfileModel(
    profile: AppImages.demoProfile,
    name: "Mani",
    email: "mani@gmail.com",
    phone: "7823238872",
    location: "Dhaka, Bangladesh",
    age: 20,
    gender: Gender.male,
  );
}
