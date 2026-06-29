// features/location/user/widgets/user_location_item.dart

import 'package:flutter/material.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../model/user_location_model.dart';

class UserLocationItem extends StatelessWidget {
  final UserLocation location;
  final bool isDefault;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const UserLocationItem({
    super.key,
    required this.location,
    required this.isDefault,
    required this.onSetDefault,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: isDefault
                ? AppColors.primary
                : AppColors.body.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Icon based on type
            _buildTypeIcon(isDefault),
            const SizedBox(width: 12),

            // Location info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        location.name,
                        style: AppTextStyles.heading4.copyWith(
                          color: AppColors.title,
                        ),
                      ),
                      if (isDefault) ...<Widget>[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Default',
                            style: AppTextStyles.paragraph3.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.address,
                    style: AppTextStyles.paragraph1.copyWith(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (location.lastUsed != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      'Last used: ${_formatDate(location.lastUsed!)}',
                      style: AppTextStyles.paragraph1.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Actions
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!isDefault)
                  IconButton(
                    icon: const Icon(Icons.star_border, color: AppColors.body),
                    onPressed: onSetDefault,
                    tooltip: 'Set as default',
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.red),
                  onPressed: onDelete,
                  tooltip: 'Delete location',
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon(bool isDefault) {
    IconData icon;
    Color color;

    icon = Icons.location_on;
    color = isDefault ? AppColors.primary : AppColors.body;

    // switch (location.name.toLowerCase()) {
    //   case 'home':
    //     icon = Icons.home;
    //     color = AppColors.primary;
    //     break;
    //   case 'work':
    //     icon = Icons.work;
    //     color = AppColors.paste500;
    //     break;
    //   default:
    //     icon = Icons.location_on;
    //     color = AppColors.body;
    // }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
