import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order_status_type.dart';
import '../notifier/orders_details_notifier.dart';
import '../notifier/orders_notifier.dart';
import '../notifier/orders_overview_notifier.dart';
import '../state/orders_details_state.dart';
import '../state/orders_overview_state.dart';
import '../state/orders_state.dart';

final AutoDisposeNotifierProvider<OverviewNotifier, OrdersOverviewState>
ordersOverviewProvider =
    AutoDisposeNotifierProvider<OverviewNotifier, OrdersOverviewState>(
      OverviewNotifier.new,
    );

final AutoDisposeNotifierProviderFamily<
  OrdersNotifier,
  OrdersState,
  OrderStatusType
>
ordersProvider =
    AutoDisposeNotifierProvider.family<
      OrdersNotifier,
      OrdersState,
      OrderStatusType
    >(
      OrdersNotifier.new,
    );

final AutoDisposeNotifierProviderFamily<
  OrderDetailNotifier,
  OrdersDetailsState,
  String
>
ordersDetailProvider = NotifierProvider.autoDispose
    .family<OrderDetailNotifier, OrdersDetailsState, String>(
      OrderDetailNotifier.new,
    );
