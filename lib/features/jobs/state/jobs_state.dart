import 'package:flutter/foundation.dart';

import '../models/jobs_model.dart';
import '../models/jobs_status_type.dart';

@immutable
class JobsState {
  final List<JobsModel> orders;
  final JobStatusType type;
  final bool isLoading;
  final bool isLoadingMore;
  final Loading acceptLoading;

  final String? error;
  final bool hasMore;
  final int page;

  const JobsState({
    this.orders = const <JobsModel>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.acceptLoading = const Loading(loading: false),
    this.error,
    required this.type,
    this.hasMore = true,
    this.page = 1,
  });

  JobsState copyWith({
    List<JobsModel>? orders,
    JobStatusType? type,
    bool? isLoading,
    bool? isLoadingMore,
    Loading? acceptLoading,
    String? error,
    bool? hasMore,
    int? page,
  }) {
    return JobsState(
      type: type ?? this.type,
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      acceptLoading: acceptLoading ?? this.acceptLoading,
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
