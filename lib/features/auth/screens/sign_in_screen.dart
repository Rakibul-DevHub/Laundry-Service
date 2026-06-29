import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/images.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/widgets/asset_loader.dart';
import '../widgets/sign_in/forgot_password_section.dart';
import '../widgets/sign_in/sign_in_button.dart';
import '../widgets/sign_in/sign_in_email_field.dart';
import '../widgets/sign_in/sign_in_password_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("SIGN IN SCREEN BUILD");

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: context.getKeyboardHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenHorizontal,
              vertical: AppSizes.screenVertical,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Logo (never rebuilds)
                const SizedBox(height: AppSizes.spaceBetweenItems),

                const AssetLoader(
                  assetPath: AppImages.logoWebP,
                  width: 120,
                  height: 140,
                ),
                const SizedBox(height: AppSizes.spaceBetweenItems),

                // Title (never rebuilds)
                Text(
                  AppStrings.signInTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading1,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  AppStrings.signInSubTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subTitle1.copyWith(
                    color: AppColors.body,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBetweenSections),

                //  Email Field (only rebuilds if needed)
                const SignInEmailField(),
                const SizedBox(height: AppSizes.spaceBetweenInputs),

                //  Password Field (only rebuilds if needed)
                const SignInPasswordField(),

                const SizedBox(height: AppSizes.sm),

                // Forgot Password with popup logic
                const ForgotPasswordSection(),

                const SizedBox(height: AppSizes.spaceBetweenSections),

                // Sign In Button (only rebuilds on state change)
                const SignInButton(),

                const SizedBox(height: AppSizes.spaceBetweenSections),

                // // "Or continue with" section (never rebuilds)
                // Row(
                //   spacing: AppSizes.sm,
                //   children: <Widget>[
                //     const Expanded(
                //       child: Divider(color: AppColors.grey50, thickness: 1.0),
                //     ),
                //     Text(
                //       AppStrings.orContinueWith,
                //       style: AppTextStyles.paragraph0.copyWith(
                //         color: AppColors.body,
                //       ),
                //     ),
                //     const Expanded(
                //       child: Divider(color: AppColors.grey50, thickness: 1.0),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: AppSizes.spaceBetweenSections),

                // // Social buttons (never rebuilds)
                // const Row(
                //   spacing: AppSizes.spaceBetweenCards,
                //   children: <Widget>[
                //     Expanded(
                //       child: GoogleSignInButton(),
                //     ),
                //     Expanded(
                //       child: AppleSignInButton(),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: AppSizes.spaceBetweenSections),

                // Sign up link (never rebuilds)
                RichText(
                  text: TextSpan(
                    text: "${AppStrings.doNotHaveAnAcc} ",
                    style: AppTextStyles.paragraph0.copyWith(
                      color: AppColors.body,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: AppStrings.signUpBtn,
                        style: AppTextStyles.paragraph0,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push(RoutePaths.role);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
