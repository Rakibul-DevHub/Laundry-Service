import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/services/user/models/order_request_models.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_booking_models.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_model.dart';
import 'package:drop_n_fresh/features/services/user/notifier/user_service_booking_notifier.dart';
import 'package:drop_n_fresh/features/services/user/state/user_service_booking_state.dart';
import 'package:drop_n_fresh/features/services/user/widgets/booking_checkpoints/step1_schedule.dart';
import 'package:drop_n_fresh/features/services/user/widgets/booking_checkpoints/step2_products.dart';
import 'package:drop_n_fresh/features/services/user/widgets/booking_checkpoints/step3_bag_instructions.dart';
import 'package:drop_n_fresh/features/services/user/widgets/booking_checkpoints/step4_checkout.dart';
import 'package:drop_n_fresh/features/services/user/widgets/booking_progress_indicator.dart';
import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserServiceBookingScreen extends ConsumerWidget {
  final UserServiceModel service;

  const UserServiceBookingScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserServiceBookingState state = ref.watch(
      userServiceBookingProvider(service),
    );
    final UserServiceBookingNotifier notifier = ref.read(
      userServiceBookingProvider(service).notifier,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Book ${service.serviceCategory.name}',
        titleAlignment: TitleAlignment.left,
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
              // Progress Indicator
              BookingProgressIndicator(currentStep: state.currentStep),
              const SizedBox(height: 16),

              Expanded(
                child: _buildCurrentStep(state, notifier, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(
    UserServiceBookingState state,
    UserServiceBookingNotifier notifier,
    WidgetRef ref,
  ) {
    switch (state.currentStep) {
      case 0:
        return Step1Schedule(
          providerId: service.providerId,
          onScheduleSelected: notifier.setSchedule,
          onNext: notifier.nextStep,
        );
      case 1:
        return Step2Products(
          onPrevious: notifier.previousStep,
          serviceId: state.service.serviceId,
          providerId: state.service.providerId,
          onSubmit: (List<BookingProductItem> selectedItems) {
            ref
                .read(userServiceBookingProvider(service).notifier)
                .addSelectedProducts(selectedItems);
            notifier.nextStep();
          },
        );
      case 2:
        return Step3BagInstructions(
          selectedBagIds: state.selectedBagIds,

          onBagsSelected: (List<String> bagIds) {
            ref
                .read(userServiceBookingProvider(service).notifier)
                .selectBags(bagIds);
          },

          instructions: state.instructions,
          specialInstructions: state.specialInstructions,
          onInstructionToggled: notifier.toggleInstruction,
          onSpecialInstructionsChanged: notifier.setSpecialInstructions,
          onNext: notifier.nextStep,
          onPrevious: notifier.previousStep,
        );
      case 3:
        return Step4Checkout(
          state: state,
          service: service,
          onPrevious: notifier.previousStep,
          isSubmitting: state.isSubmitting,
          onGetPriceSummary: (PlaceOrderRequest request) async {
            return await ref
                .read(userServiceBookingProvider(service).notifier)
                .getPriceSummary(request);
          },
          onProceedToCheckout: (String orderId) {
            ref
                .read(userServiceBookingProvider(service).notifier)
                .orderCheckout(orderId);
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
