// ignore_for_file: inference_failure_on_function_return_type

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/bags/models/bag_model.dart';
import 'package:drop_n_fresh/features/bags/providers/bags_providers.dart';
import 'package:drop_n_fresh/features/bags/state/my_bags_state.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_booking_models.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step3BagInstructions extends ConsumerWidget {
  final List<String> selectedBagIds;
  final List<DeliveryInstruction> instructions;
  final String specialInstructions;
  final Function(List<String> selectedBagIds) onBagsSelected;
  final Function(String instructionId) onInstructionToggled;
  final Function(String instructions) onSpecialInstructionsChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step3BagInstructions({
    super.key,
    required this.selectedBagIds,
    required this.instructions,
    required this.specialInstructions,
    required this.onBagsSelected,
    required this.onInstructionToggled,
    required this.onSpecialInstructionsChanged,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyBagsState bagState = ref.watch(myBagProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // =================================================
          // bag selection section
          // =================================================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Select Bags',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Choose one or more bags for your order',
                  style: AppTextStyles.paragraph1.copyWith(
                    color: AppColors.body,
                  ),
                ),
                const SizedBox(height: AppSizes.md),

                if (bagState.error != null) ...<Widget>[
                  _buildBagsErrorContent(
                    error: bagState.error!,
                    onRetry: () => ref.read(myBagProvider.notifier).refresh(),
                  ),
                  const SizedBox(height: AppSizes.md),
                ] else if (bagState.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (bagState.bags.isEmpty)
                  _buildNoBagsContent()
                else
                  Column(
                    children: bagState.bags.map((BagModel bag) {
                      final bool isSelected = selectedBagIds.contains(bag.id);
                      return _BagSelectionCard(
                        bag: bag,
                        isSelected: isSelected,
                        onToggle: (bool selected) {
                          final List<String> newSelection = List<String>.from(
                            selectedBagIds,
                          );
                          if (bag.isAvailable) {
                            newSelection.clear();
                            if (selected) {
                              newSelection.add(bag.id);
                            } else {
                              newSelection.remove(bag.id);
                            }
                            onBagsSelected(newSelection);
                          } else {
                            Toast.showWarning(
                              "This bag is not available right now",
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.lg),
          // =================================================
          // =================================================

          // Instructions Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Instructions',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppSizes.sm),

                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: instructions.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSizes.sm),
                    itemBuilder: (BuildContext context, int index) {
                      final DeliveryInstruction instruction =
                          instructions[index];
                      final bool isSelected = instruction.isSelected;

                      return GestureDetector(
                        onTap: () => onInstructionToggled(instruction.id),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.body.withValues(alpha: .2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: .03)
                                : Colors.transparent,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              AssetLoader(
                                assetPath: instruction.iconPath,
                                width: 32,
                                height: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                instruction.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.title,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                // Special Instructions
                Text(
                  'Type Special Instructions',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppSizes.md),

                TextFormField(
                  initialValue: specialInstructions,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'You can give specific instruction.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: onSpecialInstructionsChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // Navigation Buttons
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrevious,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Previous'),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBagsErrorContent({
    required String error,
    required VoidCallback onRetry,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.error_outline, color: AppColors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Failed to load bags: $error',
              style: AppTextStyles.paragraph0.copyWith(color: AppColors.red),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoBagsContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.body.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.inventory_2, color: AppColors.body, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No available bags found. Please contact support to get a bag assigned to your account.',
              style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
            ),
          ),
        ],
      ),
    );
  }
}

class _BagSelectionCard extends StatelessWidget {
  final BagModel bag;
  final bool isSelected;
  final Function(bool) onToggle;

  const _BagSelectionCard({
    required this.bag,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isSelected,
      onChanged: (bool? value) => onToggle(value ?? false),
      activeColor: AppColors.primary,
      checkColor: AppColors.white,
      title: Text(
        bag.displayCode.isNotEmpty
            ? bag.displayCode
            : 'Bag #${bag.id.substring(0, 8)}',
        style: AppTextStyles.paragraph1.copyWith(
          color: isSelected ? AppColors.title : AppColors.body,
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (bag.flaggedForReplacement) ...<Widget>[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Needs replacement',
                    style: AppTextStyles.paragraph3.copyWith(
                      color: AppColors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Text(
            'Status: ${bag.status.displayName}'.toUpperCase(),
            style: AppTextStyles.paragraph3.copyWith(
              color: bag.status == BagStatus.available
                  ? AppColors.green
                  : AppColors.body,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
