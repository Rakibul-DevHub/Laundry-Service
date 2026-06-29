// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/earnings/models/earnings_model.dart';
import 'package:drop_n_fresh/features/earnings/notifier/stripe_connect_rider_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../models/earnings_summary_rider_model.dart';
import '../state/earnings_rider_state.dart';

class EarningsRiderNotifier extends AutoDisposeNotifier<EarningsRiderState> {
  late final ApiClient _apiClient;

  @override
  EarningsRiderState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() {
      _fetchSummary();
      _fetchEarnings();
    });
    return const EarningsRiderState(isLoading: true);
  }

  Future<void> _fetchSummary() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final EarningsRiderDashboardResponse response = await _apiClient
          .handleRequest<EarningsRiderDashboardResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.riderEarnings,
            fromJson: EarningsRiderDashboardResponse.fromJson,
          );
      state = state.copyWith(summary: response.data);
      if (response.data.onboardingPolicy != null) {
        ref
            .read(stripeConnectRiderProvider.notifier)
            .onBoardStatus(response.data.onboardingPolicy!.isFullyOnboarded);
      }
    } catch (e) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _fetchEarnings({int page = 1, bool isRefresh = false}) async {
    final bool isLoadingMore = page > 1;

    if (isRefresh) {
      state = state.copyWith(isRefreshing: true, error: null);
    } else if (!isLoadingMore) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.riderEarningsTransaction,
            queryParameters: <String, dynamic>{
              'page': page.toString(),
              'limit': '20',
            },
          );

      final List<dynamic> transactionsJson =
          (response['data'] as Map<String, dynamic>)['transactions'] as List;
      final Map<String, dynamic> paginationJson =
          (response['data'] as Map<String, dynamic>)['pagination']
              as Map<String, dynamic>;

      final List<EarningsModel> newEarnings = transactionsJson
          .map(
            (json) =>
                EarningsModel.fromApiResponse(json as Map<String, dynamic>),
          )
          .toList();

      final int totalPages = paginationJson['totalPages'] as int;
      final bool hasMore = (paginationJson['page'] as int) < totalPages;

      if (isRefresh) {
        state = state.copyWith(
          earnings: newEarnings,
          page: 1,
          hasMore: hasMore,
          isRefreshing: false,
          isLoading: false,
        );
      } else if (isLoadingMore) {
        //  Append for pagination
        state = state.copyWith(
          earnings: <EarningsModel>[...state.earnings, ...newEarnings],
          page: page,
          hasMore: hasMore,
          isLoading: false,
        );
      } else {
        //  Replace for fresh load
        state = state.copyWith(
          earnings: newEarnings,
          page: page,
          hasMore: hasMore,
          isLoading: false,
        );
      }
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
        isRefreshing: false,
      );
      AppLogger().e(
        'Failed to fetch earnings history: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> withdrawRequest(num amount) async {
    try {
      final Map<String, dynamic> response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.riderWithdraw,
        data: <String, num>{"amount": amount},
      );
      Toast.showSuccess(
        response['message'] as String? ?? "Withdraw request successful",
      );
    } catch (e) {
      Toast.showError(
        ExceptionHandler.errorMessage(e),
      );
    }
  }

  Future<void> refresh() async {
    await _fetchSummary();
    await _fetchEarnings(page: 1, isRefresh: true);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    // You can add logic to filter earnings by date here
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading || state.isRefreshing) {
      return;
    }
    await _fetchEarnings(page: state.page + 1);
  }
}
