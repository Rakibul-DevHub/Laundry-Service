// features/earnings/notifiers/stripe_connect_notifier.dart

// ignore_for_file: avoid_dynamic_calls

import 'package:drop_n_fresh/app/router/app_router.dart';
import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/features/earnings/providers/earnings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/utils/app_logger.dart';

class StripeConnectState {
  final bool isLoading;
  final String? error;

  final bool isConnected;

  const StripeConnectState({
    this.isLoading = false,
    this.error,
    this.isConnected = false,
  });

  StripeConnectState copyWith({
    bool? isLoading,
    String? error,
    bool? isConnected,
  }) {
    return StripeConnectState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class StripeConnectNotifier extends AutoDisposeNotifier<StripeConnectState> {
  late final ApiClient _apiClient;

  @override
  StripeConnectState build() {
    _apiClient = ref.read(apiClientProvider);
    return const StripeConnectState();
  }

  Future<void> onBoardStatus(bool onboard) async {
    state = state.copyWith(isConnected: onboard);
  }

  Future<void> getOnboardingUrl() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.riderStripeOnboard,
          );
      final String? onboardingUrl = response['data']?['url'] as String?;

      state = state.copyWith(
        isLoading: false,
      );

      if (onboardingUrl != null && onboardingUrl.isNotEmpty) {
        await ref
            .read(appRouterProvider)
            .push(
              RoutePaths.onboardScreen,
              extra: onboardingUrl,
            );
        ref.read(riderEarningsProvider.notifier).refresh();
      }
    } catch (e, stack) {
      state = state.copyWith(
        error: 'Failed to start onboarding: ${e.toString()}',
        isLoading: false,
      );
      AppLogger().e('Stripe onboarding error: $e', error: e, stackTrace: stack);
    }
  }

  Future<void> refresh() async {}
}

final AutoDisposeNotifierProvider<StripeConnectNotifier, StripeConnectState>
stripeConnectRiderProvider =
    NotifierProvider.autoDispose<StripeConnectNotifier, StripeConnectState>(
      StripeConnectNotifier.new,
    );
