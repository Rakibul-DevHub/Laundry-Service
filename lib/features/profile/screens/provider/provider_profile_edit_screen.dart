import 'dart:io';

import 'package:drop_n_fresh/core/utils/image_picker_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/icons.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/profile_providers.dart';
import '../../state/provider_profile_state.dart';

class ProviderProfileEditScreen extends StatelessWidget {
  const ProviderProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("RIDER PROFILE EDIT SCREEN BUILD");

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Edit Profile",
        showBackBtn: true,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? widget) {
                        final File? imageFile = ref.watch(
                          providerProfileProvider.select(
                            (ProviderProfileState state) => state.profileImage,
                          ),
                        );
                        final bool isProfileSubmitting = ref.watch(
                          providerProfileProvider.select(
                            (ProviderProfileState state) =>
                                state.isProfileSubmitting,
                          ),
                        );
                        final AsyncValue<User> profile = ref.watch(
                          providerProfileProvider.select(
                            (ProviderProfileState state) => state.profileValue,
                          ),
                        );
                        return Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: AssetLoader(
                                assetPath:
                                    imageFile ?? profile.value?.profilePicture,
                                shape: BoxShape.rectangle,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: -12,
                              right: 35,
                              child: GestureDetector(
                                onTap: () => isProfileSubmitting
                                    ? () {}
                                    : _pickImage(context, ref),
                                child: isProfileSubmitting
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : const AssetLoader(
                                        assetPath: AppIcons.camera,
                                        width: 32,
                                        height: 32,
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                ),
                const SizedBox(height: AppSizes.spaceBetweenSections),

                // Name
                const _ProfileNameField(),
                const SizedBox(height: AppSizes.spaceBetweenItems),

                // Phone
                const _ProfilePhoneField(),
                const SizedBox(height: AppSizes.spaceBetweenItems),

                // Location
                const _ProfileLocationField(),
                const SizedBox(height: AppSizes.spaceBetweenItems),

                // // Age
                // const ProfileAgeField(),
                // const SizedBox(height: AppSizes.spaceBetweenItems),

                // Gender
                // const _ProfileGenderField(),
                // const SizedBox(height: AppSizes.spaceBetweenSections),
                const _ProfileSaveButton(),
                const SizedBox(height: AppSizes.spaceBetweenSections),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickImage(BuildContext context, WidgetRef ref) async {
    final File? file = await ImagePickerUtils.pickImageFile();
    if (file != null) {
      ref.read(providerProfileProvider.notifier).setProfileImage(file);
      ref.read(providerProfileProvider.notifier).saveProfilePicture();
    }
  }
}

class _ProfileSaveButton extends ConsumerWidget {
  const _ProfileSaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isValid = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.isValid,
      ),
    );
    final bool isSubmitting = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.isSubmitting,
      ),
    );
    final bool isProfileSubmitting = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.isProfileSubmitting,
      ),
    );
    final bool canSave =
        isValid && !isSubmitting && !isProfileSubmitting;

    return AppElevatedButton(
      onPressed: canSave
          ? () => ref.read(providerProfileProvider.notifier).saveProfile()
          : null,
      isEnabled: canSave,
      isLoading: isSubmitting,
      label: 'Save',
    );
  }
}

class _ProfileNameField extends ConsumerWidget {
  const _ProfileNameField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String name = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.name,
      ),
    );
    final String? error = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.nameError,
      ),
    );

    return AppTextField(
      initialValue: name,
      onChanged: (String v) =>
          ref.read(providerProfileProvider.notifier).setName(v),
      errorText: error,
      onEditingComplete: () =>
          ref.read(providerProfileProvider.notifier).validateName(),
      onUnfocus: () =>
          ref.read(providerProfileProvider.notifier).validateName(),
      labelText: 'Name',
    );
  }
}

class _ProfilePhoneField extends ConsumerWidget {
  const _ProfilePhoneField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String phone = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.phone,
      ),
    );
    final String? error = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.phoneError,
      ),
    );

    return AppTextField(
      labelText: "Phone",
      errorText: error,
      initialValue: phone,
      onChanged: (String v) =>
          ref.read(providerProfileProvider.notifier).setPhone(v),
      onEditingComplete: () =>
          ref.read(providerProfileProvider.notifier).validatePhone(),
      onUnfocus: () =>
          ref.read(providerProfileProvider.notifier).validatePhone(),
    );
  }
}

class _ProfileLocationField extends ConsumerWidget {
  const _ProfileLocationField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.location,
      ),
    );
    final String? error = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState state) => state.locationError,
      ),
    );

    return AppTextField(
      errorText: error,
      labelText: "Location",
      initialValue: location,
      onChanged: (String v) =>
          ref.read(providerProfileProvider.notifier).setLocation(v),
      onEditingComplete: () =>
          ref.read(providerProfileProvider.notifier).validateLocation(),
      onUnfocus: () =>
          ref.read(providerProfileProvider.notifier).validateLocation(),
    );
  }
}

// class _ProfileGenderField extends ConsumerWidget {
//   const _ProfileGenderField();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final Gender? gender = ref.watch(
//       providerProfileProvider.select(
//         (ProviderProfileState state) => state.gender,
//       ),
//     );

//     return DropdownButtonFormField<Gender>(
//       initialValue: gender,
//       items: const <DropdownMenuItem<Gender>>[
//         DropdownMenuItem<Gender>(value: Gender.male, child: Text('Male')),
//         DropdownMenuItem<Gender>(value: Gender.female, child: Text('Female')),
//         DropdownMenuItem<Gender>(value: Gender.others, child: Text('Others')),
//       ],
//       onChanged: (Gender? value) {
//         if (value != null) {
//           ref.read(providerProfileProvider.notifier).setGender(value);
//         }
//       },
//       decoration: InputDecoration(
//         labelText: 'Gender',
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
// }
