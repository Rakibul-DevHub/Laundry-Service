import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/rider_documents_model.dart';

class RiderIdentityVerifyHomeNotifier
    extends Notifier<AsyncValue<RiderDocumentsModel?>> {
  late final ApiClient _apiClient;

  @override
  AsyncValue<RiderDocumentsModel?> build() {
    _apiClient = ref.read(apiClientProvider);

    Future<dynamic>.microtask(handleRetrieveDocuments);

    return const AsyncLoading<RiderDocumentsModel?>();
  }

  Future<void> handleRetrieveDocuments() async {
    state = const AsyncLoading<RiderDocumentsModel?>();

    try {
      final RiderDocumentsModelResponse response = await _apiClient
          .handleRequest(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.riderDocuments,
            fromJson: RiderDocumentsModelResponse.fromJson,
          );
      state = AsyncData<RiderDocumentsModel?>(response.data);
    } catch (e, st) {
      AppLogger().e(ExceptionHandler.errorMessage(e), error: e);
      state = AsyncError<RiderDocumentsModel?>(e, st);
    }
  }

  void updateDocument({
    Nid? nid,
    DrivingLicense? drivingLicense,
    Insurance? insurance,
    Selfie? selfie,
    Vehicle? vehicle,
    String? verificationStatus,
  }) {
    final RiderDocumentsModel? currentModel = state.valueOrNull;

    if (currentModel == null) {
      // Create new model if none exists yet
      final RiderDocumentsModel newModel = RiderDocumentsModel(
        verificationStatus: verificationStatus ?? 'pending',
        nid: nid,
        drivingLicense: drivingLicense,
        insurance: insurance,
        selfie: selfie,
        vehicle: vehicle,
      );
      state = AsyncValue<RiderDocumentsModel?>.data(newModel);
      return;
    }

    // Update existing model using copyWith
    final RiderDocumentsModel updatedModel = currentModel.copyWith(
      verificationStatus: verificationStatus ?? currentModel.verificationStatus,
      nid: nid ?? currentModel.nid,
      drivingLicense: drivingLicense ?? currentModel.drivingLicense,
      insurance: insurance ?? currentModel.insurance,
      selfie: selfie ?? currentModel.selfie,
      vehicle: vehicle ?? currentModel.vehicle,
    );

    state = AsyncValue<RiderDocumentsModel?>.data(updatedModel);
  }
}
