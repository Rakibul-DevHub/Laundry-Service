// features/services/user/widgets/user_service_item.dart

import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../models/user_service_model.dart';

class UserServiceItem extends StatelessWidget {
  final UserServiceModel service;

  const UserServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push(
        RoutePaths.userServiceBooking,
        extra: service,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.body.withValues(alpha: .2),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Provider Avatar
            Row(
              children: <Widget>[
                _buildProviderAvatar(service.providerProfilePicture),

                const SizedBox(width: 8),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      service.providerName,
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.title,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.star, size: 24, color: Colors.amber),
                        Text(
                          ' ${service.providerTotalRatings}',
                          style: AppTextStyles.paragraph0.copyWith(
                            color: AppColors.body,
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        const Icon(
                          Icons.location_on,
                          size: 24,
                          color: AppColors.body,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service.shortAddress,
                          style: AppTextStyles.paragraph1.copyWith(
                            color: AppColors.title,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // Rating Badge
                  ],
                ),
              ],
            ),

            const SizedBox(
              height: AppSizes.sm,
            ),
            const DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            const SizedBox(
              height: AppSizes.sm,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (service.serviceCategory.icon.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: AssetLoader(
                      assetPath: service.serviceCategory.icon,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      service.serviceCategory.name,
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.title,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: AppColors.body,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service.estimateTime,
                          style: AppTextStyles.paragraph0.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(
              height: AppSizes.sm,
            ),
            const DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            const SizedBox(
              height: AppSizes.sm,
            ),

            Text(
              service.description,
              style: AppTextStyles.paragraph0.copyWith(
                color: AppColors.body,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),
            InkWell(
              onTap: () => context.push(
                RoutePaths.userServiceBooking,
                extra: service,
              ),
              // color: AppColors.primary,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Book Service',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),

            // AppOutlineButton(
            //   label: "Book Service",
            //   // isEnabled: service.serviceCategory.,
            //   outlineColor: AppColors.paste500,
            //   onPressed: () => context.push(
            //     RoutePaths.userServiceBooking,
            //     extra: service,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderAvatar(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.paste200,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.person, color: AppColors.body),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AssetLoader(
        assetPath: imageUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        shape: BoxShape.rectangle,
      ),
    );
  }
}
