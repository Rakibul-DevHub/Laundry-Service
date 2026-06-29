import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/icons.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_in_state.dart';

class AppleSignInButton extends ConsumerWidget {
  const AppleSignInButton({super.key}); // 👈 add const constructor

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN IN _AppleSignInButton BUILD");

    final bool isSubmitting = ref.watch(
      signInProvider.select((SignInState state) => state.isSubmitting),
    );

    return AppOutlineButton(
      icon: const AssetLoader(assetPath: AppIcons.apple),
      label: AppStrings.appleBtn,
      outlineColor: AppColors.body,
      isEnabled: !isSubmitting,
      onPressed: isSubmitting
          ? null
          : () => ref.read(signInProvider.notifier).handleAppleSignIn(),
    );
  }
}
