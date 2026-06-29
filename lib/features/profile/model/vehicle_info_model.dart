import 'dart:io';

class VehicleInfo {
  final String vehicleType;
  final String brandName;
  final String model;
  final String color;
  final int yearOfManufacture;
  final String numberPlate;
  final File vehicleImage;


  const VehicleInfo({
    required this.vehicleType,
    required this.model,
    required this.brandName,
    required this.color,
    required this.yearOfManufacture,
    required this.numberPlate,
    required this.vehicleImage,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'vehicleType': vehicleType,
      'model': model,
      'brandName': brandName,
      'color': color,
      'yearOfManufacture': yearOfManufacture,
      'numberPlate': numberPlate,
    };
  }
}
