import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../state/vehicle_info_state.dart';

class NumberPlateField extends ConsumerWidget {
  const NumberPlateField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String plate = ref.watch(
      vehicleInfoProvider.select((VehicleInfoState state) => state.numberPlate),
    );
    final String? error = ref.watch(
      vehicleInfoProvider.select(
        (VehicleInfoState state) => state.numberPlateError,
      ),
    );

    return AppTextField(
      labelText: "Number Plate",
      errorText: error,
      initialValue: plate,
      onChanged: (String v) =>
          ref.read(vehicleInfoProvider.notifier).setNumberPlate(v),
      onEditingComplete: () =>
          ref.read(vehicleInfoProvider.notifier).validateNumberPlate(),
      onUnfocus: () =>
          ref.read(vehicleInfoProvider.notifier).validateNumberPlate(),
    );
  }
}
