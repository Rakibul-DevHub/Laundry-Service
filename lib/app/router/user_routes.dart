import 'package:drop_n_fresh/features/services/user/models/user_service_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens.dart';
import 'route_paths.dart';
import 'routes_helper.dart';

class UserRoutes {
  UserRoutes._();

  static GoRoute userRoutes = GoRoute(
    path: RoutePaths.user,
    builder: (BuildContext context, GoRouterState state) =>
        const BottomNavScreen(),
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.userOrderBagNoRole,
        builder: (BuildContext context, GoRouterState state) =>
            const BagOrderScreen(),
      ),

      GoRoute(
        path: RoutePaths.userOrdersDetailsNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final String? orderId = state.extra as String?;
          return UserOrderDetailsScreen(orderId: orderId ?? '');
        },
      ),
      GoRoute(
        path: RoutePaths.userServiceBookingNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final UserServiceModel service = state.extra as UserServiceModel;
          return UserServiceBookingScreen(service: service);
        },
      ),
      GoRoute(
        path: RoutePaths.userBagCheckoutNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final String? checkoutUrl = state.extra as String?;
          return BagCheckoutWebView(checkoutUrl: checkoutUrl ?? '');
        },
      ),
      GoRoute(
        path: RoutePaths.userServiceCheckoutNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final String? checkoutUrl = state.extra as String?;
          return ServiceCheckoutWebview(checkoutUrl: checkoutUrl ?? '');
        },
      ),
    ],
    redirect: RoutesHelper.guardRoleRedirect,
  );
}
