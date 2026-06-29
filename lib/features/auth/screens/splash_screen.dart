import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/videos.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/enums/rider_verify_identity_from_type.dart';
import '../../../shared/enums/role.dart';
import '../../../shared/widgets/asset_loader.dart';
import '../providers/auth_flow_providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SPLASH SCREEN BUILD");
    ref.listen<AsyncValue<AuthFlowDecision>>(authFlowProvider, (
      AsyncValue<AuthFlowDecision>? prev,
      AsyncValue<AuthFlowDecision> next,
    ) {
      next.whenData((AuthFlowDecision decision) {
        final GoRouter router = ref.read(appRouterProvider);

        switch (decision) {
          case GoToHomeDecision():
            final String path = switch (decision.role) {
              Role.user => RoutePaths.user,
              Role.rider => RoutePaths.rider,
              Role.provider => RoutePaths.provider,
            };
            router.pushReplacement(path);
          case GoToOnboardingDecision():
            router.pushReplacement(RoutePaths.onboarding);
          case GoToLoginDecision():
            router.pushReplacement(RoutePaths.signIn);
          case GoToRiderDocumentsDecision():
            router.pushReplacement(
              RoutePaths.verifyRiderHome,
              extra: RiderVerifyIdentityFromType.verify,
            );
        }
      });
    });

    // Show splash UI while deciding
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AssetLoader(
          assetPath: AppVideos.onboarding,
          width: context.screenWidth,
          height: context.screenHeight,
        ),
      ),
    );
  }
}
