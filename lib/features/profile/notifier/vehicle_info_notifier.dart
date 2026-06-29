import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/router/app_router.dart';
import '../../../app/toast/toast.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/app_validation.dart';
import '../../../shared/models/rider_documents_model.dart';
import '../model/vehicle_info_model_response.dart';
import '../providers/rider_identity_verify_providers.dart';
import '../state/vehicle_info_state.dart';

class VehicleInfoNotifier extends AutoDisposeNotifier<VehicleInfoState> {
  late final ApiClient _apiClient;
  late final GoRouter _appRouter;
  @override
  VehicleInfoState build() {
    _apiClient = ref.read(apiClientProvider);
    _appRouter = ref.read(appRouterProvider);
    return const VehicleInfoState();
  }

  void setVehicleType(String type) {
    state = state.copyWith(
      vehicleType: type,
      vehicleTypeError: null,
    );
  }

  void setModel(String model) {
    state = state.copyWith(
      model: model,
      modelError: null,
    );
  }

  void setBrandName(String brand) {
    state = state.copyWith(
      brandName: brand,
      brandNameError: null,
    );
  }

  void setColor(String color) {
    state = state.copyWith(
      color: color,
      colorError: null,
    );
  }

  void setYearOfManufacture(String year) {
    state = state.copyWith(
      yearOfManufacture: year,
      yearOfManufactureError: null,
    );
  }

  void setNumberPlate(String plate) {
    state = state.copyWith(
      numberPlate: plate,
      numberPlateError: null,
    );
  }

  void setVehicleImage(File? image) {
    state = state.copyWithImage(
      vehicleImage: image,
    );
  }

  void validateVehicleType() {
    final String? error = AppValidation.validateRequired(
      state.vehicleType,
      fieldName: "Vehicle Type",
    );
    state = state.copyWith(vehicleTypeError: error);
  }

  void validateModel() {
    final String? error = AppValidation.validateRequired(
      state.model,
      fieldName: "Model",
    );
    state = state.copyWith(modelError: error);
  }

  void validateBrandName() {
    final String? error = AppValidation.validateRequired(
      state.brandName,
      fieldName: "Brand Name",
    );
    state = state.copyWith(brandNameError: error);
  }

  void validateColor() {
    final String? error = AppValidation.validateRequired(
      state.color,
      fieldName: "Color",
    );
    state = state.copyWith(colorError: error);
  }

  void validateYearOfManufacture() {
    String? error;
    if (state.yearOfManufacture.isEmpty) {
      error = 'Year is required';
    } else if (!AppValidation.isValidYear(state.yearOfManufacture)) {
      error = 'Enter a valid year (1900-${DateTime.now().year})';
    }
    state = state.copyWith(yearOfManufactureError: error);
  }

  void validateNumberPlate() {
    final String? error = state.numberPlate.isEmpty
        ? 'Number plate is required'
        : null;
    state = state.copyWith(numberPlateError: error);
  }

  Future<void> submitVehicleInfo() async {
    // Validate all fields
    validateVehicleType();
    validateModel();
    validateBrandName();
    validateColor();
    validateYearOfManufacture();
    validateNumberPlate();

    if (!state.isValid) {
      return;
    }

    state = state.copyWith(isSubmitting: true);

    try {
      final VehicleUploadResponse response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.uploadRiderVehicle,
        fromJson: VehicleUploadResponse.fromJson,
        data: <String, String>{
          "vehicleType": state.vehicleType.toLowerCase(),
          "model": state.model,
          "manufacturer": state.brandName,
          "yearOfManufacture": state.yearOfManufacture,
          "color": state.color,
          "numberPlate": state.numberPlate,
        },
        fileFields: <String, List<File>>{
          "vehicleImage": <File>[state.vehicleImage!],
        },
      );
      ref
          .read(riderIdentityVerifyHomeProvider.notifier)
          .updateDocument(
            vehicle: Vehicle(
              image: DocumentSide(
                filename: response.data?.image?.filename ?? '',
                url: response.data?.image?.url ?? '',
                uploadedAt:
                    DateTime.tryParse(response.data?.image?.uploadedAt ?? '') ??
                    DateTime.now(),
                status: "pending",
              ),
              vehicleType: response.data?.vehicleType ?? '',
              model: response.data?.model ?? '',
              manufacturer: response.data?.manufacturer ?? '',
              yearOfManufacture: response.data?.yearOfManufacture ?? '',
              color: response.data?.color ?? '',
              numberPlate: response.data?.numberPlate ?? '',
            ),
          );
      Toast.showSuccess(response.message);
      _appRouter.pop();
    } catch (e) {
      AppLogger().d(ExceptionHandler.errorMessage(e));
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
