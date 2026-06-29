import 'package:flutter/foundation.dart';

import '../models/service_request_model.dart';

@immutable
class ServiceRequestsState {
  final List<ServiceRequestModel> requests;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;

  const ServiceRequestsState({
    this.requests = const <ServiceRequestModel>[],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
  });

  ServiceRequestsState copyWith({
    List<ServiceRequestModel>? requests,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
  }) {
    return ServiceRequestsState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
