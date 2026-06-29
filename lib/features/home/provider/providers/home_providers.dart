import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/service_requests_notifier.dart';
import '../state/service_requests_state.dart';

final AutoDisposeNotifierProvider<ServiceRequestsNotifier, ServiceRequestsState>
serviceRequestsProvider =
    AutoDisposeNotifierProvider<ServiceRequestsNotifier, ServiceRequestsState>(
      ServiceRequestsNotifier.new,
    );
