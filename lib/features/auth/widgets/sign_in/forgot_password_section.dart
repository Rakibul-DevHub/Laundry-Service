import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/strings.dart';
import '../../../../shared/widgets/custom_popup.dart';
import '../../providers/auth_providers.dart';
import 'forgot_password_popup.dart';

class ForgotPasswordSection extends ConsumerStatefulWidget {
  const ForgotPasswordSection({super.key});

  @override
  ConsumerState<ForgotPasswordSection> createState() => ForgotPasswordSectionState();
}

class ForgotPasswordSectionState extends ConsumerState<ForgotPasswordSection> {
  bool _prevIsOpen = false;

  @override
  Widget build(BuildContext context) {
    final bool isForgotPopupOpen = ref.watch(signInProvider).isForgotPopupOpen;

    if (!_prevIsOpen && isForgotPopupOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomPopup.show<Column>(
          context: context,
          isDismissible: false,
          content: ForgotPasswordPopup(email: ref.read(signInProvider).email),
        );
        ref.read(signInProvider.notifier).handleResetForgotPopup();
      });
    }
    _prevIsOpen = isForgotPopupOpen;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            ref.read(signInProvider.notifier).handleForgotPassword();
          },
          child: Text(
            AppStrings.forgotPassword,
            style: AppTextStyles.paragraph1.copyWith(
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }
}
