import 'package:drop_n_fresh/features/services/user/models/user_service_booking_models.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserServiceBookingState {
  final UserServiceModel service;
  final int currentStep;
  final SelectedSchedule? schedule;
  final List<BookingProductItem> products;
  final List<String> selectedBagIds;
  final List<DeliveryInstruction> instructions;
  final String specialInstructions;
  final String? driverType;
  final bool isSubmitting;
  final String? error;

  const UserServiceBookingState({
    required this.service,
    this.currentStep = 0,
    this.schedule,
    this.products = const <BookingProductItem>[],
    this.selectedBagIds = const <String>[],
    this.instructions = const <DeliveryInstruction>[],
    this.specialInstructions = '',
    this.driverType,
    this.isSubmitting = false,
    this.error,
  });

  UserServiceBookingState copyWith({
    UserServiceModel? service,
    int? currentStep,
    SelectedSchedule? schedule,
    List<BookingProductItem>? products,
    List<String>? selectedBagIds,
    List<DeliveryInstruction>? instructions,
    String? specialInstructions,
    String? driverType,
    bool? isSubmitting,
    String? error,
  }) {
    return UserServiceBookingState(
      service: service ?? this.service,
      currentStep: currentStep ?? this.currentStep,
      schedule: schedule ?? this.schedule,
      products: products ?? this.products,
      selectedBagIds: selectedBagIds ?? this.selectedBagIds,
      instructions: instructions ?? this.instructions,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      driverType: driverType ?? this.driverType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  // Validation: Can proceed to next step?
  bool get canProceedToStep1 => schedule != null;
  bool get canProceedToStep2 =>
      products.isNotEmpty &&
      products.any((BookingProductItem p) => p.quantity > 0);
  bool get canProceedToStep3 =>
      selectedBagIds.isNotEmpty && instructions.isNotEmpty;
  bool get canProceedToStep4 => driverType != null;

  // Calculate totals
  num get productsTotal => products.fold<num>(
    0,
    (num sum, BookingProductItem p) => sum + (p.price * p.quantity),
  );

  int get totalItems => products.fold<int>(
    0,
    (int sum, BookingProductItem p) => sum + p.quantity,
  );
}
