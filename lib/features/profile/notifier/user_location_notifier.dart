import 'package:drop_n_fresh/features/home/user/notifier/default_location_notifier.dart';
import 'package:drop_n_fresh/features/profile/model/user_location_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../app/toast/toast.dart';
import '../../../core/utils/app_logger.dart';
import '../state/user_location_state.dart';

class UserLocationNotifier extends AutoDisposeNotifier<UserLocationState> {
  late final ApiClient _apiClient;
  @override
  UserLocationState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => fetchSavedLocations());
    return const UserLocationState(isLoading: true);
  }

  Future<void> fetchSavedLocations() async {
    // if (_currentUserId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final UserLocationsResponse response = await _apiClient
          .handleRequest<UserLocationsResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.userLocations,
            fromJson: UserLocationsResponse.fromJson,
          );

      if (!response.success) {
        throw Exception(response.message);
      }

      // Sort: default first, then by lastUsed
      final List<UserLocation> sorted = List<UserLocation>.from(response.data)
        ..sort((UserLocation a, UserLocation b) {
          if (a.isDefault && !b.isDefault) {
            return -1;
          }
          if (!a.isDefault && b.isDefault) {
            return 1;
          }
          if (a.lastUsed == null && b.lastUsed == null) {
            return 0;
          }
          if (a.lastUsed == null) {
            return 1;
          }
          if (b.lastUsed == null) {
            return -1;
          }
          return b.lastUsed!.compareTo(a.lastUsed!);
        });

      state = state.copyWith(
        savedLocations: sorted,
        isLoading: false,
      );
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
      );
      AppLogger().e(
        'Failed to fetch locations: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> searchLocations(String query) async {
    if (query.trim().length < 2) {
      state = state.copyWith(
        searchResults: <SearchedLocation>[],
        isSearching: false,
      );
      return;
    }

    state = state.copyWith(isSearching: true, searchError: null);

    try {
      final LocationSearchResponse response = await _apiClient
          .handleRequest<LocationSearchResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.userLocationsSearch,
            fromJson: LocationSearchResponse.fromJson,
            queryParameters: <String, dynamic>{'query': query},
          );

      if (!response.success) {
        throw Exception(response.message);
      }

      state = state.copyWith(
        searchResults: response.data,
        isSearching: false,
      );
    } catch (e) {
      state = state.copyWith(
        searchError: ExceptionHandler.errorMessage(e),
        isSearching: false,
      );
    }
  }

  Future<bool> saveLocation(SaveLocationRequest request) async {
    // if (_currentUserId == null) return false;

    state = state.copyWith(isSaving: true, error: null);

    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.userLocationsSave,
        data: request.toJson(),
      );

      Toast.showSuccess('Location saved successfully');

      await fetchSavedLocations();

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isSaving: false,
      );
      Toast.showError(ExceptionHandler.errorMessage(e));
      return false;
    }
  }

  Future<bool> setDefaultLocation(String locationId) async {
    state = state.copyWith(isUpdating: true);

    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.patch,
        endpoint: '${ApiEndpoints.locations}/$locationId/default',
      );
      await fetchSavedLocations();
      ref.read(defaultLocationProvider.notifier).refresh();
      state = state.copyWith(isUpdating: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isUpdating: false,
      );
      AppLogger().e(ExceptionHandler.errorMessage(e), error: e);
      Toast.showError(ExceptionHandler.errorMessage(e));
      return false;
    }
  }

  Future<bool> deleteLocation(String locationId) async {
    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.delete,
        endpoint: '${ApiEndpoints.locations}/$locationId',
      );
      await fetchSavedLocations();
      return true;
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      return false;
    }
  }

  void clearSearch() {
    state = state.copyWith(
      searchResults: <SearchedLocation>[],
      searchError: null,
      isSearching: false,
    );
  }

  Future<void> refresh() async {
    await fetchSavedLocations();
  }
}

final AutoDisposeNotifierProvider<UserLocationNotifier, UserLocationState>
userLocationProvider =
    NotifierProvider.autoDispose<UserLocationNotifier, UserLocationState>(
      UserLocationNotifier.new,
    );
