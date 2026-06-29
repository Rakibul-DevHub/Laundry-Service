// features/riders/jobs/screens/job_details_screen.dart

import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/core/config/icons.dart';
import 'package:drop_n_fresh/features/jobs/models/jobs_check_point_type.dart';
import 'package:drop_n_fresh/features/jobs/models/jobs_details_model.dart';
import 'package:drop_n_fresh/features/jobs/notifier/jobs_details_notifier.dart';
import 'package:drop_n_fresh/features/jobs/providers/jobs_providers.dart';
import 'package:drop_n_fresh/features/jobs/state/jobs_details_state.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:drop_n_fresh/shared/widgets/app_outline_button.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_border.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_refresh_indicator.dart';
import '../widgets/job_details_check_point_progress.dart';
import '../widgets/job_details_delivery_payout.dart';
import '../widgets/job_details_message_box.dart';

class JobsDetailScreen extends ConsumerWidget {
  final String jobId;

  const JobsDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final JobsDetailsState state = ref.watch(jobsDetailsProvider(jobId));
    final JobsDetailsNotifier notifier = ref.read(
      jobsDetailsProvider(jobId).notifier,
    );
    final JobsDetailsModel? job = state.job;

    return Scaffold(
      appBar: CustomAppBar(
        title: job != null
            ? 'Order #${job.id.substring(0, 8)}'
            : 'Order Progress',
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              state.isRefreshing ? Icons.refresh : Icons.refresh,
              color: Colors.white,
            ),
            onPressed: state.isRefreshing ? null : () => notifier.refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      backgroundColor: AppColors.white,
      body: CustomRefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: state.isLoading && job == null
            ? _buildShimmerContent()
            : state.hasError
            ? _buildErrorState(state, notifier)
            : _buildContent(state, notifier, context),
      ),
    );
  }

  // ============================================================================
  //  SHIMMER LOADING STATE
  // ============================================================================

  Widget _buildShimmerContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontal,
        vertical: AppSizes.screenVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Progress Indicator Shimmer
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Message Box Shimmer
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 300,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Route Overview Shimmer
          Row(
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 100,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Job Details Shimmer
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              border: Border.all(color: AppColors.body, width: 1),
            ),
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                const DashedDivider(color: AppColors.body),
                const SizedBox(height: 16),
                _buildShimmerRow('Pickup', 150),
                const SizedBox(height: 12),
                _buildShimmerRow('Drop Off', 150),
                const SizedBox(height: 16),
                _buildShimmerRow('Total Items', 80, isValue: true),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Payout Shimmer
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Action Button Shimmer
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerRow(
    String label,
    double valueWidth, {
    bool isValue = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 60,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            Container(
              width: isValue ? valueWidth : 100,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (isValue) ...<Widget>[
              const Spacer(),
              Container(
                width: 40,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ============================================================================
  //  ERROR STATE
  // ============================================================================

  Widget _buildErrorState(
    JobsDetailsState state,
    JobsDetailsNotifier notifier,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load order',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 8),
            Text(
              state.error ?? 'Unknown error',
              style: AppTextStyles.paragraph1.copyWith(
                color: AppColors.body,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: AppOutlineButton(
                onPressed: () => notifier.refresh(),
                label: 'Retry',
                height: 44,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  //  MAIN CONTENT
  // ============================================================================

  Widget _buildContent(
    JobsDetailsState state,
    JobsDetailsNotifier notifier,
    BuildContext context,
  ) {
    final JobsDetailsModel job = state.job!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontal,
        vertical: AppSizes.screenVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  Progress Indicator with checkpoint steps
          JobDetailsCheckPointProgress(
            currentStatus: job.checkPointStatusType,
            isPickupLeg: state.isPickupLeg,
            // isDeliveryLeg: state.isDeliveryLeg,
          ),
          const SizedBox(height: AppSizes.md),

          //  Dynamic Message Box based on checkpoint
          JobDetailsMessageBox(job: job),
          const SizedBox(height: AppSizes.md),

          //  Route Overview with Map button
          _buildRouteOverview(job, state, context),
          const SizedBox(height: AppSizes.md),

          //  Job Details Card
          _buildJobDetailsCard(job),
          const SizedBox(height: AppSizes.md),

          //  QR Scan Section (only when needed)
          if (state.requiresQrScan)
            _buildQrScanSection(state, notifier, context),
          if (state.requiresQrScan) const SizedBox(height: AppSizes.md),

          //  Waiting for Provider message
          if (state.isWaitingForProvider) _buildWaitingForProviderBanner(),
          if (state.isWaitingForProvider) const SizedBox(height: AppSizes.md),

          //  Delivery Payout
          JobDetailsDeliveryPayout(job: job),
          const SizedBox(height: AppSizes.md),

          //  Main Action Button
          _buildActionButton(state, notifier, context),

          // Bottom padding for bottom sheet
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ============================================================================
  //  ROUTE OVERVIEW
  // ============================================================================

  Widget _buildRouteOverview(
    JobsDetailsModel job,
    JobsDetailsState state,
    BuildContext context,
  ) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.map_outlined,
          size: 24,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSizes.sm),
        Text(
          'Route Overview',
          style: AppTextStyles.heading3,
        ),
        const Spacer(),
        AppOutlineButton(
          onPressed: () {
            context.push(
              RoutePaths.jobMapScreen,
              extra: <String, Object>{
                "job": job,
                "isPickupLeg": state.isPickupLeg,
              },
            );
          },
          height: 40,
          width: 100,
          label: 'Show Map',
        ),
      ],
    );
  }

  Widget _buildJobDetailsCard(JobsDetailsModel job) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(color: AppColors.body, width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.title.withValues(alpha: 0.1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Service Type
          Text(
            job.serviceType,
            style: AppTextStyles.heading5,
          ),
          const SizedBox(height: AppSizes.spaceBetweenItems),
          const DashedDivider(color: AppColors.body),
          const SizedBox(height: AppSizes.spaceBetweenItems),

          // Pickup Location
          _buildLocationRow(
            'Pickup',
            job.pickupLocation,
            Icons.location_on_outlined,
          ),
          const SizedBox(height: AppSizes.spaceBetweenItems),

          // Dropoff Location
          _buildLocationRow(
            'Drop Off',
            job.dropOffLocation,
            Icons.flag_outlined,
          ),
          const SizedBox(height: 16),

          // Total Items
          Row(
            children: <Widget>[
              Text(
                'Total Items',
                style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
              ),
              const Spacer(),
              Text(
                '${job.totalItems} pcs',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),

          // Items List
          ...job.items.map(
            (JobItem item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.check_box_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      '${item.itemName} (${item.productCategoryName})',
                      style: AppTextStyles.paragraph1.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                  ),
                  Text(
                    '× ${item.quantity}',
                    style: AppTextStyles.paragraph1.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Special Instructions (if any)
          if (job.specialInstructions.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.body.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Note: ${job.specialInstructions}',
                      style: AppTextStyles.paragraph2.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationRow(String label, String address, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(icon, size: 16, color: AppColors.body),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          address,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  // ============================================================================
  //  QR SCAN SECTION
  // ============================================================================

  Widget _buildQrScanSection(
    JobsDetailsState state,
    JobsDetailsNotifier notifier,
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Scan Bag QR Code',
          style: AppTextStyles.paragraph0.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        DashedBorder(
          strokeWidth: 1.0,
          dashGap: 5.0,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const AssetLoader(
                  assetPath: AppIcons.scan,
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 12),

                UnconstrainedBox(
                  child: AppElevatedButton(
                    onPressed: () {
                      context.push(
                        RoutePaths.jobScanQrScreen,
                        extra: state.job?.id,
                      );
                    },
                    label: "Scan Bag",
                    height: 44,
                    width: 80,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  //  WAITING FOR PROVIDER BANNER
  // ============================================================================

  Widget _buildWaitingForProviderBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.hourglass_empty_rounded,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Waiting for Provider',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[800],
                  ),
                ),
                Text(
                  'Provider will scan and verify items. You\'ll be notified when ready.',
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  //  ACTION BUTTON
  // ============================================================================

  Widget _buildActionButton(
    JobsDetailsState state,
    JobsDetailsNotifier notifier,
    BuildContext context,
  ) {
    // Hide button if job is completed or cancelled
    if (state.isJobCompleted || !state.isJobActive) {
      return _buildCompletionBanner(state);
    }

    // Hide button if waiting for provider
    if (state.isWaitingForProvider) {
      return const SizedBox.shrink();
    }

    // Hide button if QR scan required (handled separately)
    if (state.requiresQrScan) {
      return const SizedBox.shrink();
    }

    // Show button only if rider action is required
    if (!state.requiresRiderAction) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: AppElevatedButton(
        onPressed: state.isUpdatingStatus
            ? null
            : () => _handleAction(notifier, state, context),
        // icon: state.isUpdatingStatus
        //     ? const SizedBox(
        //         width: 20,
        //         height: 20,
        //         child: CircularProgressIndicator(
        //           strokeWidth: 2,
        //           color: Colors.white,
        //         ),
        //       )
        //     : Icon(state.job?.checkPointStatusType.statusIcon),
        label: state.isUpdatingStatus
            ? 'Processing...'
            : state.currentActionLabel ?? 'Next Step',
      ),
    );
  }

  Widget _buildCompletionBanner(JobsDetailsState state) {
    final bool isCompleted = state.isJobCompleted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isCompleted ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isCompleted ? Colors.green : Colors.red).withValues(
            alpha: 0.3,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isCompleted ? Colors.green : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isCompleted ? 'Order Completed! 🎉' : 'Order Cancelled',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isCompleted ? Colors.green[800] : Colors.red[800],
                  ),
                ),
                Text(
                  isCompleted
                      ? 'Great job! Your payout will be processed soon.'
                      : 'This order is no longer active.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(
    JobsDetailsNotifier notifier,
    JobsDetailsState state,
    BuildContext context,
  ) {
    final JobsCheckPointType? checkpoint = state.job?.checkPointStatusType;

    switch (checkpoint) {
      // === Pickup Leg ===
      case JobsCheckPointType.pickupAssigned:
        notifier.markArrivedAtPickup(status: state.job?.status);
        break;
      case JobsCheckPointType.arrivedAtPickup:
        // _navigateToQrScanner(notifier, context);
        break;
      case JobsCheckPointType.itemsPickedUp:
        !state.isPickupLeg
            ? notifier.markAsCompleted()
            : notifier.markArrivedAtProvider();
        break;

      // === Delivery Leg ===
      case JobsCheckPointType.deliveryAssigned:
        notifier.markArrivedAtProviderForDelivery();
        break;
      case JobsCheckPointType.deliveryCollected:
        notifier.markCollectedFromProvider();
        break;
      case JobsCheckPointType.deliveryArrived:
        notifier.markDelivered();
        break;

      default:
        break;
    }
  }
}
