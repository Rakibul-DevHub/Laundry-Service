import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/core/extensions/context_extensions.dart';
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
import '../../state/provider_profile_state.dart';

class ProviderProfileInfoScreen extends ConsumerWidget {
  const ProviderProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("PROVIDER PROFILE INFO SCREEN BUILD");

    final AsyncValue<User> user = ref.watch(
      providerProfileProvider.select(
        (ProviderProfileState value) => value.profileValue,
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
              (User user) => context.push(RoutePaths.providerProfileEdit),
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
                  // Profile Image with Camera Icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: AssetLoader(
                      assetPath: data.profilePicture,
                      width: 100,
                      height: 100,
                      shape: BoxShape.rectangle,
                    ),
                  ),
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

                  // Age
                  const _FieldLabel(label: 'TAX-ID'),
                  Text(
                    data.businessInfo?.taxId ?? 'N/A',
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // Age
                  const _FieldLabel(label: 'Business Name'),
                  Text(
                    data.businessInfo?.businessName ?? 'N/A',
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // Age
                  const _FieldLabel(label: 'Verification Status'),
                  Text(
                    data.businessInfo?.verificationStatus ?? 'N/A',
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const SizedBox(height: 32),
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
