import 'package:flutter/foundation.dart';

import '../models/order_bag_model.dart';

@immutable
class OrderBagState {
  final BagDetails? orderBag;
  final bool isLoading;
  final bool isOrderLoading;
  final String? error;

  const OrderBagState({
    this.orderBag,
    this.isLoading = false,
    this.isOrderLoading = false,
    this.error,
  });

  OrderBagState copyWith({
    BagDetails? orderBag,
    bool? isLoading,
    bool? isOrderLoading,
    String? error,
  }) {
    return OrderBagState(
      orderBag: orderBag ?? this.orderBag,
      isLoading: isLoading ?? this.isLoading,
      isOrderLoading: isOrderLoading ?? this.isOrderLoading,
      error: error,
    );
  }
}
