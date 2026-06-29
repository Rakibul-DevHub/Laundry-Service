import 'package:drop_n_fresh/features/orders/provider/models/orders_details_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class OrdersDetailsState {
  final OrdersDetailsModel? order;
  final bool isLoading;
  final String? error;
  final bool isScanning;
  final dynamic scannedQrCode;

  const OrdersDetailsState({
    this.order,
    this.isLoading = false,
    this.error,
    this.isScanning = false,
    this.scannedQrCode,
  });

  OrdersDetailsState copyWith({
    OrdersDetailsModel? order,
    bool? isLoading,
    String? error,
    bool? isScanning,
    dynamic scannedQrCode,
  }) {
    return OrdersDetailsState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isScanning: isScanning ?? this.isScanning,
      scannedQrCode: scannedQrCode,
    );
  }
}
