// update_location_tile.dart

import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../providers/location_provider.dart';

class UpdateLocationTile extends ConsumerWidget {
  const UpdateLocationTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        final Map<String, dynamic>? result = await context.push(
          RoutePaths.updateLocation,
        );

        if (result != null) {
          await ref
              .read(locationProvider.notifier)
              .updateRiderLocation(
                latitude: result['lat'] as double,
                longitude: result['long'] as double,
                address: result['address'] as String,
              );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.body,
            width: .5,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.paste200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Update Location',
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap to set your current location",
                    style: AppTextStyles.paragraph2.copyWith(
                      color: AppColors.body.withValues(alpha: 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
