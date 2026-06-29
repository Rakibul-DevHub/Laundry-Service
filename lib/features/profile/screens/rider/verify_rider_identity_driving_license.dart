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

class VerifyRiderIdentityDrivingLicense extends StatelessWidget {
  const VerifyRiderIdentityDrivingLicense({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("VerifyRiderIdentityDrivingLicense SCREEN BUILD");
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Driving License Verification",
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
                    "VerifyRiderIdentityDrivingLicense driving front BUILD",
                  );
                  final File? driving = ref.watch(
                    riderIdentityVerifyProvider.select(
                      (RiderVerificationState state) =>
                          state.drivingLicenseFront,
                    ),
                  );
                  if (driving != null) {
                    return DocumentImagePreview(
                      imageFile: driving,
                      onRemove: () {
                        ref
                            .read(riderIdentityVerifyProvider.notifier)
                            .removeDrivingLicenseFront();
                      },
                    );
                  } else {
                    return DocumentPlaceholderCard(
                      onPick: () async {
                        final File? file = await FilePickerUtils.pickFile();
                        if (file != null) {
                          ref
                              .read(riderIdentityVerifyProvider.notifier)
                              .setDrivingLicenseFront(file);
                        }
                      },
                      title:
                          "Click to Upload the front of your Driving License",
                      supportDesc: "Supported formats: JPEG, PNG",
                    );
                  }
                },
              ),

              const SizedBox(
                height: AppSizes.spaceBetweenItems,
              ),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  AppLogger().d(
                    "VerifyRiderIdentityDrivingLicense driving back BUILD",
                  );
                  final File? driving = ref.watch(
                    riderIdentityVerifyProvider.select(
                      (RiderVerificationState state) =>
                          state.drivingLicenseBack,
                    ),
                  );
                  if (driving != null) {
                    return DocumentImagePreview(
                      imageFile: driving,
                      onRemove: () {
                        ref
                            .read(riderIdentityVerifyProvider.notifier)
                            .removeDrivingLicenseBack();
                      },
                    );
                  } else {
                    return DocumentPlaceholderCard(
                      onPick: () async {
                        final File? file = await FilePickerUtils.pickFile();
                        if (file != null) {
                          ref
                              .read(riderIdentityVerifyProvider.notifier)
                              .setDrivingLicenseBack(file);
                        }
                      },
                      title: "Click to Upload the Back of your Driving License",
                      supportDesc: "Supported formats: JPEG, PNG",
                    );
                  }
                },
              ),

              const SizedBox(height: AppSizes.spaceBetweenSections),

              const VerifyDrivingLicenseSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyDrivingLicenseSubmitButton extends ConsumerWidget {
  const VerifyDrivingLicenseSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("VerifyDriving VerifyDrivingLicenseSubmitButton BUILD");

    final bool isSubmitting = ref.watch(
      riderIdentityVerifyProvider.select(
        (RiderVerificationState state) => state.isDrivingLicenseSubmitting,
      ),
    );
    final bool isDrivingLicenseComplete = ref.watch(
      riderIdentityVerifyProvider.select(
        (RiderVerificationState state) => state.isDrivingLicenseComplete,
      ),
    );

    return AppElevatedButton(
      label: AppStrings.submitButton,
      onPressed: isSubmitting || !isDrivingLicenseComplete
          ? null
          : () => ref
                .read(riderIdentityVerifyProvider.notifier)
                .handleDrivingLicenseSubmit(),
      isEnabled: isDrivingLicenseComplete,
      isLoading: isSubmitting,
    );
  }
}
