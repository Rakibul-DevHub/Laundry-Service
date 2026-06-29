import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/widgets/app_text_field.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../state/vehicle_info_state.dart';

class ColorField extends ConsumerWidget {
  const ColorField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String color = ref.watch(
      vehicleInfoProvider.select((VehicleInfoState state) => state.color),
    );
    final String? error = ref.watch(
      vehicleInfoProvider.select((VehicleInfoState state) => state.colorError),
    );

    return AppTextField(
      labelText: "Color",
      errorText: error,
      initialValue: color,
      onChanged: (String v) =>
          ref.read(vehicleInfoProvider.notifier).setColor(v),
      onEditingComplete: () =>
          ref.read(vehicleInfoProvider.notifier).validateColor(),
      onUnfocus: () => ref.read(vehicleInfoProvider.notifier).validateColor(),
    );
  }
}
