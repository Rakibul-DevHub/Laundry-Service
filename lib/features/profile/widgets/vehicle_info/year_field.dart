import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../state/vehicle_info_state.dart';

class YearField extends ConsumerWidget {
  const YearField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String year = ref.watch(
      vehicleInfoProvider.select(
        (VehicleInfoState state) => state.yearOfManufacture,
      ),
    );
    final String? error = ref.watch(
      vehicleInfoProvider.select(
        (VehicleInfoState state) => state.yearOfManufactureError,
      ),
    );

    return AppTextField(
      labelText: "Year of Manufacture",
      errorText: error,
      initialValue: year,
      keyboardType: TextInputType.number,
      textInputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (String v) =>
          ref.read(vehicleInfoProvider.notifier).setYearOfManufacture(v),
      onEditingComplete: () =>
          ref.read(vehicleInfoProvider.notifier).validateYearOfManufacture(),
      onUnfocus: () =>
          ref.read(vehicleInfoProvider.notifier).validateYearOfManufacture(),
    );
  }
}
