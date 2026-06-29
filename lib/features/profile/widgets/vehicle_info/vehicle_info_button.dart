import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/strings.dart';
import '../../../../../shared/widgets/app_elevated_button.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../state/vehicle_info_state.dart';

class VehicleInfoButton extends ConsumerWidget {
  const VehicleInfoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isValid = ref.watch(
      vehicleInfoProvider.select((VehicleInfoState state) => state.isValid),
    );
    final bool isSubmitting = ref.watch(
      vehicleInfoProvider.select(
        (VehicleInfoState state) => state.isSubmitting,
      ),
    );

    return AppElevatedButton(
      label: AppStrings.submitButton,
      onPressed: isSubmitting || !isValid
          ? null
          : () => ref.read(vehicleInfoProvider.notifier).submitVehicleInfo(),
      isEnabled: isValid,
      isLoading: isSubmitting,
    );
  }
}
