import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../image_placeholder_card.dart';
import '../../../../core/utils/file_picker_utils.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../state/vehicle_info_state.dart';
import '../image_preview.dart';

class VehicleImageField extends ConsumerWidget {
  const VehicleImageField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final File? vehicleImage = ref.watch(
      vehicleInfoProvider.select(
        (VehicleInfoState state) => state.vehicleImage,
      ),
    );

    return vehicleImage == null
        ? ImagePlaceholderCard(
            onPick: () async {
              final File? file = await FilePickerUtils.pickFile();
              if (file != null) {
                ref.read(vehicleInfoProvider.notifier).setVehicleImage(file);
              }
            },
            title: "Click to upload Uploads vehicle image",
            supportDesc: "Accepted formats: JPG, PNG",
          )
        : ImagePreview(
            imageFile: vehicleImage,
            onRemove: () {
              ref.read(vehicleInfoProvider.notifier).setVehicleImage(null);
            },
            // width: context.screenWidth,
            // height: 200,
          );
  }
}
