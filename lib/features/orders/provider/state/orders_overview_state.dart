import 'package:flutter/foundation.dart';

import '../models/orders_overview_model.dart';


@immutable
class OrdersOverviewState {
  final OrdersOverviewModel? overview;
  final bool isLoading;
  final String? error;

  const OrdersOverviewState({
    this.overview,
    this.isLoading = false,
    this.error,
  });

  OrdersOverviewState copyWith({
    OrdersOverviewModel? overview,
    bool? isLoading,
    String? error,
  }) {
    return OrdersOverviewState(
      overview: overview ?? this.overview,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
