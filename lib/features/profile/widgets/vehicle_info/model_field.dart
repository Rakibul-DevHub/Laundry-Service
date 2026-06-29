import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../state/vehicle_info_state.dart';

class ModelField extends ConsumerWidget {
  const ModelField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String model = ref.watch(
      vehicleInfoProvider.select((VehicleInfoState state) => state.model),
    );
    final String? error = ref.watch(
      vehicleInfoProvider.select((VehicleInfoState state) => state.modelError),
    );

    return AppTextField(
      labelText: "Model*",
      errorText: error,
      initialValue: model,
      onChanged: (String v) =>
          ref.read(vehicleInfoProvider.notifier).setModel(v),
      onEditingComplete: () =>
          ref.read(vehicleInfoProvider.notifier).validateModel(),
      onUnfocus: () => ref.read(vehicleInfoProvider.notifier).validateModel(),
    );
  }
}
