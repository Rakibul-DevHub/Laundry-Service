import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/my_bags_notifier.dart';
import '../notifier/order_bag_notifier.dart';
import '../state/my_bags_state.dart';
import '../state/order_bag_state.dart';

final AutoDisposeNotifierProvider<BagNotifier, MyBagsState> myBagProvider =
    AutoDisposeNotifierProvider<BagNotifier, MyBagsState>(
      BagNotifier.new,
    );


final AutoDisposeNotifierProvider<OrderBagNotifier, OrderBagState>
orderBagProvider = AutoDisposeNotifierProvider<OrderBagNotifier, OrderBagState>(
  OrderBagNotifier.new,
);
