import 'package:flutter/foundation.dart';

import '../models/earnings_model.dart';
import '../models/earnings_summary_provider_model.dart';

@immutable
class EarningsProviderState {
  final EarningsSummaryProviderModel? summary;
  final List<EarningsModel> earnings;
  final bool isLoading;
  final String? error;
  final bool isRefreshing;
  final bool hasMore;
  final int page;
  final DateTime? selectedDate;

  const EarningsProviderState({
    this.summary,
    this.earnings = const <EarningsModel>[],
    this.isLoading = false,
    this.error,
    this.isRefreshing = false,
    this.hasMore = true,
    this.page = 1,
    this.selectedDate,
  });

  EarningsProviderState copyWith({
    EarningsSummaryProviderModel? summary,
    List<EarningsModel>? earnings,
    bool? isLoading,
    String? error,
    bool? isRefreshing,
    bool? hasMore,
    int? page,
    DateTime? selectedDate,
  }) {
    return EarningsProviderState(
      summary: summary ?? this.summary,
      earnings: earnings ?? this.earnings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
