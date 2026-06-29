import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/strings.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import '../../providers/auth_providers.dart';
import '../../state/delete_account_state.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isValid = ref.watch(
      deleteAccountProvider.select((DeleteAccountState state) => state.isValid),
    );

    final bool isSubmitting = ref.watch(
      deleteAccountProvider.select(
        (DeleteAccountState state) => state.isSubmitting,
      ),
    );

    return AppOutlineButton(
      label: AppStrings.deleteAccountButton,
      onPressed: isSubmitting || !isValid ? null : (){
        ref.read(deleteAccountProvider.notifier).deleteAccount();
      },
      outlineColor: AppColors.red,
      isLoading: isSubmitting,
      isEnabled: isValid,
    );
  }
}
