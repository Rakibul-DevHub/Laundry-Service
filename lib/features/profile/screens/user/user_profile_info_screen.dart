import 'dart:io';

import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/core/extensions/context_extensions.dart';
import 'package:drop_n_fresh/core/utils/image_picker_utils.dart';
import 'package:drop_n_fresh/shared/models/user_model.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/icons.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/profile_providers.dart';
import '../../state/user_profile_state.dart';

class UserProfileInfoScreen extends ConsumerWidget {
  const UserProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("RIDER PROFILE EDIT SCREEN BUILD");

    final AsyncValue<User> user = ref.watch(
      userProfileProvider.select(
        (UserProfileState value) => value.profileValue,
      ),
    );
    final File? localImage = ref.watch(
      userProfileProvider.select(
        (UserProfileState value) => value.profileImage,
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        showBackBtn: true,
        actions: <IconButton>[
          IconButton(
            icon: const AssetLoader(
              assetPath: AppIcons.edit,
              width: 24,
              height: 24,
              color: AppColors.body,
            ),
            onPressed: () => user.whenData(
              (User user) => context.push(RoutePaths.userProfileEdit),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: context.getKeyboardHeight,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenHorizontal,
              vertical: AppSizes.screenVertical,
            ),
            child: user.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (Object error, StackTrace stackTrace) => const Center(
                child: Text("Something went wrong!!"),
              ),
              data: (User data) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final File? file =
                          await ImagePickerUtils.pickImageFile();
                      if (file != null) {
                        ref
                            .read(userProfileProvider.notifier)
                            .setProfileImage(file);
                        await ref
                            .read(userProfileProvider.notifier)
                            .saveProfilePicture();
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: AssetLoader(
                            assetPath: localImage ?? data.profilePicture,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        const Positioned(
                          bottom: -8,
                          right: 0,
                          child: AssetLoader(
                            assetPath: AppIcons.camera,
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: AppSizes.spaceBetweenSections),

                  // Name
                  const _FieldLabel(label: 'Name'),
                  const SizedBox(height: AppSizes.xs),

                  Text(
                    data.fullName,
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.md),

                  // Email Address
                  const _FieldLabel(label: 'Email Address'),
                  Text(
                    data.email,
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.md),
                  // Phone Number
                  const _FieldLabel(label: 'Phone Number'),
                  Text(
                    data.phoneNumber ?? "Unknown",
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.md),
                  // Location
                  const _FieldLabel(label: 'Location'),
                  Text(
                    data.address.address,
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
    );
  }
}
