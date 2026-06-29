import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/rider_identity_verify_providers.dart';
import '../../state/vehicle_info_state.dart';

class VehicleTypeField extends ConsumerWidget {
  const VehicleTypeField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String vehicleType = ref.watch(
      vehicleInfoProvider.select((VehicleInfoState state) => state.vehicleType),
    );
    final String? error = ref.watch(
      vehicleInfoProvider.select(
        (VehicleInfoState state) => state.vehicleTypeError,
      ),
    );

    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: vehicleType.isEmpty ? null : vehicleType,
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(value: 'Bike', child: Text('Bike')),
        DropdownMenuItem<String>(value: 'Car', child: Text('Car')),
        DropdownMenuItem<String>(value: 'Van', child: Text('Van')),
        DropdownMenuItem<String>(value: 'Truck', child: Text('Truck')),
      ],
      onChanged: (String? value) {
        if (value != null) {
          ref.read(vehicleInfoProvider.notifier).setVehicleType(value);
        }
      },
      decoration: InputDecoration(
        labelText: "Vehicle Type*",
        errorText: error,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
