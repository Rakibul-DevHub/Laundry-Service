// features/services/user/notifiers/user_services_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/user_service_model.dart';
import '../state/user_services_state.dart';

class UserServicesNotifier extends AutoDisposeNotifier<UserServicesState> {
  late final ApiClient _apiClient;

  @override
  UserServicesState build() {
    _apiClient = ref.read(apiClientProvider);
    // Auto-fetch on init
    Future<dynamic>.microtask(() => _fetchUserServices());
    return const UserServicesState(isLoading: true);
  }

  Future<void> _fetchUserServices({int page = 1}) async {
    // If loading more, don't reset existing data
    final bool isLoadingMore = page > 1;

    state = state.copyWith(
      isLoading: !isLoadingMore,
      isLoadingMore: isLoadingMore,
      error: null,
    );

    try {
      final UserServiceResponse response = await _apiClient
          .handleRequest<UserServiceResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.services,
            fromJson: UserServiceResponse.fromJson,
            queryParameters: <String, dynamic>{
              'page': page.toString(),
              'limit': '10',
            },
          );
      final List<UserServiceModel> newServices = response.data.services;

      if (isLoadingMore) {
        state = state.copyWith(
          services: <UserServiceModel>[...state.services, ...newServices],
          currentPage: page,
          totalPages: response.data.pagination.totalPages,
          isLoadingMore: false,
        );
      } else {
        // Replace for fresh load
        state = state.copyWith(
          services: newServices,
          currentPage: page,
          totalPages: response.data.pagination.totalPages,
          isLoading: false,
        );
      }
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
        isLoadingMore: false,
      );
      AppLogger().e(
        'Failed to fetch services: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  // Public method to refresh from page 1
  Future<void> refresh() async {
    await _fetchUserServices(page: 1);
  }

  // Public method to load more (pagination)
  Future<void> loadMore() async {
    if (state.currentPage >= state.totalPages || state.isLoadingMore) {
      return;
    }
    await _fetchUserServices(page: state.currentPage + 1);
  }

  // Optional: Filter by category
  Future<void> filterByCategory(String categoryId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final UserServiceResponse response = await _apiClient
          .handleRequest<UserServiceResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.services,
            fromJson: UserServiceResponse.fromJson,
            queryParameters: <String, dynamic>{
              'categoryId': categoryId,
              'page': '1',
              'limit': '10',
            },
          );
      state = state.copyWith(
        services: response.data.services,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
      );
    }
  }
}
