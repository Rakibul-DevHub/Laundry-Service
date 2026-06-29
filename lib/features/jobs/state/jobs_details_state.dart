// features/riders/jobs/states/jobs_details_state.dart

import 'package:flutter/material.dart';

import '../models/jobs_check_point_type.dart';
import '../models/jobs_details_model.dart';

@immutable
class JobsDetailsState {
  final JobsDetailsModel? job;
  final bool isLoading;
  final bool isRefreshing;
  final bool isUpdatingStatus;
  final bool isScanningBags;
  final String? error;
  final String? successMessage;
  final String? infoMessage;
  final List<String> scannedQrCodes;
  final int totalBagsToScan;
  final bool isTrackingLocation;
  final double? currentLatitude;
  final double? currentLongitude;
  final double? distanceToPickup;
  final double? distanceToDropoff;

  const JobsDetailsState({
    this.job,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isUpdatingStatus = false,
    this.isScanningBags = false,
    this.error,
    this.successMessage,
    this.infoMessage,
    this.scannedQrCodes = const <String>[],
    this.totalBagsToScan = 0,
    this.isTrackingLocation = false,
    this.currentLatitude,
    this.currentLongitude,
    this.distanceToPickup,
    this.distanceToDropoff,
  });

  JobsDetailsState copyWith({
    JobsDetailsModel? job,
    bool? isLoading,
    bool? isRefreshing,
    bool? isUpdatingStatus,
    bool? isScanningBags,
    String? error,
    String? successMessage,
    String? infoMessage,
    List<String>? scannedQrCodes,
    int? totalBagsToScan,
    bool? isTrackingLocation,
    double? currentLatitude,
    double? currentLongitude,
    double? distanceToPickup,
    double? distanceToDropoff,
  }) {
    return JobsDetailsState(
      job: job ?? this.job,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
      isScanningBags: isScanningBags ?? this.isScanningBags,
      error: error,
      successMessage: successMessage,
      infoMessage: infoMessage,
      scannedQrCodes: scannedQrCodes ?? this.scannedQrCodes,
      totalBagsToScan: totalBagsToScan ?? this.totalBagsToScan,
      isTrackingLocation: isTrackingLocation ?? this.isTrackingLocation,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      distanceToPickup: distanceToPickup ?? this.distanceToPickup,
      distanceToDropoff: distanceToDropoff ?? this.distanceToDropoff,
    );
  }

  bool get hasData => job != null && !isLoading;
  bool get hasError => error != null && error!.isNotEmpty;
  bool get isAnyLoading => isLoading || isRefreshing || isUpdatingStatus;
  // ignore: avoid_bool_literals_in_conditional_expressions
  bool get isPickupLeg => job?.isDelivery == true ? false : true;

  bool get isWaitingForProvider =>
      job?.checkPointStatusType.requiresProviderScan ?? false;
  bool get requiresQrScan => job?.checkPointStatusType.requiresQrScan ?? false;
  int get checkpointProgress => job?.checkPointStatusType.statusToIndex ?? 0;
  double get progressPercentage => checkpointProgress / 8;
  bool get allBagsScanned =>
      totalBagsToScan > 0 && scannedQrCodes.length >= totalBagsToScan;
  int get remainingBagsToScan => totalBagsToScan - scannedQrCodes.length;
  bool get isJobCompleted =>
      job?.checkPointStatusType == JobsCheckPointType.delivered;
  bool get isJobActive =>
      !isJobCompleted &&
      job?.checkPointStatusType != JobsCheckPointType.cancelled;
  String get formattedStatus => job?.formattedStatus ?? 'Unknown';
  Color get statusColor => job?.statusColor ?? Colors.grey;
  bool get requiresRiderAction {
    final JobsDetailsModel? job = this.job;
    if (job == null) {
      return false;
    }
    return <JobsCheckPointType>[
      JobsCheckPointType.pickupAssigned,
      JobsCheckPointType.arrivedAtPickup,
      JobsCheckPointType.itemsPickedUp,
      JobsCheckPointType.deliveryAssigned,
      JobsCheckPointType.deliveryCollected,
      JobsCheckPointType.deliveryArrived,
    ].contains(job.checkPointStatusType);
  }

  String? get currentActionLabel {
    final JobsDetailsModel? job = this.job;
    if (job == null) {
      return null;
    }
    switch (job.checkPointStatusType) {
      case JobsCheckPointType.pickupAssigned:
        return 'Mark Arrived at Pickup';
      case JobsCheckPointType.arrivedAtPickup:
        return 'Scan Bags';
      case JobsCheckPointType.itemsPickedUp:
        return !isPickupLeg ? 'Complete Delivery' : 'Mark Arrived at Provider';
      case JobsCheckPointType.arrivedAtDropoff:
        return !isPickupLeg
            ? 'Waiting for Provider Scan'
            : 'Mark Arrived at Customer';
      case JobsCheckPointType.receivedAtProvider:
        return 'Waiting for Delivery Assignment';
      case JobsCheckPointType.deliveryAssigned:
        return 'Mark Arrived at Provider';
      case JobsCheckPointType.deliveryCollected:
        return 'Mark Arrived at Customer';
      case JobsCheckPointType.deliveryArrived:
        return 'Complete Delivery';
      default:
        return null;
    }
  }

  JobsDetailsState clearMessages() =>
      copyWith(error: null, successMessage: null, infoMessage: null);
  JobsDetailsState setError(String msg) =>
      copyWith(error: msg, successMessage: null, isUpdatingStatus: false);
  JobsDetailsState setSuccess(String msg) =>
      copyWith(successMessage: msg, error: null, isUpdatingStatus: false);
}
