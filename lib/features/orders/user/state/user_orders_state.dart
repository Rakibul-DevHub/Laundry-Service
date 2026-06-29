// features/orders/user/state/user_orders_state.dart

import 'package:flutter/foundation.dart';

import '../models/user_order_model.dart';

@immutable
class UserOrdersState {
  final List<UserOrderModel> orders;
  final bool isLoading;
  final bool isLoadingMore; // For pagination
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const UserOrdersState({
    this.orders = const <UserOrderModel>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = true,
  });

  UserOrdersState copyWith({
    List<UserOrderModel>? orders,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return UserOrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
