import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens.dart';
import 'route_paths.dart';

class ProfileRoutes {
  ProfileRoutes._();
  static final List<GoRoute> routes = <GoRoute>[
    GoRoute(
      path: RoutePaths.termsCondition,
      builder: (BuildContext context, GoRouterState state) =>
          const TermsAndConditionsScreen(),
    ),
    GoRoute(
      path: RoutePaths.privacyPolicy,
      builder: (BuildContext context, GoRouterState state) =>
          const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: RoutePaths.support,
      builder: (BuildContext context, GoRouterState state) =>
          const SupportScreen(),
    ),
    // auth
    GoRoute(
      path: RoutePaths.aboutUs,
      builder: (BuildContext context, GoRouterState state) =>
          const AboutUsScreen(),
    ),
    GoRoute(
      path: RoutePaths.contactUs,
      builder: (BuildContext context, GoRouterState state) {
        return const ContactUsScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.riderProfileInfo,
      builder: (BuildContext context, GoRouterState state) {
        return const RiderProfileInfoScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.riderProfileEdit,
      builder: (BuildContext context, GoRouterState state) {
        return const RiderProfileEditScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.userProfileInfo,
      builder: (BuildContext context, GoRouterState state) {
        return const UserProfileInfoScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.userAddressInfo,
      builder: (BuildContext context, GoRouterState state) {
        return const UserAddressInfoScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.userAddressAdd,
      builder: (BuildContext context, GoRouterState state) {
        return const UserAddAddressScreen();
      },
    ),

    GoRoute(
      path: RoutePaths.userProfileEdit,
      builder: (BuildContext context, GoRouterState state) {
        return const UserProfileEditScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.providerProfileInfo,
      builder: (BuildContext context, GoRouterState state) {
        return const ProviderProfileInfoScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.providerProfileEdit,
      builder: (BuildContext context, GoRouterState state) {
        return const ProviderProfileEditScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.notification,
      builder: (BuildContext context, GoRouterState state) {
        return const NotificationsScreen(
          isSeparatedScreen: true,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.updateLocation,
      builder: (BuildContext context, GoRouterState state) {
        return const UpdateLocationScreen();
      },
    ),
  ];
}
