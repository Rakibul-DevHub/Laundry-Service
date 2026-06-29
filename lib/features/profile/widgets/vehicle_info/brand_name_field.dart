import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../state/vehicle_info_state.dart';

class BrandNameField extends ConsumerWidget {
  const BrandNameField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String brandName = ref.watch(
      vehicleInfoProvider.select((VehicleInfoState state) => state.brandName),
    );
    final String? error = ref.watch(
      vehicleInfoProvider.select(
        (VehicleInfoState state) => state.brandNameError,
      ),
    );

    return AppTextField(
      labelText: "Brand Name*",
      errorText: error,
      initialValue: brandName,
      onChanged: (String v) =>
          ref.read(vehicleInfoProvider.notifier).setBrandName(v),
      onEditingComplete: () =>
          ref.read(vehicleInfoProvider.notifier).validateBrandName(),
      onUnfocus: () =>
          ref.read(vehicleInfoProvider.notifier).validateBrandName(),
    );
  }
}
