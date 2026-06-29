import 'package:drop_n_fresh/core/services/notification_service.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'route_paths.dart';
import 'routes.dart';
import 'routes_helper.dart';

/// Central router configuration with role-based guards
///
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  return appRouter;
});

final GoRouter appRouter = GoRouter(
  navigatorKey: GlobalKey<NavigatorState>(),
  initialLocation: RoutePaths.initial,
  routes: <RouteBase>[
    // auth routes with onboarding list
    ...AuthRoutes.routes,

    ...ProfileRoutes.routes,

    ...OthersRoutes.routes,

    // Authenticated routes — grouped by role
    // user routes
    UserRoutes.userRoutes,
    // Rider Routes
    RiderRoutes.riderRoutes,
    // Provider routes
    ProviderRoutes.providerRoutes,
  ],
  redirect: RoutesHelper.globalRedirect,
);

void setupNotificationNavigation(WidgetRef ref, GoRouter router) {
  try {
    final NotificationService notificationService = ref.read(
      notificationServiceProvider,
    );

    notificationService.notificationTapStream.listen(
      (Map<String, dynamic> data) {
        AppLogger().i('NotificationService:: STREAM RECEIVED DATA: $data');

        final String type = data['type'] as String? ?? "Default Type";
        final String id = data['id'] as String? ?? "Default ID";

        AppLogger().i('NotificationService:: Navigating: $type && $id');
        // router.push(RoutePaths.support);
      },
      onError: (dynamic error) {
        AppLogger().e('NotificationService:: Stream error: $error');
      },
      onDone: () {
        AppLogger().i('NotificationService:: Stream closed');
      },
      cancelOnError: false,
    );
  } catch (e, stack) {
    AppLogger().e(
      'NotificationService:: setupNotificationNavigation ERROR: $e',
      error: e,
      stackTrace: stack,
    );
  }
}
