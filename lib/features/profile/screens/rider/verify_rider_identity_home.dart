import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/extensions/context_extensions.dart';
import 'package:drop_n_fresh/features/profile/state/rider_documents_submit_state.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/config/strings.dart';
import '../../../../shared/enums/rider_verify_identity_from_type.dart';
import '../../../../shared/models/rider_documents_model.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../widgets/document_upload_card.dart';

class VerifyRiderIdentityHome extends StatelessWidget {
  final RiderVerifyIdentityFromType fromType;
  const VerifyRiderIdentityHome({super.key, required this.fromType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleAlignment: fromType == RiderVerifyIdentityFromType.verify
            ? TitleAlignment.left
            : TitleAlignment.center,
        // ignore: avoid_bool_literals_in_conditional_expressions
        showBackBtn: fromType == RiderVerifyIdentityFromType.verify
            ? false
            : true,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: context.getKeyboardHeight,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontal,
            vertical: AppSizes.screenVertical,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppStrings.verifyRiderTitle,
                style: AppTextStyles.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                AppStrings.verifyRiderSubTitle,
                style: AppTextStyles.subTitle1.copyWith(
                  color: AppColors.body,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceBetweenSections),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  final Nid? nid = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.nid,
                    ),
                  );
                  final bool? isResubmitEnabled = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.isResubmitEnabled,
                    ),
                  );
                  return DocumentUploadCard(
                    title: AppStrings.verifyRiderNIDTitle,
                    subtitle: AppStrings.verifyRiderNIDSubTitle,
                    showStatus: true,
                    isUploaded: (nid != null),
                    onTap: () {
                      if (nid == null) {
                        context.push(RoutePaths.verifyRiderNID);
                      } else if (isResubmitEnabled != true) {
                        Toast.showWarning(
                          "NID cannot be uploaded again. Please contact the admin for permission.",
                        );
                        return;
                      } else {
                        context.push(RoutePaths.verifyRiderNID);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: AppSizes.spaceBetweenItems),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  final DrivingLicense? drivingLicense = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.drivingLicense,
                    ),
                  );
                  final bool? isResubmitEnabled = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.isResubmitEnabled,
                    ),
                  );
                  return DocumentUploadCard(
                    title: AppStrings.verifyRiderDrivingTitle,
                    subtitle: AppStrings.verifyRiderDrivingSubTitle,
                    showStatus: true,
                    isUploaded: (drivingLicense != null),
                    onTap: () {
                      if (drivingLicense == null) {
                        context.push(RoutePaths.verifyRiderDrivingLicense);
                      } else if (isResubmitEnabled != true) {
                        Toast.showWarning(
                          "Driving License cannot be uploaded again. Please contact the admin for permission.",
                        );
                        return;
                      } else {
                        context.push(RoutePaths.verifyRiderDrivingLicense);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: AppSizes.spaceBetweenItems),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  final Insurance? insurance = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.insurance,
                    ),
                  );
                  final bool? isResubmitEnabled = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.isResubmitEnabled,
                    ),
                  );
                  return DocumentUploadCard(
                    title: AppStrings.verifyRiderInsuranceTitle,
                    subtitle: AppStrings.verifyRiderInsuranceSubTitle,
                    showStatus: true,
                    isUploaded: (insurance != null),
                    onTap: () {
                      if (insurance == null) {
                        context.push(RoutePaths.verifyRiderInsuranceInfo);
                      } else if (isResubmitEnabled != true) {
                        Toast.showWarning(
                          "Insurance cannot be uploaded again. Please contact the admin for permission.",
                        );
                        return;
                      } else {
                        context.push(RoutePaths.verifyRiderInsuranceInfo);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: AppSizes.spaceBetweenItems),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  final Vehicle? vehicle = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.vehicle,
                    ),
                  );
                  final bool? isResubmitEnabled = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.isResubmitEnabled,
                    ),
                  );
                  return DocumentUploadCard(
                    title: AppStrings.verifyRiderVehicleInfoTitle,
                    subtitle: AppStrings.verifyRiderVehicleInfoSubTitle,
                    showStatus: true,
                    isUploaded: (vehicle != null),
                    onTap: () {
                      if (vehicle == null) {
                        context.push(RoutePaths.verifyRiderVehicle);
                      } else if (isResubmitEnabled != true) {
                        Toast.showWarning(
                          "Vehicle Info cannot be uploaded again. Please contact the admin for permission.",
                        );
                        return;
                      } else {
                        context.push(RoutePaths.verifyRiderVehicle);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: AppSizes.spaceBetweenItems),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  final Selfie? selfie = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.selfie,
                    ),
                  );
                  final bool? isResubmitEnabled = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.isResubmitEnabled,
                    ),
                  );
                  return DocumentUploadCard(
                    title: AppStrings.verifyRiderSelfieVerifyTitle,
                    subtitle: AppStrings.verifyRiderSelfieVerifySubTitle,
                    showStatus: true,
                    isUploaded: (selfie != null),
                    onTap: () {
                      if (selfie == null) {
                        context.push(RoutePaths.verifyRiderSelfie);
                      } else if (isResubmitEnabled != true) {
                        Toast.showWarning(
                          "Selfie cannot be uploaded again. Please contact the admin for permission.",
                        );
                        return;
                      } else {
                        context.push(RoutePaths.verifyRiderSelfie);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: AppSizes.spaceBetweenSections),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  final RiderDocumentsSubmitState state = ref.watch(
                    riderDocumentsSubmitProvider,
                  );
                  final RiderDocumentsModel? documents = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) => async.value,
                    ),
                  );
                  final bool? isResubmitEnabled = ref.watch(
                    riderIdentityVerifyHomeProvider.select(
                      (AsyncValue<RiderDocumentsModel?> async) =>
                          async.value?.isResubmitEnabled,
                    ),
                  );
                  return isResubmitEnabled == true
                      ? AppElevatedButton(
                          label: "Resubmit",
                          isLoading: state.isSubmitting,
                          isEnabled:
                              (documents?.nid != null &&
                              documents?.drivingLicense != null &&
                              documents?.insurance != null &&
                              documents?.vehicle != null &&
                              documents?.selfie != null),
                          onPressed: () {
                            ref
                                .read(riderDocumentsSubmitProvider.notifier)
                                .submitDocuments();
                          },
                        )
                      : fromType == RiderVerifyIdentityFromType.verify
                      ? AppElevatedButton(
                          label: "Proceed",
                          isEnabled:
                              (documents?.nid != null &&
                              documents?.drivingLicense != null &&
                              documents?.insurance != null &&
                              documents?.vehicle != null &&
                              documents?.selfie != null),
                          onPressed: () async {
                            ref
                                .read(riderDocumentsSubmitProvider.notifier)
                                .submitDocuments();
                            context.go(RoutePaths.rider);
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
              const SizedBox(height: AppSizes.spaceBetweenSections),
            ],
          ),
        ),
      ),
    );
  }
}
