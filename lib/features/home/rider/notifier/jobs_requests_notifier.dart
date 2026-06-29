// features/riders/jobs/notifiers/jobs_requests_notifier.dart

// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/home/rider/models/jobs_request_model.dart';
import 'package:drop_n_fresh/features/home/rider/state/jobs_requests_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobsRequestsNotifier extends AutoDisposeNotifier<JobsRequestsState> {
  late final ApiClient _apiClient;

  @override
  JobsRequestsState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchServiceRequests());
    return const JobsRequestsState(isLoading: true);
  }

  Future<void> _fetchServiceRequests({int page = 1}) async {
    final bool isLoadingMore = page > 1;

    state = state.copyWith(
      isLoading: !isLoadingMore,
      isLoadingMore: isLoadingMore,
      error: null,
    );

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.riderAvailableOrders,
            queryParameters: <String, dynamic>{
              'page': page.toString(),
              'limit': '10',
            },
          );

      final List<dynamic> ordersJson =
          (response['data'] as Map<String, dynamic>)['orders'] as List;
      final Map<String, dynamic> paginationJson =
          (response['data'] as Map<String, dynamic>)['pagination']
              as Map<String, dynamic>;

      final List<JobsRequestModel> newRequests = ordersJson
          .map(
            (orderJson) => JobsRequestModel.fromApiResponse(
              orderJson as Map<String, dynamic>,
            ),
          )
          .toList();

      final int totalPages = paginationJson['totalPages'] as int;
      final bool hasMore = (paginationJson['page'] as int) < totalPages;

      if (isLoadingMore) {
        state = state.copyWith(
          requests: <JobsRequestModel>[...state.requests, ...newRequests],
          page: page,
          hasMore: hasMore,
          isLoading: false,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(
          requests: newRequests,
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
      AppLogger().e(
        'Failed to fetch available jobs: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> refresh() async {
    await _fetchServiceRequests(page: 1);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) {
      return;
    }
    await _fetchServiceRequests(page: state.page + 1);
  }

  Future<void> acceptJob(String id) async{
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
        requests: state.requests
            .where((JobsRequestModel request) => request.id != id)
            .toList(),
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

  Future<void> cancelJob(String id) async{
    state = state.copyWith(
        requests: state.requests
            .where((JobsRequestModel request) => request.id != id)
            .toList(),
      );
  }
}
