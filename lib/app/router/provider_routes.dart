import 'package:drop_n_fresh/features/orders/provider/models/order_status_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens.dart';
import 'route_paths.dart';
import 'routes_helper.dart';

class ProviderRoutes {
  ProviderRoutes._();

  static GoRoute providerRoutes = GoRoute(
    path: RoutePaths.provider,
    builder: (BuildContext context, GoRouterState state) =>
        const BottomNavScreen(),
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.providerAllEarningsNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const EarningsAllScreen();
        },
      ),

      GoRoute(
        path: RoutePaths.providerBalanceNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const BalanceScreen();
        },
      ),

      GoRoute(
        path: RoutePaths.providerWithdrawNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const BalanceScreen();
        },
      ),
      GoRoute(
        path: RoutePaths.providerOrdersByStatusNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final OrderStatusType type = state.extra as OrderStatusType;
          return OrdersListScreenByStatus(
            type: type,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.providerOrdersDetailsByStatusNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final String orderId = state.extra as String;
          return OrdersDetailsByStatusScreen(
            orderId: orderId,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.createServiceNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const ProviderCreateServiceScreen();
        },
      ),
      GoRoute(
        path: RoutePaths.detailsServiceNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return ProviderServiceDetailsScreen(
            serviceId: state.extra as String,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.providerBusinessHoursNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const ProviderBusinessHoursScreen();
        },
      ),
    ],
    redirect: RoutesHelper.guardRoleRedirect,
  );
}
