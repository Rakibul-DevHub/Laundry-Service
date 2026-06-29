import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/user_order_details_notifier.dart';
import '../notifier/user_orders_notifier.dart';
import '../state/user_order_details_state.dart';
import '../state/user_orders_state.dart';

final AutoDisposeNotifierProvider<UserOrdersNotifier, UserOrdersState>
userOrdersProvider =
    AutoDisposeNotifierProvider<UserOrdersNotifier, UserOrdersState>(
      UserOrdersNotifier.new,
    );

final AutoDisposeNotifierProviderFamily<
  UserOrderDetailsNotifier,
  UserOrderDetailsState,
  String
>
userOrderDetailsProvider = NotifierProvider.autoDispose
    .family<UserOrderDetailsNotifier, UserOrderDetailsState, String>(
      UserOrderDetailsNotifier.new,
    );
