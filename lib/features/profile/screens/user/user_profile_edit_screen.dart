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
import '../../state/user_profile_state.dart';

class UserProfileEditScreen extends StatelessWidget {
  const UserProfileEditScreen({super.key});

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
                          userProfileProvider.select(
                            (UserProfileState state) => state.profileImage,
                          ),
                        );
                        final bool isProfileSubmitting = ref.watch(
                          userProfileProvider.select(
                            (UserProfileState state) =>
                                state.isProfileSubmitting,
                          ),
                        );
                        final AsyncValue<User> profile = ref.watch(
                          userProfileProvider.select(
                            (UserProfileState state) => state.profileValue,
                          ),
                        );
                        return GestureDetector(
                          onTap: isProfileSubmitting
                              ? null
                              : () => _pickImage(context, ref),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: AssetLoader(
                                  assetPath: imageFile ??
                                      profile.value?.profilePicture,
                                  shape: BoxShape.rectangle,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: -12,
                                right: 35,
                                child: isProfileSubmitting
                                    ? const SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const AssetLoader(
                                        assetPath: AppIcons.camera,
                                        width: 32,
                                        height: 32,
                                      ),
                              ),
                            ],
                          ),
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
                const SizedBox(height: AppSizes.spaceBetweenSections),
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
      ref.read(userProfileProvider.notifier).setProfileImage(file);
      ref.read(userProfileProvider.notifier).saveProfilePicture();
    }
  }
}

class _ProfileSaveButton extends ConsumerWidget {
  const _ProfileSaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isValid = ref.watch(
      userProfileProvider.select(
        (UserProfileState state) => state.isValid,
      ),
    );
    final bool isSubmitting = ref.watch(
      userProfileProvider.select(
        (UserProfileState state) => state.isSubmitting,
      ),
    );
    final bool isProfileSubmitting = ref.watch(
      userProfileProvider.select(
        (UserProfileState state) => state.isProfileSubmitting,
      ),
    );
    final bool canSave =
        isValid && !isSubmitting && !isProfileSubmitting;

    return AppElevatedButton(
      onPressed: canSave
          ? () => ref.read(userProfileProvider.notifier).saveProfile()
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
      userProfileProvider.select((UserProfileState state) => state.name),
    );
    final String? error = ref.watch(
      userProfileProvider.select((UserProfileState state) => state.nameError),
    );

    return AppTextField(
      initialValue: name,
      onChanged: (String v) =>
          ref.read(userProfileProvider.notifier).setName(v),
      errorText: error,
      onEditingComplete: () =>
          ref.read(userProfileProvider.notifier).validateName(),
      onUnfocus: () => ref.read(userProfileProvider.notifier).validateName(),
      labelText: 'Name',
    );
  }
}

class _ProfilePhoneField extends ConsumerWidget {
  const _ProfilePhoneField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String phone = ref.watch(
      userProfileProvider.select((UserProfileState state) => state.phone),
    );
    final String? error = ref.watch(
      userProfileProvider.select(
        (UserProfileState state) => state.phoneError,
      ),
    );

    return AppTextField(
      labelText: "Phone",
      errorText: error,
      initialValue: phone,
      onChanged: (String v) =>
          ref.read(userProfileProvider.notifier).setPhone(v),
      onEditingComplete: () =>
          ref.read(userProfileProvider.notifier).validatePhone(),
      onUnfocus: () => ref.read(userProfileProvider.notifier).validatePhone(),
    );
  }
}

class _ProfileLocationField extends ConsumerWidget {
  const _ProfileLocationField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = ref.watch(
      userProfileProvider.select((UserProfileState state) => state.location),
    );
    final String? error = ref.watch(
      userProfileProvider.select(
        (UserProfileState state) => state.locationError,
      ),
    );

    return AppTextField(
      errorText: error,
      labelText: "Location",
      initialValue: location,
      onChanged: (String v) =>
          ref.read(userProfileProvider.notifier).setLocation(v),
      onEditingComplete: () =>
          ref.read(userProfileProvider.notifier).validateLocation(),
      onUnfocus: () =>
          ref.read(userProfileProvider.notifier).validateLocation(),
    );
  }
}
