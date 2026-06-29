import 'package:flutter/foundation.dart';

import '../models/jobs_request_model.dart';

@immutable
class JobsRequestsState {
  final List<JobsRequestModel> requests;
  final bool isLoading;
  final bool isLoadingMore;
  final Loading acceptLoading;
  final String? error;
  final bool hasMore;
  final int page;

  const JobsRequestsState({
    this.requests = const <JobsRequestModel>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.acceptLoading = const Loading(loading: false),
    this.error,
    this.hasMore = true,
    this.page = 1,
  });

  JobsRequestsState copyWith({
    List<JobsRequestModel>? requests,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    Loading? acceptLoading,
    bool? hasMore,
    int? page,
  }) {
    return JobsRequestsState(
      requests: requests ?? this.requests,
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
