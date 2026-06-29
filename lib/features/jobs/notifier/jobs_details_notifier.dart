// features/riders/jobs/notifiers/jobs_details_notifier.dart

import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/features/jobs/providers/jobs_providers.dart';
import 'package:drop_n_fresh/features/jobs/state/jobs_details_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/jobs_check_point_type.dart';
import '../models/jobs_details_model.dart';

class JobsDetailsNotifier
    extends AutoDisposeFamilyNotifier<JobsDetailsState, String> {
  late final ApiClient _apiClient;
  String _jobId = '';

  @override
  JobsDetailsState build(String jobId) {
    _apiClient = ref.read(apiClientProvider);
    _jobId = jobId;
    Future<dynamic>.microtask(() => _fetchJob());
    return const JobsDetailsState(isLoading: true);
  }

  Future<void> _fetchJob() async {
    final bool isFirstLoad = state.job == null;
    state = state.copyWith(
      isLoading: isFirstLoad,
      isRefreshing: !isFirstLoad,
      error: null,
    );
    try {
      final JobsDetailsModel job = await _apiClient
          .handleRequest<JobsDetailsModel>(
            httpMethod: HttpMethod.get,
            endpoint: '${ApiEndpoints.riderOrders}/$_jobId',
            fromJson: JobsDetailsModel.fromJson,
          );
      state = state.copyWith(
        job: job,
        isLoading: false,
        isRefreshing: false,
        error: null,
      );
      AppLogger().d('✅ Job fetched: ${job.id}');
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
        isRefreshing: false,
      );
      AppLogger().e('❌ Failed to fetch job: $e', error: e, stackTrace: stack);
    }
  }

  Future<void> refresh() async => await _fetchJob();

  // === Pickup Leg ===
  Future<void> markArrivedAtPickup({
    required String? status,
  }) async => await _updateCheckpoint(
    status == "DELIVERY_RIDER_ASSIGNED"
        ? 'ARRIVED_AT_DROPOFF'
        : 'ARRIVED_AT_PICKUP',
    'PICKUP',
    JobsCheckPointType.arrivedAtPickup,
    'Arrived at pickup',
  );

  Future<void> scanPickupBags({
    required String qrCode,
  }) async {
    if (state.job == null || qrCode.isEmpty) {
      state = state.setError('No bag to scan');
      return;
    }
    state = state.copyWith(isUpdatingStatus: true, error: null);
    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.post,
            endpoint: '${ApiEndpoints.riderOrders}/$_jobId/scan-pickup',
            data: <String, Object>{
              'qrCode': qrCode,
            },
          );
      Toast.showSuccess(response['message'] as String);
      final JobsDetailsModel updated = state.job!.copyWith(
        status: 'PICKED_UP',
        checkPointStatusType: JobsCheckPointType.itemsPickedUp,
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(
        job: updated,
        isUpdatingStatus: false,
      );
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      rethrow;
    }
  }

  Future<void> markAsCompleted() async => await _updateCheckpoint(
    'DELIVERED',
    'PICKUP',
    JobsCheckPointType.delivered,
    'Complete Delivery',
  );

  Future<void> markArrivedAtProvider() async => await _updateCheckpoint(
    'ARRIVED_AT_PROVIDER',
    'PICKUP',
    JobsCheckPointType.arrivedAtDropoff,
    'Arrived at provider',
  );

  // === Delivery Leg ===
  Future<void> markArrivedAtProviderForDelivery() async =>
      await _updateCheckpoint(
        'ARRIVED_AT_PICKUP',
        'DELIVERY',
        JobsCheckPointType.deliveryAssigned,
        'Arrived at provider',
      );
  Future<void> markCollectedFromProvider() async => await _updateStatus(
    'OUT_FOR_DELIVERY',
    JobsCheckPointType.deliveryCollected,
    'Collected from provider',
  );
  Future<void> markArrivedAtCustomer() async => await _updateCheckpoint(
    'ARRIVED_AT_DROPOFF',
    'DELIVERY',
    JobsCheckPointType.deliveryArrived,
    'Arrived at customer',
  );
  Future<void> markDelivered() async => await _updateStatus(
    'DELIVERED',
    JobsCheckPointType.delivered,
    'Delivery completed',
  );

  // === Helpers ===
  Future<void> _updateCheckpoint(
    String checkpoint,
    String leg,
    JobsCheckPointType type,
    String successMsg,
  ) async {
    if (state.job == null) {
      state = state.setError('No job loaded');
      return;
    }
    state = state.copyWith(isUpdatingStatus: true, error: null);
    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.patch,
        endpoint: '${ApiEndpoints.riderOrders}/$_jobId/status',
        data: <String, String>{
          'status': checkpoint,
          'phase': leg,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      final JobsDetailsModel updated = state.job!.copyWith(
        status: checkpoint,
        checkPointStatusType: type,
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(
        job: updated,
        isUpdatingStatus: false,
        successMessage: successMsg,
      );
      ref.read(jobsOverviewProvider.notifier).refresh();
    } catch (e) {
      // state = state.setError(ExceptionHandler.errorMessage(e));
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(
        isUpdatingStatus: false,
      );
    }
  }

  Future<void> _updateStatus(
    String status,
    JobsCheckPointType type,
    String successMsg,
  ) async {
    if (state.job == null) {
      state = state.setError('No job loaded');
      return;
    }
    state = state.copyWith(isUpdatingStatus: true, error: null);
    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.patch,
        endpoint: '/api/v1/riders/orders/$_jobId/status',
        data: <String, String>{
          'status': status,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      final JobsDetailsModel updated = state.job!.copyWith(
        status: status,
        checkPointStatusType: type,
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(
        job: updated,
        isUpdatingStatus: false,
        successMessage: successMsg,
      );
      ref.read(jobsOverviewProvider.notifier).refresh();
    } catch (e) {
      state = state.setError(ExceptionHandler.errorMessage(e));
      rethrow;
    }
  }

  void clearMessages() => state = state.clearMessages();
  JobsDetailsModel? get currentJob => state.job;
  bool get canAdvanceCheckpoint =>
      state.job?.checkPointStatusType.nextCheckpoint != null;
  String? get nextCheckpointLabel =>
      state.job?.checkPointStatusType.nextCheckpoint?.statusToTitle;
}
