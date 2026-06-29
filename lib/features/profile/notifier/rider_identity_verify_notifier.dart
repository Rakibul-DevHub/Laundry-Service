import 'dart:io';

import 'package:drop_n_fresh/features/profile/model/documents/upload_insurance_response.dart';
import 'package:drop_n_fresh/features/profile/model/documents/upload_license_response.dart';
import 'package:drop_n_fresh/features/profile/model/documents/upload_nid_response.dart';
import 'package:drop_n_fresh/features/profile/model/documents/upload_selfie_response.dart';
import 'package:drop_n_fresh/shared/models/rider_documents_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/router/app_router.dart';
import '../../../app/toast/toast.dart';
import '../../../core/utils/app_logger.dart';
import '../model/vehicle_info_model.dart';
import '../providers/rider_identity_verify_providers.dart';
import '../state/rider_verification_state.dart';

class RiderVerificationNotifier extends Notifier<RiderVerificationState> {
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;
  @override
  RiderVerificationState build() {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);
    return const RiderVerificationState();
  }

  // part of nid verification
  void setNidFront(File? front) {
    state = state.copyWith(nidFront: front);
  }

  void setNidBack(File? back) {
    state = state.copyWith(nidBack: back);
  }

  void removeNidFront() {
    state = state.copyWithNIDFront(nidFront: null);
  }

  void removeNidBack() {
    state = state.copyWithNIDBack(nidBack: null);
  }

  Future<void> handleNIDSubmit() async {
    try {
      final bool isNidComplete = state.isNidComplete;
      if (!isNidComplete) {
        return;
      }
      state = state.copyWith(isNidSubmitting: true);
      final UploadNidResponse response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.uploadRiderNid,
        fromJson: UploadNidResponse.fromJson,
        fileFields: <String, List<File>>{
          "nidFront": <File>[state.nidFront!],
          "nidBack": <File>[state.nidBack!],
        },
      );
      ref
          .read(riderIdentityVerifyHomeProvider.notifier)
          .updateDocument(
            nid: Nid(
              front: DocumentSide(
                filename: response.data.nidFront.filename,
                url: response.data.nidFront.url,
                uploadedAt: response.data.nidFront.uploadedAt,
                status: "pending",
              ),
              back: DocumentSide(
                filename: response.data.nidBack.filename,
                url: response.data.nidBack.url,
                uploadedAt: response.data.nidBack.uploadedAt,
                status: "pending",
              ),
            ),
          );
      Toast.showSuccess(response.message);
      _appRouter.pop();
    } catch (e) {
      AppLogger().d(ExceptionHandler.errorMessage(e));
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isNidSubmitting: false);
    }
  }

  // part of driving license verification
  void setDrivingLicenseFront(File? front) {
    state = state.copyWith(drivingLicenseFront: front);
  }

  void setDrivingLicenseBack(File? back) {
    state = state.copyWith(drivingLicenseBack: back);
  }

  void removeDrivingLicenseFront() {
    state = state.copyWithDrivingFront(drivingLicenseFront: null);
  }

  void removeDrivingLicenseBack() {
    state = state.copyWithDrivingBack(drivingLicenseBack: null);
  }

  Future<void> handleDrivingLicenseSubmit() async {
    try {
      final bool isDrivingLicenseComplete = state.isDrivingLicenseComplete;
      if (!isDrivingLicenseComplete) {
        return;
      }
      state = state.copyWith(isDrivingLicenseSubmitting: true);
      final UploadLicenseResponse response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.uploadRiderLicense,
        fromJson: UploadLicenseResponse.fromJson,
        fileFields: <String, List<File>>{
          "licenseFront": <File>[state.drivingLicenseFront!],
          "licenseBack": <File>[state.drivingLicenseBack!],
        },
      );
      ref
          .read(riderIdentityVerifyHomeProvider.notifier)
          .updateDocument(
            drivingLicense: DrivingLicense(
              front: DocumentSide(
                filename: response.data.licenseFront.filename,
                url: response.data.licenseFront.url,
                uploadedAt: response.data.licenseFront.uploadedAt,
                status: "pending",
              ),
              back: DocumentSide(
                filename: response.data.licenseBack.filename,
                url: response.data.licenseBack.url,
                uploadedAt: response.data.licenseBack.uploadedAt,
                status: "pending",
              ),
            ),
          );
      Toast.showSuccess(response.message);
      _appRouter.pop();
    } catch (e) {
      AppLogger().d(ExceptionHandler.errorMessage(e));
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isDrivingLicenseSubmitting: false);
    }
  }

  // part of insurance verification
  void setInsuranceDoc(File? doc) {
    state = state.copyWith(insuranceDocument: doc);
  }

  void removeInsuranceDoc() {
    state = state.copyWithInsurance(insuranceDocument: null);
  }

  Future<void> handleInsuranceSubmit() async {
    try {
      final bool isInsuranceComplete = state.isInsuranceComplete;
      if (!isInsuranceComplete) {
        return;
      }
      state = state.copyWith(isInsuranceSubmitting: true);
      final UploadInsuranceResponse response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.uploadRiderInsurance,
        fromJson: UploadInsuranceResponse.fromJson,
        fileFields: <String, List<File>>{
          "insurance": <File>[state.insuranceDocument!],
        },
      );
      ref
          .read(riderIdentityVerifyHomeProvider.notifier)
          .updateDocument(
            insurance: Insurance(
              document: DocumentSide(
                filename: response.insurance.filename,
                url: response.insurance.url,
                uploadedAt: response.insurance.uploadedAt,
                status: "pending",
              ),
            ),
          );
      Toast.showSuccess(response.message);
      _appRouter.pop();
    } catch (e) {
      AppLogger().d(ExceptionHandler.errorMessage(e));
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isInsuranceSubmitting: false);
    }
  }

  // part of selfie verification
  void setSelfie(File? image) {
    state = state.copyWith(selfie: image);
  }

  void removeSelfie() {
    state = state.copyWithSelfieImage(selfie: null);
  }

  Future<void> handleSelfieSubmit() async {
    try {
      final bool isSelfieComplete = state.isSelfieComplete;
      if (!isSelfieComplete) {
        return;
      }
      state = state.copyWith(isSelfieSubmitting: true);
      final UploadSelfieResponse response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.uploadRiderSelfie,
        fromJson: UploadSelfieResponse.fromJson,
        fileFields: <String, List<File>>{
          "selfie": <File>[state.selfie!],
        },
      );
      ref
          .read(riderIdentityVerifyHomeProvider.notifier)
          .updateDocument(
            selfie: Selfie(
              image: DocumentSide(
                filename: response.selfie.filename,
                url: response.selfie.url,
                uploadedAt: response.selfie.uploadedAt,
                status: "pending",
              ),
            ),
          );
      Toast.showSuccess(response.message);
      _appRouter.pop();
    } catch (e) {
      AppLogger().d(ExceptionHandler.errorMessage(e));
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isSelfieSubmitting: false);
    }
  }

  // part of vehicle info
  void setVehicleInfo(VehicleInfo info) {
    state = state.copyWith(vehicleInfo: info);
  }
}
