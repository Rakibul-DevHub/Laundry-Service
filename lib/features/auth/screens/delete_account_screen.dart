import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/strings.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../providers/auth_providers.dart';
import '../state/delete_account_state.dart';
import '../widgets/delete_account/delete_account_form.dart';
import '../widgets/delete_account/delete_account_warning.dart';

class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("DELETE ACCOUNT SCREEN BUILD");
    final bool isWarningScreen = ref.watch(
      deleteAccountProvider.select(
        (DeleteAccountState state) => state.isWarningScreen,
      ),
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(
          title: AppStrings.deleteAccountTitle,
          showBackBtn: true,
        ),
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: context.getKeyboardHeight),
            child: isWarningScreen
                ? const DeleteAccountWarning()
                : const DeleteAccountForm(),
          ),
        ),
      ),
    );
  }
}
