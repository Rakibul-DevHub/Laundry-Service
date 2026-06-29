import 'dart:io';

import 'package:flutter/foundation.dart';

@immutable
class VehicleInfoState {
  final String vehicleType;
  final String? vehicleTypeError;
  final String model;
  final String? modelError;
  final String brandName;
  final String? brandNameError;
  final String color;
  final String? colorError;
  final String yearOfManufacture;
  final String? yearOfManufactureError;
  final String numberPlate;
  final String? numberPlateError;
  final bool isSubmitting;
  final File? vehicleImage;

  const VehicleInfoState({
    this.vehicleType = '',
    this.vehicleTypeError,
    this.model = '',
    this.modelError,
    this.brandName = '',
    this.brandNameError,
    this.color = '',
    this.colorError,
    this.yearOfManufacture = '',
    this.yearOfManufactureError,
    this.numberPlate = '',
    this.numberPlateError,
    this.vehicleImage,
    this.isSubmitting = false,
  });

  bool get isValid =>
    vehicleTypeError == null &&
    modelError == null &&
    brandNameError == null &&
    colorError == null &&
    yearOfManufactureError == null &&
    numberPlateError == null &&
    vehicleType.isNotEmpty &&
    model.isNotEmpty &&
    brandName.isNotEmpty &&
    color.isNotEmpty &&
    vehicleImage != null &&
    yearOfManufacture.isNotEmpty &&
    numberPlate.isNotEmpty;

  VehicleInfoState copyWith({
    String? vehicleType,
    String? vehicleTypeError,
    String? model,
    String? modelError,
    String? brandName,
    String? brandNameError,
    String? color,
    String? colorError,
    String? yearOfManufacture,
    String? yearOfManufactureError,
    String? numberPlate,
    File? vehicleImage,
    String? numberPlateError,
    bool? isSubmitting,
  }) {
    return VehicleInfoState(
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleTypeError: vehicleTypeError,
      model: model ?? this.model,
      modelError: modelError,
      brandName: brandName ?? this.brandName,
      brandNameError: brandNameError,
      color: color ?? this.color,
      colorError: colorError,
      vehicleImage: vehicleImage ?? this.vehicleImage,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      yearOfManufactureError: yearOfManufactureError,
      numberPlate: numberPlate ?? this.numberPlate,
      numberPlateError: numberPlateError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

   VehicleInfoState copyWithImage({
    File? vehicleImage,
  }) {
    return VehicleInfoState(
      vehicleImage: vehicleImage,
      vehicleType: vehicleType ,
      vehicleTypeError: vehicleTypeError,
      model: model,
      modelError: modelError,
      brandName: brandName,
      brandNameError: brandNameError,
      color: color,
      colorError: colorError,
      yearOfManufacture: yearOfManufacture,
      yearOfManufactureError: yearOfManufactureError,
      numberPlate: numberPlate,
      numberPlateError: numberPlateError,
      isSubmitting: isSubmitting,
    );
  }
}
