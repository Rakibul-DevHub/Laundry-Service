import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/icons.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../../../../shared/widgets/custom_popup.dart';
import '../../providers/profile_providers.dart';
import '../../state/provider_profile_state.dart';
import '../../widgets/logout_popup.dart';
import '../../widgets/profile/profile_card.dart';
import '../../widgets/profile/profile_item_section.dart';
import '../../widgets/shimmer/profile_card_shimmer.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.spaceBetweenItems,
              children: <Widget>[
                // top profile info
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? widget) {
                        final AsyncValue<User> user = ref.watch(
                          providerProfileProvider.select(
                            (ProviderProfileState value) => value.profileValue,
                          ),
                        );
                        return user.when(
                          data: (User data) => ProfileCard(
                            profile: data,
                            onNavigation: () {
                              context.push(RoutePaths.providerProfileInfo);
                            },
                          ),
                          error: (Object error, StackTrace stackTrace) =>
                              const ProfileCardShimmer(),
                          loading: () => const ProfileCardShimmer(),
                        );
                      },
                ),

                // profile item sections with their items
                // account section
                ProfileItemSection(
                  title: "Account",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSizes.spaceBetweenItems,
                    children: <Widget>[
                      ProfileItem(
                        onTapCallback: () {
                          context.push(RoutePaths.providerProfileInfo);
                        },
                        title: 'Your Profile',
                        isDivider: true,
                      ),
                      ProfileItem(
                        isDivider: false,
                        onTapCallback: () {
                          context.push(RoutePaths.providerDocUpload);
                        },
                        title: 'Provider Documents',
                      ),
                    ],
                  ),
                ),

                // password and security section
                ProfileItemSection(
                  title: "Password & Security",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSizes.sm,
                    children: <Widget>[
                      ProfileItem(
                        isDivider: true,
                        onTapCallback: () {
                          context.push(RoutePaths.changePassword);
                        },
                        title: 'Change Password',
                      ),

                      ProfileItem(
                        onTapCallback: () {
                          context.push(RoutePaths.deleteAccount);
                        },
                        title: 'Delete Account',
                      ),
                    ],
                  ),
                ),

                // help and settings
                ProfileItemSection(
                  title: "Help & Settings",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSizes.sm,
                    children: <Widget>[
                      ProfileItem(
                        isDivider: true,
                        onTapCallback: () {
                          context.push(RoutePaths.providerBusinessHours);
                        },
                        title: 'Business Hours',
                      ),
                      ProfileItem(
                        isDivider: true,
                        onTapCallback: () {
                          context.push(RoutePaths.termsCondition);
                        },
                        title: 'Terms & Conditions',
                      ),
                      ProfileItem(
                        isDivider: true,
                        onTapCallback: () {
                          context.push(RoutePaths.privacyPolicy);
                        },
                        title: 'Privacy & Policy',
                      ),
                      ProfileItem(
                        onTapCallback: () {
                          context.push(RoutePaths.support);
                        },
                        title: 'Support',
                      ),
                    ],
                  ),
                ),

                // Contact us
                // ProfileItemSection(
                //   title: "Company Info",
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     spacing: AppSizes.sm,
                //     children: <Widget>[
                //       ProfileItem(
                //         isDivider: true,
                //         onTapCallback: () {
                //           context.push(RoutePaths.aboutUs);
                //         },
                //         title: 'About Us',
                //       ),
                //       ProfileItem(
                //         onTapCallback: () {
                //           context.push(RoutePaths.contactUs);
                //         },
                //         title: 'Contact Us',
                //       ),
                //     ],
                //   ),
                // ),
                AppElevatedButton(
                  label: "Log Out",
                  backgroundColor: AppColors.red200,
                  icon: const AssetLoader(
                    assetPath: AppIcons.logout,
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    color: AppColors.red300,
                  ),
                  onPressed: () {
                    CustomPopup.show<LogoutPopup>(
                      context: context,
                      content: const LogoutPopup(),
                    );
                  },
                ),
                Center(
                  child: Text(
                    "Version 1.0.0",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.paragraph0.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spaceBetweenItems,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
