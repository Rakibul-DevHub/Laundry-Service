import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/earnings_provider_notifier.dart';
import '../notifier/earnings_rider_notifier.dart';
import '../state/earnings_rider_state.dart';
import '../state/earnings_provider_state.dart';

final AutoDisposeNotifierProvider<EarningsProviderNotifier, EarningsProviderState>
providerEarningsProvider = AutoDisposeNotifierProvider<EarningsProviderNotifier, EarningsProviderState>(
  EarningsProviderNotifier.new,
);
final AutoDisposeNotifierProvider<EarningsRiderNotifier, EarningsRiderState>
riderEarningsProvider =
    AutoDisposeNotifierProvider<EarningsRiderNotifier, EarningsRiderState>(
      EarningsRiderNotifier.new,
    );
