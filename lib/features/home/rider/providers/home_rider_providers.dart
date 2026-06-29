import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/jobs_requests_notifier.dart';
import '../notifier/rider_online_notifier.dart';
import '../state/jobs_requests_state.dart';

final AutoDisposeNotifierProvider<JobsRequestsNotifier, JobsRequestsState>
jobsRequestsProvider =
    AutoDisposeNotifierProvider<JobsRequestsNotifier, JobsRequestsState>(
      JobsRequestsNotifier.new,
    );

final NotifierProvider<OnlineStatusNotifier, bool> onlineStatusProvider =
    NotifierProvider<OnlineStatusNotifier, bool>(
      OnlineStatusNotifier.new,
    );
