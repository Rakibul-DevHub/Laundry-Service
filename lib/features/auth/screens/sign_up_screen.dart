import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../features/auth/state/sign_up_state.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../core/config/sizes.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/enums/role.dart';
import '../providers/auth_providers.dart';
import '../../../shared/widgets/app_elevated_button.dart';
import '../widgets/sign_up/provider_sign_up_form.dart';
import '../widgets/sign_up/rider_sign_up_form.dart';
import '../widgets/sign_up/user_sign_up_form.dart';
import '../../../core/extensions/context_extensions.dart';

// sign_up_screen.dart
class SignUpScreen extends StatelessWidget {
  final Role role;
  const SignUpScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("SIGN UP SCREEN BUILD");

    Widget form;
    switch (role) {
      case Role.user:
        form = UserForm(role);
      case Role.rider:
        form = RiderForm(role);
      case Role.provider:
        form = ProviderForm(role);
    }

    return Scaffold(
      appBar: const CustomAppBar(
        showBackBtn: true,
        title: "Create Your Account",
      ),
      resizeToAvoidBottomInset: false,
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
              children: <Widget>[
                Text(
                  "Earn money by collecting and delivering goods efficiently.",
                  style: AppTextStyles.subTitle1,
                ),
                const SizedBox(height: AppSizes.spaceBetweenSections),
                form,
                const SizedBox(height: AppSizes.spaceBetweenSections),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? widget) {
                        AppLogger().d("SIGN UP BUTTON SCREEN BUILD");

                        final bool isSubmitting = ref.watch(
                          signUpProvider(
                            role,
                          ).select((SignUpState state) => state.isSubmitting),
                        );
                        final bool isValid = ref.watch(
                          signUpProvider(
                            role,
                          ).select((SignUpState state) => state.isValid),
                        );
                        return AppElevatedButton(
                          label: isSubmitting ? 'Signing up...' : 'Sign Up',
                          onPressed: isSubmitting || !isValid
                              ? null
                              : () => ref
                                    .read(signUpProvider(role).notifier)
                                    .handleSignUp(),
                          isEnabled: isValid,
                          isLoading: isSubmitting,
                        );
                      },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
