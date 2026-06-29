import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/jobs_status_type.dart';
import '../notifier/jobs_details_notifier.dart';
import '../notifier/jobs_notifier.dart';
import '../notifier/jobs_overview_notifier.dart';
import '../state/jobs_details_state.dart';
import '../state/jobs_overview_state.dart';
import '../state/jobs_state.dart';

final AutoDisposeNotifierProvider<JobsOverviewNotifier, JobsOverviewState>
jobsOverviewProvider =
    AutoDisposeNotifierProvider<JobsOverviewNotifier, JobsOverviewState>(
      JobsOverviewNotifier.new,
    );

final AutoDisposeNotifierProviderFamily<JobsNotifier, JobsState, JobStatusType>
jobsProvider =
    AutoDisposeNotifierProvider.family<JobsNotifier, JobsState, JobStatusType>(
      JobsNotifier.new,
    );

final AutoDisposeNotifierProviderFamily<
  JobsDetailsNotifier,
  JobsDetailsState,
  String
>
jobsDetailsProvider = NotifierProvider.autoDispose
    .family<JobsDetailsNotifier, JobsDetailsState, String>(
      JobsDetailsNotifier.new,
    );
