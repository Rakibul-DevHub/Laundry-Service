// features/riders/jobs/notifiers/jobs_notifier.dart

// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/utils/app_logger.dart';
import '../models/jobs_model.dart';
import '../models/jobs_status_type.dart';
import '../state/jobs_state.dart';

class JobsNotifier extends AutoDisposeFamilyNotifier<JobsState, JobStatusType> {
  late final ApiClient _apiClient;

  @override
  JobsState build(JobStatusType type) {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchJobs());
    return JobsState(type: type);
  }

  Future<void> _fetchJobs({int page = 1}) async {
    final bool isLoadingMore = page > 1;

    state = state.copyWith(
      isLoading: !isLoadingMore,
      isLoadingMore: isLoadingMore,
      error: null,
    );

    try {
      final String? statusFilter = _mapEnumToBackendStatus(state.type);

      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.riderOrders,
            queryParameters: <String, dynamic>{
              'page': page.toString(),
              'limit': '10',
              if (statusFilter != null) 'status': statusFilter,
            },
          );
      final List<dynamic> ordersJson =
          (response['data'] as Map<String, dynamic>)['orders'] as List;
      final Map<String, dynamic> paginationJson =
          (response['data'] as Map<String, dynamic>)['pagination']
              as Map<String, dynamic>;

      final List<JobsModel> newJobs = ordersJson
          .map(
            (orderJson) =>
                JobsModel.fromApiResponse(orderJson as Map<String, dynamic>),
          )
          .toList();

      final int totalPages = paginationJson['totalPages'] as int;
      final bool hasMore = (paginationJson['page'] as int) < totalPages;

      if (isLoadingMore) {
        //  Append for pagination
        state = state.copyWith(
          orders: <JobsModel>[...state.orders, ...newJobs],
          page: page,
          hasMore: hasMore,
          isLoading: false,
          isLoadingMore: false,
        );
      } else {
        //  Replace for fresh load
        state = state.copyWith(
          orders: newJobs,
          page: page,
          hasMore: hasMore,
          isLoading: false,
          isLoadingMore: false,
        );
      }
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
        isLoadingMore: false,
      );
      AppLogger().e('Failed to fetch jobs: $e', error: e, stackTrace: stack);
    }
  }

  String? _mapEnumToBackendStatus(JobStatusType type) {
    switch (type) {
      case JobStatusType.newOrders:
        return 'PENDING';
      case JobStatusType.ongoingOrders:
        return 'PICKUP_RIDER_ASSIGNED,DELIVERY_RIDER_ASSIGNED,PICKED_UP,RECEIVED_AT_PROVIDER,IN_PROCESSING,OUT_FOR_DELIVERY,ARRIVED_AT_PICKUP,ARRIVED_AT_DROPOFF,ARRIVED_AT_PROVIDER';
      // AWAITING_DELIVERY_RIDER,
      // READY_FOR_DELIVERY,
      case JobStatusType.completedOrders:
        return 'DELIVERED,SELF_PICKED_UP';
      case JobStatusType.canceledOrders:
        return 'CANCELLED';
    }
  }

  Future<void> refresh() async {
    await _fetchJobs(page: 1);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) {
      return;
    }
    await _fetchJobs(page: state.page + 1);
  }

  Future<void> acceptJob(String id) async {
    try {
      state = state.copyWith(
        acceptLoading: Loading(loading: true, orderId: id),
      );
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.post,
            endpoint: '${ApiEndpoints.riderOrders}/$id/accept',
          );

      state = state.copyWith(
        orders: state.orders.where((JobsModel job) => job.id != id).toList(),
      );
      Toast.showSuccess(
        response['message'] as String? ?? 'Job accepted',
      );
    } catch (e, stack) {
      AppLogger().e('Failed to accept order: $e', error: e, stackTrace: stack);
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(
        acceptLoading: Loading(loading: false, orderId: id),
      );
    }
  }

  Future<void> cancelJob(String id) async {
    state = state.copyWith(
      orders: state.orders.where((JobsModel job) => job.id != id).toList(),
    );
  }
}
