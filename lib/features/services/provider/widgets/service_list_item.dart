// features/services/provider/widgets/service_list_item.dart

import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import '../models/service_list_response.dart';

class ServiceListItem extends ConsumerWidget {
  final ProviderService service;

  const ServiceListItem({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.body, width: .5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // onTap: () => context.push(
        //   RoutePaths.detailsService,
        //   extra: service.id,
        // ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header: Icon + Title + Time + Status
              Row(
                children: <Widget>[
                  if (service.serviceCategory.icon.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AssetLoader(
                        assetPath: service.serviceCategory.icon,
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          service.serviceCategory.name,
                          style: AppTextStyles.subTitle1.copyWith(
                            color: AppColors.title,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.body,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              service.estimateTime,
                              style: AppTextStyles.paragraph2.copyWith(
                                color: AppColors.body,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: service.isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : AppColors.body.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      service.isActive ? '✓ Active' : '✗ Inactive',
                      style: AppTextStyles.paragraph0.copyWith(
                        color: service.isActive ? Colors.green : AppColors.body,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                service.description,
                style: AppTextStyles.paragraph1.copyWith(
                  color: AppColors.body,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              Row(
                children: <Widget>[
                  Flexible(
                    child: _StatChip(
                      label: 'Categories',
                      value: service.productCategories.length.toString(),
                      icon: Icons.category,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _StatChip(
                      label: 'Items',
                      value: service.totalItems.toString(),
                      icon: Icons.inventory_2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              AppOutlineButton(
                onPressed: () => context.push(
                  RoutePaths.detailsService,
                  extra: service.id,
                ),
                label: 'Details',
                height: 40,
                outlineColor: AppColors.primary.withValues(alpha: .4),
                textColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.paste200.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.paste300),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$value $label',
              style: AppTextStyles.paragraph0.copyWith(
                color: AppColors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
