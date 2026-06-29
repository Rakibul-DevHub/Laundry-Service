// features/earnings/models/earnings_summary_rider_model.dart

import 'package:flutter/foundation.dart';

@immutable
class EarningsProviderDashboardResponse {
  final int code;
  final bool success;
  final String message;
  final EarningsSummaryProviderModel data;

  const EarningsProviderDashboardResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory EarningsProviderDashboardResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return EarningsProviderDashboardResponse(
      code: json['code'] as int? ?? 200,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: EarningsSummaryProviderModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }

  EarningsProviderDashboardResponse copyWith({
    int? code,
    bool? success,
    String? message,
    EarningsSummaryProviderModel? data,
  }) {
    return EarningsProviderDashboardResponse(
      code: code ?? this.code,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

@immutable
class EarningsSummaryProviderModel {
  final num allTimeEarnings;
  final num todayEarnings;
  final num availableBalance;
  final num pendingBalance;
  final num totalWithdrawn;
  final int totalTransactions;
  final bool stripeConnectOnboarded;
  final String? stripeConnectAccountId;
  final OnboardingPolicyProviderModel? onboardingPolicy; //  New field
  final String currency;

  const EarningsSummaryProviderModel({
    required this.allTimeEarnings,
    required this.todayEarnings,
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalWithdrawn,
    required this.totalTransactions,
    required this.stripeConnectOnboarded,
    this.stripeConnectAccountId,
    this.onboardingPolicy, //  New optional field
    required this.currency,
  });

  factory EarningsSummaryProviderModel.fromJson(Map<String, dynamic> json) {
    return EarningsSummaryProviderModel(
      allTimeEarnings: _parseNum(json['allTimeEarnings']),
      todayEarnings: _parseNum(json['todayEarnings']),
      availableBalance: _parseNum(json['availableBalance']),
      pendingBalance: _parseNum(json['pendingBalance']),
      totalWithdrawn: _parseNum(json['totalWithdrawn']),
      totalTransactions: json['totalTransactions'] as int? ?? 0,
      stripeConnectOnboarded: json['stripeConnectOnboarded'] as bool? ?? false,
      stripeConnectAccountId: json['stripeConnectAccountId'] as String?,
      //  Parse nested onboardingPolicy object
      onboardingPolicy: json['onboardingPolicy'] != null
          ? OnboardingPolicyProviderModel.fromJson(
              json['onboardingPolicy'] as Map<String, dynamic>,
            )
          : null,
      currency: json['currency'] as String? ?? 'usd',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'allTimeEarnings': allTimeEarnings,
      'todayEarnings': todayEarnings,
      'availableBalance': availableBalance,
      'pendingBalance': pendingBalance,
      'totalWithdrawn': totalWithdrawn,
      'totalTransactions': totalTransactions,
      'stripeConnectOnboarded': stripeConnectOnboarded,
      'stripeConnectAccountId': stripeConnectAccountId,
      'onboardingPolicy': onboardingPolicy?.toJson(),
      'currency': currency,
    };
  }

  EarningsSummaryProviderModel copyWith({
    num? allTimeEarnings,
    num? todayEarnings,
    num? availableBalance,
    num? pendingBalance,
    num? totalWithdrawn,
    int? totalTransactions,
    bool? stripeConnectOnboarded,
    String? stripeConnectAccountId,
    OnboardingPolicyProviderModel? onboardingPolicy,
    String? currency,
  }) {
    return EarningsSummaryProviderModel(
      allTimeEarnings: allTimeEarnings ?? this.allTimeEarnings,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      availableBalance: availableBalance ?? this.availableBalance,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      totalWithdrawn: totalWithdrawn ?? this.totalWithdrawn,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      stripeConnectOnboarded:
          stripeConnectOnboarded ?? this.stripeConnectOnboarded,
      stripeConnectAccountId:
          stripeConnectAccountId ?? this.stripeConnectAccountId,
      onboardingPolicy: onboardingPolicy ?? this.onboardingPolicy,
      currency: currency ?? this.currency,
    );
  }

  static num _parseNum(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// Format balance with currency symbol
  String formatBalance(num amount) {
    final String symbol = currency.toUpperCase() == 'USD'
        ? '\$'
        : currency.toUpperCase();
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Available balance formatted
  String get formattedAvailableBalance => formatBalance(availableBalance);

  /// Pending balance formatted
  String get formattedPendingBalance => formatBalance(pendingBalance);

  /// All-time earnings formatted
  String get formattedAllTimeEarnings => formatBalance(allTimeEarnings);

  /// Can user withdraw funds?
  bool get canWithdraw => availableBalance > 0 && stripeConnectOnboarded;

  /// Does user need to complete onboarding?
  bool get requiresOnboarding => onboardingPolicy?.requiresOnboarding ?? false;

  /// Should new jobs be suspended due to onboarding?
  bool get shouldSuspendNewJobs =>
      onboardingPolicy?.shouldSuspendNewJobs ?? false;
}

//  NEW: Onboarding Policy Model
@immutable
class OnboardingPolicyProviderModel {
  final bool onboarded;
  final bool requiresOnboarding;
  final bool shouldSuspendNewJobs;
  final String? reason;
  final String? reasonCode;
  final String? blockingModal;
  final OnboardingMetricsModel? metrics;

  const OnboardingPolicyProviderModel({
    required this.onboarded,
    required this.requiresOnboarding,
    required this.shouldSuspendNewJobs,
    this.reason,
    this.reasonCode,
    this.blockingModal,
    this.metrics,
  });

  factory OnboardingPolicyProviderModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPolicyProviderModel(
      onboarded: json['onboarded'] as bool? ?? false,
      requiresOnboarding: json['requiresOnboarding'] as bool? ?? false,
      shouldSuspendNewJobs: json['shouldSuspendNewJobs'] as bool? ?? false,
      reason: json['reason'] as String?,
      reasonCode: json['reasonCode'] as String?,
      blockingModal: json['blockingModal'] as String?,
      metrics: json['metrics'] != null
          ? OnboardingMetricsModel.fromJson(
              json['metrics'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'onboarded': onboarded,
      'requiresOnboarding': requiresOnboarding,
      'shouldSuspendNewJobs': shouldSuspendNewJobs,
      'reason': reason,
      'reasonCode': reasonCode,
      'blockingModal': blockingModal,
      'metrics': metrics?.toJson(),
    };
  }

  OnboardingPolicyProviderModel copyWith({
    bool? onboarded,
    bool? requiresOnboarding,
    bool? shouldSuspendNewJobs,
    String? reason,
    String? reasonCode,
    String? blockingModal,
    OnboardingMetricsModel? metrics,
  }) {
    return OnboardingPolicyProviderModel(
      onboarded: onboarded ?? this.onboarded,
      requiresOnboarding: requiresOnboarding ?? this.requiresOnboarding,
      shouldSuspendNewJobs: shouldSuspendNewJobs ?? this.shouldSuspendNewJobs,
      reason: reason ?? this.reason,
      reasonCode: reasonCode ?? this.reasonCode,
      blockingModal: blockingModal ?? this.blockingModal,
      metrics: metrics ?? this.metrics,
    );
  }

  /// Is onboarding complete and no action needed?
  bool get isFullyOnboarded => onboarded && !requiresOnboarding;

  /// Should show blocking modal to user?
  bool get hasBlockingModal =>
      blockingModal != null && blockingModal!.isNotEmpty;
}

//  NEW: Onboarding Metrics Model (nested inside onboardingPolicy)
@immutable
class OnboardingMetricsModel {
  final int completedJobs;
  final num pendingEarningsCents;
  final int jobLimit;
  final num pendingEarningsLimitCents;
  final int gracePeriodDays;
  final DateTime? firstEarningAt;
  final int daysSinceFirstEarning;
  final int remainingJobsBeforeForce;
  final num remainingPendingCentsBeforeForce;

  const OnboardingMetricsModel({
    required this.completedJobs,
    required this.pendingEarningsCents,
    required this.jobLimit,
    required this.pendingEarningsLimitCents,
    required this.gracePeriodDays,
    this.firstEarningAt,
    required this.daysSinceFirstEarning,
    required this.remainingJobsBeforeForce,
    required this.remainingPendingCentsBeforeForce,
  });

  factory OnboardingMetricsModel.fromJson(Map<String, dynamic> json) {
    return OnboardingMetricsModel(
      completedJobs: json['completedJobs'] as int? ?? 0,
      pendingEarningsCents: _parseNum(json['pendingEarningsCents']),
      jobLimit: json['jobLimit'] as int? ?? 0,
      pendingEarningsLimitCents: _parseNum(json['pendingEarningsLimitCents']),
      gracePeriodDays: json['gracePeriodDays'] as int? ?? 0,
      firstEarningAt: json['firstEarningAt'] != null
          ? DateTime.tryParse(json['firstEarningAt'] as String)
          : null,
      daysSinceFirstEarning: json['daysSinceFirstEarning'] as int? ?? 0,
      remainingJobsBeforeForce: json['remainingJobsBeforeForce'] as int? ?? 0,
      remainingPendingCentsBeforeForce: _parseNum(
        json['remainingPendingCentsBeforeForce'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'completedJobs': completedJobs,
      'pendingEarningsCents': pendingEarningsCents,
      'jobLimit': jobLimit,
      'pendingEarningsLimitCents': pendingEarningsLimitCents,
      'gracePeriodDays': gracePeriodDays,
      'firstEarningAt': firstEarningAt?.toIso8601String(),
      'daysSinceFirstEarning': daysSinceFirstEarning,
      'remainingJobsBeforeForce': remainingJobsBeforeForce,
      'remainingPendingCentsBeforeForce': remainingPendingCentsBeforeForce,
    };
  }

  OnboardingMetricsModel copyWith({
    int? completedJobs,
    num? pendingEarningsCents,
    int? jobLimit,
    num? pendingEarningsLimitCents,
    int? gracePeriodDays,
    DateTime? firstEarningAt,
    int? daysSinceFirstEarning,
    int? remainingJobsBeforeForce,
    num? remainingPendingCentsBeforeForce,
  }) {
    return OnboardingMetricsModel(
      completedJobs: completedJobs ?? this.completedJobs,
      pendingEarningsCents: pendingEarningsCents ?? this.pendingEarningsCents,
      jobLimit: jobLimit ?? this.jobLimit,
      pendingEarningsLimitCents:
          pendingEarningsLimitCents ?? this.pendingEarningsLimitCents,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      firstEarningAt: firstEarningAt ?? this.firstEarningAt,
      daysSinceFirstEarning:
          daysSinceFirstEarning ?? this.daysSinceFirstEarning,
      remainingJobsBeforeForce:
          remainingJobsBeforeForce ?? this.remainingJobsBeforeForce,
      remainingPendingCentsBeforeForce:
          remainingPendingCentsBeforeForce ??
          this.remainingPendingCentsBeforeForce,
    );
  }

  static num _parseNum(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// Format cents to dollars (e.g., 29900 → $299.00)
  String formatCentsToCurrency(num cents, String currencyCode) {
    final String symbol = currencyCode.toUpperCase() == 'USD'
        ? '\$'
        : currencyCode.toUpperCase();
    final double dollars = cents / 100;
    return '$symbol${dollars.toStringAsFixed(2)}';
  }

  /// Pending earnings in dollars
  String get formattedPendingEarnings =>
      formatCentsToCurrency(pendingEarningsCents, 'USD');

  /// Pending earnings limit in dollars
  String get formattedPendingEarningsLimit =>
      formatCentsToCurrency(pendingEarningsLimitCents, 'USD');

  /// Remaining pending cents before force in dollars
  String get formattedRemainingPendingCents =>
      formatCentsToCurrency(remainingPendingCentsBeforeForce, 'USD');

  /// Progress toward job limit (0.0 to 1.0)
  double get jobLimitProgress => jobLimit > 0 ? completedJobs / jobLimit : 0;

  /// Progress toward pending earnings limit (0.0 to 1.0)
  double get pendingEarningsProgress => pendingEarningsLimitCents > 0
      ? pendingEarningsCents / pendingEarningsLimitCents
      : 0;

  /// Is user approaching job limit? (80% threshold)
  bool get isApproachingJobLimit => jobLimitProgress >= 0.8;

  /// Is user approaching pending earnings limit? (80% threshold)
  bool get isApproachingPendingLimit => pendingEarningsProgress >= 0.8;

  /// Days remaining in grace period
  int get remainingGracePeriodDays => gracePeriodDays - daysSinceFirstEarning;

  /// Is grace period expired?
  bool get isGracePeriodExpired => remainingGracePeriodDays <= 0;
}
