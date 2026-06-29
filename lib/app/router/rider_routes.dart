import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/jobs/models/jobs_status_type.dart';
import '../../screens.dart';
import '../../shared/enums/rider_verify_identity_from_type.dart';
import 'route_paths.dart';
import 'routes_helper.dart';

class RiderRoutes {
  RiderRoutes._();

  static GoRoute riderRoutes = GoRoute(
    path: RoutePaths.rider,
    builder: (BuildContext context, GoRouterState state) =>
        const BottomNavScreen(),
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.verifyRiderHomeNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final RiderVerifyIdentityFromType? fromType =
              state.extra as RiderVerifyIdentityFromType?;
          return VerifyRiderIdentityHome(
            fromType: fromType ?? RiderVerifyIdentityFromType.profile,
          );
        },
      ),

      GoRoute(
        path: RoutePaths.verifyRiderNIDNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyRiderNidScreen();
        },
      ),
      GoRoute(
        path: RoutePaths.verifyRiderDrivingLicenseNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyRiderIdentityDrivingLicense();
        },
      ),
      GoRoute(
        path: RoutePaths.verifyRiderInsuranceInfoNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyRiderIdentityInsurance();
        },
      ),
      GoRoute(
        path: RoutePaths.verifyRiderVehicleNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyRiderIdentityVehicleInfo();
        },
      ),
      GoRoute(
        path: RoutePaths.verifyRiderSelfieNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyRiderIdentitySelfie();
        },
      ),

      GoRoute(
        path: RoutePaths.riderAllEarningsNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const EarningsAllScreen();
        },
      ),

      GoRoute(
        path: RoutePaths.riderBalanceNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const BalanceScreen();
        },
      ),

      GoRoute(
        path: RoutePaths.riderWithdrawNoRole,
        builder: (BuildContext context, GoRouterState state) {
          return const BalanceScreen();
        },
      ),

      GoRoute(
        path: RoutePaths.riderJobsByStatusNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final JobStatusType type = state.extra as JobStatusType;
          return JobsListScreenByStatus(
            type: type,
          );
        },
      ),

      GoRoute(
        path: RoutePaths.riderJobsDetailsNoRole,
        builder: (BuildContext context, GoRouterState state) {
          final String jobId = state.extra as String;
          return JobsDetailScreen(
            jobId: jobId,
          );
        },
      ),
    ],
    redirect: RoutesHelper.guardRoleRedirect,
  );
}
