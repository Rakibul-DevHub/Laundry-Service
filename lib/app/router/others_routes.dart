import 'package:drop_n_fresh/features/jobs/models/jobs_details_model.dart';
import 'package:drop_n_fresh/features/message/models/conversation_model.dart';
import 'package:drop_n_fresh/features/orders/provider/models/order_status_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens.dart';
import 'route_paths.dart';

class OthersRoutes {
  OthersRoutes._();
  static final List<GoRoute> routes = <GoRoute>[
    GoRoute(
      path: RoutePaths.conversations,
      builder: (BuildContext context, GoRouterState state) {
        return const ConversationsScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.onboardScreen,
      builder: (BuildContext context, GoRouterState state) {
        final String? checkoutUrl = state.extra as String?;
        return OnboardWebview(checkoutUrl: checkoutUrl ?? '');
      },
    ),
    GoRoute(
      path: RoutePaths.jobMapScreen,
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        final JobsDetailsModel job = data['job'] as JobsDetailsModel;
        final bool isPickupLeg = data['isPickupLeg'] as bool;
        return JobMapScreen(
          job: job,
          isPickupLeg: isPickupLeg,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.jobScanQrScreen,
      builder: (BuildContext context, GoRouterState state) {
        final String jobId = state.extra as String;
        return JobQrScannerScreen(
          jobId: jobId,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.orderScanQrScreen,
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        final String orderId = data['orderId'] as String;
        final OrderStatusType status = data['status'] as OrderStatusType;
        return ProviderQrScannerScreen(
          orderId: orderId,
          status: status,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.chat,
      name: 'chat',
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return ChatScreen(
          conversationId: data['conversationId'] as String,
          receiverId: data['receiverId'] as String,
          conversation: data['conversation'] as ConversationModel?,
        );
      },
    ),
  ];
}
