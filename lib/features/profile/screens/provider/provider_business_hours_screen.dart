// features/business/screens/provider_business_hours_screen.dart

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/profile/model/business_hours_model.dart';
import 'package:drop_n_fresh/features/profile/notifier/business_hours_notifier.dart';
import 'package:drop_n_fresh/features/profile/widgets/business_hours_day_selector.dart';
import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProviderBusinessHoursScreen extends ConsumerWidget {
  const ProviderBusinessHoursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BusinessHoursState state = ref.watch(businessHoursProvider);
    final BusinessHoursNotifier notifier = ref.read(
      businessHoursProvider.notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Business Hours",
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Set your opening and closing times for each day.',
                          style: AppTextStyles.paragraph0.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Select Days & Time',
                          style: AppTextStyles.heading5,
                        ),
                        const SizedBox(height: 16),

                        // Day Selection
                        BusinessHoursDaySelector(
                          schedules:
                              state.businessHoursData?.businessHours ??
                              <DaySchedule>[],
                          onDayToggled: notifier.toggleDay,
                          on24HoursToggled: notifier.toggle24Hours,
                          onOpenTimeChanged: notifier.setOpenTime,
                          onCloseTimeChanged: notifier.setCloseTime,
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: AppColors.body),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.paragraph1.copyWith(
                              color: AppColors.body,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state.isSaving
                              ? null
                              : () async {
                                  await notifier.saveBusinessHours();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                              : Text(
                                  'Save',
                                  style: AppTextStyles.paragraph1.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
