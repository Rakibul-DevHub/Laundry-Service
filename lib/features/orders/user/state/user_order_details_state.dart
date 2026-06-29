
import 'package:flutter/foundation.dart';
import '../models/user_order_details_model.dart';

@immutable
class UserOrderDetailsState {
  final UserOrderDetailsModel? orderDetails;
  final bool isLoading;
  final String? error;

  const UserOrderDetailsState({
    this.orderDetails,
    this.isLoading = false,
    this.error,
  });

  UserOrderDetailsState copyWith({
    UserOrderDetailsModel? orderDetails,
    bool? isLoading,
    String? error,
  }) {
    return UserOrderDetailsState(
      orderDetails: orderDetails ?? this.orderDetails,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
