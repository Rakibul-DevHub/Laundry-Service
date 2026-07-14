import 'dart:async';
import 'package:drop_n_fresh/features/profile/model/documents/provider_verification_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/utils/app_logger.dart';

class ProviderDocumentsNotifier extends AutoDisposeAsyncNotifier<ProviderVerificationData?> {
  late final ApiClient _apiClient;

  @override
  FutureOr<ProviderVerificationData?> build() async {
    _apiClient = ref.read(apiClientProvider);
    return _fetchVerificationStatus();
  }

  /// GET: Check if the user has already submitted documents
  Future<ProviderVerificationData?> _fetchVerificationStatus() async {
    try {
      final Map<String, dynamic> response = await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.get,
        endpoint: ApiEndpoints.getProviderDocs,
      );

      if (response['success'] == true && response['data'] != null) {
        return ProviderVerificationData.fromJson(response['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e, stack) {
      AppLogger().e('Failed to fetch verification status: $e', error: e, stackTrace: stack);
      return null; // Assume unsubmitted if it fails (or handle 404 explicitly)
    }
  }

  /// POST: Submit the flat data required by the API
  Future<void> submitDocuments({
    required String tradeLicenseNumber,
    required String tradeLicenseUrl,
    required String nidNumber,
    required String nidFrontUrl,
    required String nidBackUrl,
    required String businessAddress,
    required String shopPhotoUrl,
  }) async {
    // Retain previous state while showing loading
    state = const AsyncValue<ProviderVerificationData?>.loading();

    try {
      final Map<String, dynamic> response = await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.submitProviderDocs,
        data: <String, String>{
          "tradeLicenseNumber": tradeLicenseNumber,
          "tradeLicenseUrl": tradeLicenseUrl,
          "nidNumber": nidNumber,
          "nidFrontUrl": nidFrontUrl,
          "nidBackUrl": nidBackUrl,
          "businessAddress": businessAddress,
          "shopPhotoUrl": shopPhotoUrl,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to submit verification');
      }

      // If successful, refresh the GET endpoint to update the UI to "pending"
      ref.invalidateSelf();

    } catch (e, stack) {
      AppLogger().e('Submit failed: $e', error: e, stackTrace: stack);
      // Revert state back to null so they can try again
      state = const AsyncValue<ProviderVerificationData?>.data(null);
      rethrow;
    }
  }
}

final AutoDisposeAsyncNotifierProvider<ProviderDocumentsNotifier, ProviderVerificationData?>
providerDocumentsProvider = AsyncNotifierProvider.autoDispose<ProviderDocumentsNotifier, ProviderVerificationData?>(
  ProviderDocumentsNotifier.new,
);