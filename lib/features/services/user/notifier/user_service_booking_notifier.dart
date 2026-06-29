import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/app/router/app_router.dart';
import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/bags/models/bag_model.dart';
import 'package:drop_n_fresh/features/orders/user/providers/order_user.dart';
import 'package:drop_n_fresh/features/services/user/models/order_confirmation_model.dart';
import 'package:drop_n_fresh/features/services/user/models/order_request_models.dart';
import 'package:drop_n_fresh/features/services/user/models/service_checkout_response_model.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_booking_models.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_model.dart';
import 'package:drop_n_fresh/features/services/user/state/user_service_booking_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserServiceBookingNotifier
    extends
        AutoDisposeFamilyNotifier<UserServiceBookingState, UserServiceModel> {
  @override
  UserServiceBookingState build(UserServiceModel service) {
    return UserServiceBookingState(
      service: service,
      instructions: DeliveryInstruction.defaultInstructions,
      products: const <BookingProductItem>[],
    );
  }

  // Step 1: Set Schedule
  void setSchedule(DateTime date, String timeSlot) {
    state = state.copyWith(
      schedule: SelectedSchedule(date: date, timeSlot: timeSlot),
    );
  }

  // Step 2: Update Product selection
  void addSelectedProducts(List<BookingProductItem> selectedItems) {
    state = state.copyWith(products: selectedItems);
  }

  // Step 3: Select Bag
  void selectBags(List<String> bagIds) {
    state = state.copyWith(selectedBagIds: bagIds);
  }

  List<BagModel> getSelectedBags(List<BagModel> allBags) {
    return allBags
        .where((BagModel bag) => state.selectedBagIds.contains(bag.id))
        .toList();
  }

  // Step 3: Toggle Instruction
  void toggleInstruction(String instructionId) {
    final List<DeliveryInstruction> updated = state.instructions.map((
      DeliveryInstruction inst,
    ) {
      if (inst.id == instructionId) {
        return inst.copyWith(isSelected: !inst.isSelected);
      }
      return inst.copyWith(isSelected: false);
    }).toList();

    state = state.copyWith(instructions: updated);
  }

  // Step 3: Set Special Instructions
  void setSpecialInstructions(String instructions) {
    state = state.copyWith(specialInstructions: instructions);
  }

  // Step 4: Select Driver Type
  void selectDriverType(String type) {
    state = state.copyWith(driverType: type);
  }

  // Next Step
  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  // Previous Step
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // Go to Specific Step (with validation)
  void goToStep(int step) {
    if (step < 0 || step > 3) {
      return;
    }
    if (step == 1 && !state.canProceedToStep1) {
      return;
    }
    if (step == 2 && !state.canProceedToStep2) {
      return;
    }
    if (step == 3 && !state.canProceedToStep3) {
      return;
    }

    state = state.copyWith(currentStep: step);
  }

  Future<OrderConfirmationResponse?> getPriceSummary(
    PlaceOrderRequest request,
  ) async {
    try {
      final OrderConfirmationResponse response = await ref
          .read(apiClientProvider)
          .handleRequest<OrderConfirmationResponse>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.userServiceOrders,
            fromJson: OrderConfirmationResponse.fromJson,
            data: request.toJson(),
          );
      return response;
    } catch (e, stack) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      AppLogger().e(
        'Failed to get price summary: $e',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<void> orderCheckout(
    String orderId,
  ) async {
    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final ServiceCheckoutResponseModel response = await ref
          .read(apiClientProvider)
          .handleRequest<ServiceCheckoutResponseModel>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.userServiceCheckout(orderId),
            fromJson: ServiceCheckoutResponseModel.fromJson,
          );

      state = state.copyWith(
        isSubmitting: false,
      );

      await ref
          .read(appRouterProvider)
          .push(
            RoutePaths.userServiceCheckout,
            extra: response.data.checkoutUrl,
          );
      ref.read(userOrdersProvider.notifier).refresh();
    } catch (e, stack) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      AppLogger().e('Failed to place order: $e', error: e, stackTrace: stack);
      state = state.copyWith(
        isSubmitting: false,
      );
    }
  }

  void reset() {
    state = UserServiceBookingState(
      service: state.service,
      instructions: DeliveryInstruction.defaultInstructions,
      products: state.products,
    );
  }
}

final AutoDisposeNotifierProviderFamily<
  UserServiceBookingNotifier,
  UserServiceBookingState,
  UserServiceModel
>
userServiceBookingProvider =
    AutoDisposeNotifierProvider.family<
      UserServiceBookingNotifier,
      UserServiceBookingState,
      UserServiceModel
    >(
      UserServiceBookingNotifier.new,
    );
