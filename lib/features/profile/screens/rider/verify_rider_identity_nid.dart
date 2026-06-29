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

class VerifyRiderNidScreen extends StatelessWidget {
  const VerifyRiderNidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("VerifyRiderNidScreen SCREEN BUILD");
    return Scaffold(
      appBar: const CustomAppBar(title: "NID Verification", showBackBtn: true,),
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
                  AppLogger().d("VerifyRiderNidScreen nid front BUILD");
                  final File? nid = ref.watch(
                    riderIdentityVerifyProvider.select(
                      (RiderVerificationState state) => state.nidFront,
                    ),
                  );
                  if (nid != null) {
                    return DocumentImagePreview(
                      imageFile: nid,
                      onRemove: () {
                        ref
                            .read(riderIdentityVerifyProvider.notifier)
                            .removeNidFront();
                      },
                    );
                  } else {
                    return DocumentPlaceholderCard(
                      onPick: () async {
                        final File? file = await FilePickerUtils.pickFile();
                        if (file != null) {
                          ref
                              .read(riderIdentityVerifyProvider.notifier)
                              .setNidFront(file);
                        }
                      },
                      title: "Click to Upload the front of your NID",
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
                  AppLogger().d("VerifyRiderNidScreen nid back BUILD");
                  final File? nid = ref.watch(
                    riderIdentityVerifyProvider.select(
                      (RiderVerificationState state) => state.nidBack,
                    ),
                  );
                  if (nid != null) {
                    return DocumentImagePreview(
                      imageFile: nid,
                      onRemove: () {
                        ref
                            .read(riderIdentityVerifyProvider.notifier)
                            .removeNidBack();
                      },
                    );
                  } else {
                    return DocumentPlaceholderCard(
                      onPick: () async {
                        final File? file = await FilePickerUtils.pickFile();
                        if (file != null) {
                          ref
                              .read(riderIdentityVerifyProvider.notifier)
                              .setNidBack(file);
                        }
                      },
                      title: "Upload clear photo of NID back side",
                      supportDesc: "Supported formats: JPEG, PNG",
                    );
                  }
                },
              ),

              const SizedBox(height: AppSizes.spaceBetweenSections),

              const VerifyNIDSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyNIDSubmitButton extends ConsumerWidget {
  const VerifyNIDSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("VerifyNID _VerifyNIDSubmitButton BUILD");

    final bool isSubmitting = ref.watch(
      riderIdentityVerifyProvider.select(
        (RiderVerificationState state) => state.isNidSubmitting,
      ),
    );
    final bool isNidComplete = ref.watch(
      riderIdentityVerifyProvider.select(
        (RiderVerificationState state) => state.isNidComplete,
      ),
    );

    return AppElevatedButton(
      label: AppStrings.submitButton,
      onPressed: isSubmitting || !isNidComplete
          ? null
          : () => ref
                .read(riderIdentityVerifyProvider.notifier)
                .handleNIDSubmit(),
      isEnabled: isNidComplete,
      isLoading: isSubmitting,
    );
  }
}
