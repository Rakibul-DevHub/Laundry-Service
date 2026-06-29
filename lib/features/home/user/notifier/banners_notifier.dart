// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/home/user/state/banners_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/banner_model.dart';

class BannersNotifier extends AutoDisposeNotifier<BannersState> {
  late final ApiClient _apiClient;

  @override
  BannersState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchBanners());
    return const BannersState(isLoading: true);
  }

  Future<void> _fetchBanners() async {
    state = const BannersState(isLoading: true);

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.banners,
          );

      final List<dynamic> bannersJson = response['data'] as List;
      final List<BannerModel> banners = bannersJson
          .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
          .toList();

      state = BannersState(
        banners: banners,
        isLoading: false,
        currentPage: banners.isNotEmpty ? 0 : -1,
      );
    } catch (e, stack) {
      state = BannersState(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
      );
      AppLogger().e('Failed to fetch banners: $e', error: e, stackTrace: stack);
    }
  }

  /// Refresh banners
  Future<void> refresh() async => await _fetchBanners();

  /// Update current page (for carousel)
  void updatePage(int page) {
    state = state.copyWith(currentPage: page);
  }
}

final AutoDisposeNotifierProvider<BannersNotifier, BannersState>
bannersProvider = NotifierProvider.autoDispose<BannersNotifier, BannersState>(
  BannersNotifier.new,
);
