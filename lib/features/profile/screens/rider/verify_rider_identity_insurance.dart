import 'dart:io';
import 'package:drop_n_fresh/features/profile/state/rider_verification_state.dart';
import 'package:drop_n_fresh/features/profile/widgets/document_placeholder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/file_picker_utils.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../widgets/document_image_preview.dart';

class VerifyRiderIdentityInsurance extends StatelessWidget {
  const VerifyRiderIdentityInsurance({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("VerifyRiderIdentityInsurance SCREEN BUILD");
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Insurance Info Verification",
        showBackBtn: true,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontal,
            vertical: AppSizes.screenVertical,
          ),
          child: Column(
            children: <Widget>[
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  AppLogger().d(
                    "VerifyRiderIdentityInsurance insurance file BUILD",
                  );
                  final File? driving = ref.watch(
                    riderIdentityVerifyProvider.select(
                      (RiderVerificationState state) => state.insuranceDocument,
                    ),
                  );
                  if (driving != null) {
                    return DocumentImagePreview(
                      imageFile: driving,
                      onRemove: () {
                        ref
                            .read(riderIdentityVerifyProvider.notifier)
                            .removeInsuranceDoc();
                      },
                    );
                  } else {
                    return DocumentPlaceholderCard(
                      onPick: () async {
                        final File? file = await FilePickerUtils.pickFile();
                        if (file != null) {
                          ref
                              .read(riderIdentityVerifyProvider.notifier)
                              .setInsuranceDoc(file);
                        }
                      },
                      title: "Click to Upload Insurance Information",
                      supportDesc: "Supported formats: JPEG, PNG",
                    );
                  }
                },
              ),

              const SizedBox(height: AppSizes.spaceBetweenSections),

              const VerifyInsuranceSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyInsuranceSubmitButton extends ConsumerWidget {
  const VerifyInsuranceSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("VerifyDriving VerifyInsuranceSubmitButton BUILD");

    final bool isSubmitting = ref.watch(
      riderIdentityVerifyProvider.select(
        (RiderVerificationState state) => state.isInsuranceSubmitting,
      ),
    );
    final bool isInsuranceComplete = ref.watch(
      riderIdentityVerifyProvider.select(
        (RiderVerificationState state) => state.isInsuranceComplete,
      ),
    );

    return AppElevatedButton(
      label: AppStrings.submitButton,
      onPressed: isSubmitting || !isInsuranceComplete
          ? null
          : () => ref
                .read(riderIdentityVerifyProvider.notifier)
                .handleInsuranceSubmit(),
      isEnabled: isInsuranceComplete,
      isLoading: isSubmitting,
    );
  }
}
