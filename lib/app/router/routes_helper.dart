import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/app_logger.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../shared/enums/role.dart';
import 'route_paths.dart';

class RoutesHelper {
  RoutesHelper._();

  // check the location is under public route or not
  static bool isPublicRoute(String location) {
    return publicRoutes.any((String route) => location.startsWith(route));
  }

  // public routes
  static const Set<String> publicRoutes = <String>{
    RoutePaths.initial,
    RoutePaths.onboarding,
    RoutePaths.signIn,
    RoutePaths.signUp,
    RoutePaths.resetPassword,
    RoutePaths.role,
    RoutePaths.verifyEmail,
  };

  static Role? pathSegmentToRole(String segment) {
    switch (segment) {
      case 'user':
        return Role.user;
      case 'rider':
        return Role.rider;
      case 'provider':
        return Role.provider;
      default:
        return null;
    }
  }

  static String roleToHomePath(Role role) {
    switch (role) {
      case Role.user:
        return RoutePaths.user;
      case Role.rider:
        return RoutePaths.rider;
      case Role.provider:
        return RoutePaths.provider;
    }
  }

  static String? guardRoleRedirect(BuildContext context, GoRouterState state) {
    final Result Function<Result>(ProviderListenable<Result>) ref =
        ProviderScope.containerOf(context).read;
    final AuthState authState = ref(authProvider);

    AppLogger().d(
      'Role Guard isLoggedIn: ${authState.isLoggedIn}',
    );

    if (!authState.isLoggedIn) {
      return RoutePaths.signIn;
    }

    AppLogger().d(
      'Role Guard role: ${authState.role}',
    );
    final Role? userRole = authState.role;
    if (userRole == null) {
      return RoutePaths.signIn;
    }

    // Extract current path segment
    final String firstSegment = state.uri.pathSegments.firstOrNull ?? '';

    // Map segment to expected role
    final Role? expectedRole = pathSegmentToRole(firstSegment);

    AppLogger().d(
      'Role Guard: user=$userRole, expected=$expectedRole, path=${state.uri.path}',
    );

    if (expectedRole == null) {
      // Unknown route — let go_router handle 404
      return null;
    }

    if (userRole != expectedRole) {
      // Redirect to their correct home
      return roleToHomePath(userRole);
    }

    return null; // allow access
  }

  static String? globalRedirect(BuildContext context, GoRouterState state) {
    AppLogger().d("GLOBAL REDIRECT");

    final Result Function<Result>(ProviderListenable<Result>) ref =
        ProviderScope.containerOf(context).read;
    final bool isLoggedIn = ref(authProvider).isLoggedIn;
    final String location = state.uri.path;

    AppLogger().d("GLOBAL REDIRECT location : $location");

    // Allow public routes always
    AppLogger().d(
      "GLOBAL REDIRECT publicRoutes contains : ${isPublicRoute(location)}",
    );

    if (isPublicRoute(location)) {
      return null;
    }

    AppLogger().d("GLOBAL REDIRECT isLoggedIn : $isLoggedIn");
    // Block private routes if not logged in
    if (!isLoggedIn) {
      return RoutePaths.signIn;
    }

    return null;
  }
}
