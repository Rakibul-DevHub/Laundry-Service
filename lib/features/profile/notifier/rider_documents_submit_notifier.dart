import 'package:drop_n_fresh/features/auth/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/router/app_router.dart';
import '../../../app/router/route_paths.dart';
import '../../../app/toast/toast.dart';
import '../../../core/utils/app_logger.dart';
import '../state/rider_documents_submit_state.dart';

class RiderDocumentsSubmitNotifier
    extends AutoDisposeNotifier<RiderDocumentsSubmitState> {
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;
  @override
  RiderDocumentsSubmitState build() {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);
    return const RiderDocumentsSubmitState();
  }

  Future<void> submitDocuments() async {
    state = state.copyWith(isSubmitting: true);

    try {
      final Map<String, dynamic> response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.riderProfileDocumentsSubmit,
      );
      Toast.showSuccess(response['message'] as String);
      await ref.read(authProvider.notifier).riderDocumentsSubmit();
      _appRouter.go(RoutePaths.rider);
    } catch (e) {
      AppLogger().d(ExceptionHandler.errorMessage(e));
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
