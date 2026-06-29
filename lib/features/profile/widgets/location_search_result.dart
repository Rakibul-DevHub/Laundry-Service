import 'package:flutter/material.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../model/user_location_model.dart';

class LocationSearchResult extends StatelessWidget {
  final SearchedLocation location;
  final VoidCallback onTap;

  const LocationSearchResult({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.paste200.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    location.name,
                    style: AppTextStyles.paragraph1.copyWith(
                      color: AppColors.title,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location.address,
                    style: AppTextStyles.paragraph3.copyWith(
                      color: AppColors.body,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.body, size: 20),
          ],
        ),
      ),
    );
  }
}
