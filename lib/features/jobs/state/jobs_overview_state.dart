import 'package:flutter/foundation.dart';

import '../models/jobs_overview_model.dart';

@immutable
class JobsOverviewState {
  final JobsOverviewModel? overview;
  final bool isLoading;
  final String? error;

  const JobsOverviewState({
    this.overview,
    this.isLoading = false,
    this.error,
  });

  JobsOverviewState copyWith({
    JobsOverviewModel? overview,
    bool? isLoading,
    String? error,
  }) {
    return JobsOverviewState(
      overview: overview ?? this.overview,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
