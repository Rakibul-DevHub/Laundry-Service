import 'dart:io';

import '../model/vehicle_info_model.dart';

class RiderVerificationState {
  final File? nidFront;
  final File? nidBack;
  final File? drivingLicenseFront;
  final File? drivingLicenseBack;
  final File? insuranceDocument;
  final VehicleInfo? vehicleInfo;
  final File? selfie;
  final bool isNidSubmitting;
  final bool isDrivingLicenseSubmitting;
  final bool isInsuranceSubmitting;
  final bool isSelfieSubmitting;

  const RiderVerificationState({
    this.nidFront,
    this.nidBack,
    this.drivingLicenseFront,
    this.drivingLicenseBack,
    this.insuranceDocument,
    this.vehicleInfo,
    this.selfie,
    this.isNidSubmitting = false,
    this.isDrivingLicenseSubmitting = false,
    this.isInsuranceSubmitting = false,
    this.isSelfieSubmitting = false,
  });

  bool get isNidComplete => nidFront != null && nidBack != null;
  bool get isDrivingLicenseComplete =>
      drivingLicenseFront != null && drivingLicenseBack != null;
  bool get isInsuranceComplete => insuranceDocument != null;
  bool get isVehicleInfoComplete => vehicleInfo != null;
  bool get isSelfieComplete => selfie != null;

  @override
  String toString() {
    return <String, File?>{
      "nidFront": nidFront,
      "nidBack": nidBack,
      "drivingLicenseFront": drivingLicenseFront,
      "drivingLicenseBack": drivingLicenseBack,
      "insuranceDocument": insuranceDocument,
      "selfie": selfie,
    }.toString();
  }

  RiderVerificationState copyWithNIDFront({
    File? nidFront,
  }) {
    return RiderVerificationState(
      nidFront: nidFront,
      nidBack: nidBack,
      drivingLicenseFront: drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack,
      insuranceDocument: insuranceDocument,
      vehicleInfo: vehicleInfo,
      selfie: selfie,
      isNidSubmitting: isNidSubmitting,
      isSelfieSubmitting: isSelfieSubmitting,
      isInsuranceSubmitting: isInsuranceSubmitting,
      isDrivingLicenseSubmitting: isDrivingLicenseSubmitting,
    );
  }

  RiderVerificationState copyWithNIDBack({
    File? nidBack,
  }) {
    return RiderVerificationState(
      nidBack: nidBack,
      nidFront: nidFront,
      drivingLicenseFront: drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack,
      insuranceDocument: insuranceDocument,
      vehicleInfo: vehicleInfo,
      selfie: selfie,
      isNidSubmitting: isNidSubmitting,
      isSelfieSubmitting: isSelfieSubmitting,
      isInsuranceSubmitting: isInsuranceSubmitting,
      isDrivingLicenseSubmitting: isDrivingLicenseSubmitting,
    );
  }

  RiderVerificationState copyWithDrivingFront({
    File? drivingLicenseFront,
  }) {
    return RiderVerificationState(
      nidFront: nidFront,
      nidBack: nidBack,
      drivingLicenseFront: drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack,
      insuranceDocument: insuranceDocument,
      vehicleInfo: vehicleInfo,
      selfie: selfie,
      isSelfieSubmitting: isSelfieSubmitting,
      isNidSubmitting: isNidSubmitting,
      isInsuranceSubmitting: isInsuranceSubmitting,
      isDrivingLicenseSubmitting: isDrivingLicenseSubmitting,
    );
  }

  RiderVerificationState copyWithDrivingBack({
    File? drivingLicenseBack,
  }) {
    return RiderVerificationState(
      nidFront: nidFront,
      nidBack: nidBack,
      drivingLicenseFront: drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack,
      insuranceDocument: insuranceDocument,
      vehicleInfo: vehicleInfo,
      selfie: selfie,
      isSelfieSubmitting: isSelfieSubmitting,
      isNidSubmitting: isNidSubmitting,
      isInsuranceSubmitting: isInsuranceSubmitting,
      isDrivingLicenseSubmitting: isDrivingLicenseSubmitting,
    );
  }

  RiderVerificationState copyWithInsurance({
    File? insuranceDocument,
  }) {
    return RiderVerificationState(
      nidFront: nidFront,
      nidBack: nidBack,
      drivingLicenseFront: drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack,
      insuranceDocument: insuranceDocument,
      vehicleInfo: vehicleInfo,
      selfie: selfie,
      isSelfieSubmitting: isSelfieSubmitting,
      isNidSubmitting: isNidSubmitting,
      isInsuranceSubmitting: isInsuranceSubmitting,
      isDrivingLicenseSubmitting: isDrivingLicenseSubmitting,
    );
  }

  RiderVerificationState copyWithVehicleImage({
    File? vehicleImage,
  }) {
    return RiderVerificationState(
      nidFront: nidFront,
      nidBack: nidBack,
      drivingLicenseFront: drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack,
      insuranceDocument: insuranceDocument,
      vehicleInfo: vehicleInfo,
      selfie: selfie,
      isSelfieSubmitting: isSelfieSubmitting,
      isNidSubmitting: isNidSubmitting,
      isInsuranceSubmitting: isInsuranceSubmitting,
      isDrivingLicenseSubmitting: isDrivingLicenseSubmitting,
    );
  }

  RiderVerificationState copyWithSelfieImage({
    File? selfie,
  }) {
    return RiderVerificationState(
      nidFront: nidFront,
      nidBack: nidBack,
      drivingLicenseFront: drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack,
      insuranceDocument: insuranceDocument,
      vehicleInfo: vehicleInfo,
      selfie: selfie,
      isSelfieSubmitting: isSelfieSubmitting,
      isInsuranceSubmitting: isInsuranceSubmitting,
      isDrivingLicenseSubmitting: isDrivingLicenseSubmitting,
      isNidSubmitting: isNidSubmitting,
    );
  }

  RiderVerificationState copyWith({
    File? nidFront,
    File? nidBack,
    File? drivingLicenseFront,
    File? drivingLicenseBack,
    File? insuranceDocument,
    VehicleInfo? vehicleInfo,
    File? selfie,
    bool? isNidSubmitting,
    bool? isDrivingLicenseSubmitting,
    bool? isInsuranceSubmitting,
    bool? isSelfieSubmitting,
  }) {
    return RiderVerificationState(
      nidFront: nidFront ?? this.nidFront,
      nidBack: nidBack ?? this.nidBack,
      drivingLicenseFront: drivingLicenseFront ?? this.drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack ?? this.drivingLicenseBack,
      insuranceDocument: insuranceDocument ?? this.insuranceDocument,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      selfie: selfie ?? this.selfie,
      isNidSubmitting: isNidSubmitting ?? this.isNidSubmitting,
      isSelfieSubmitting: isSelfieSubmitting ?? this.isSelfieSubmitting,
      isInsuranceSubmitting:
          isInsuranceSubmitting ?? this.isInsuranceSubmitting,
      isDrivingLicenseSubmitting:
          isDrivingLicenseSubmitting ?? this.isDrivingLicenseSubmitting,
    );
  }
}
