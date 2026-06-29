import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'route_paths.dart';
import '../../screens.dart';
import '../../shared/enums/verify_email_type.dart';
import '../../shared/enums/role.dart';

class AuthRoutes {
  AuthRoutes._();
  static final List<GoRoute> routes = <GoRoute>[
    GoRoute(
      path: RoutePaths.initial,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.onboarding,
      builder: (BuildContext context, GoRouterState state) =>
          const OnboardingScreen(),
    ),
    GoRoute(
      path: RoutePaths.role,
      builder: (BuildContext context, GoRouterState state) =>
          const RoleSelectionScreen(),
    ),
    // auth
    GoRoute(
      path: RoutePaths.signIn,
      builder: (BuildContext context, GoRouterState state) =>
          const SignInScreen(),
    ),
    GoRoute(
      path: RoutePaths.signUp,
      builder: (BuildContext context, GoRouterState state) {
        final Role role = state.extra as Role;
        return SignUpScreen(role: role);
      },
    ),

    GoRoute(
      path: "${RoutePaths.verifyEmail}/:email",
      builder: (BuildContext context, GoRouterState state) {
        final String email = state.pathParameters['email']!;
        final VerifyEmailType verifyEmailType = state.extra as VerifyEmailType;
        return VerifyEmailScreen(email: email, type: verifyEmailType);
      },
    ),

    GoRoute(
      path: RoutePaths.resetPassword,
      builder: (BuildContext context, GoRouterState state) {
        final String token = state.extra as String;
        return ResetPasswordScreen(token: token);
      },
    ),

    // private routes for auth
    GoRoute(
      path: RoutePaths.changePassword,
      builder: (BuildContext context, GoRouterState state) {
        return const ChangePasswordScreen();
      },
    ),

    // private routes for auth
    GoRoute(
      path: RoutePaths.deleteAccount,
      builder: (BuildContext context, GoRouterState state) {
        return const DeleteAccountScreen();
      },
    ),
  ];
}
