import 'package:flutter/foundation.dart';

import '../models/order_status_type.dart';
import '../models/orders_model.dart';

@immutable
class OrdersState {
  final List<OrdersModel> orders;
  final OrderStatusType type;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final Loading cancelLoading;
  final Loading acceptLoading;
  final Loading markAsProcessingLoading;
  final Loading markAsReadyForDeliveryLoading;
  final Loading readyToReceiveDelivery;
  final int page;

  const OrdersState({
    this.orders = const <OrdersModel>[],
    this.isLoading = false,
    this.error,
    required this.type,
    this.hasMore = true,
    this.page = 1,
    this.cancelLoading = const Loading(loading: false),
    this.acceptLoading = const Loading(loading: false),
    this.markAsProcessingLoading = const Loading(loading: false),
    this.markAsReadyForDeliveryLoading = const Loading(loading: false),
    this.readyToReceiveDelivery = const Loading(loading: false),
  });

  OrdersState copyWith({
    List<OrdersModel>? orders,
    OrderStatusType? type,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    Loading? cancelLoading,
    Loading? acceptLoading,
    Loading? markAsProcessingLoading,
    Loading? markAsReadyForDeliveryLoading,
    Loading? readyToReceiveDelivery,
  }) {
    return OrdersState(
      type: type ?? this.type,
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      cancelLoading: cancelLoading ?? this.cancelLoading,
      acceptLoading: acceptLoading ?? this.acceptLoading,
      markAsProcessingLoading:
          markAsProcessingLoading ?? this.markAsProcessingLoading,
      markAsReadyForDeliveryLoading:
          markAsReadyForDeliveryLoading ?? this.markAsReadyForDeliveryLoading,
      readyToReceiveDelivery:
          readyToReceiveDelivery ?? this.readyToReceiveDelivery,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class Loading {
  final bool loading;
  final String? orderId;
  const Loading({
    required this.loading,
    this.orderId,
  });
}
