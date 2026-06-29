import 'package:flutter/material.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../models/jobs_check_point_type.dart';
import '../models/jobs_details_model.dart';

class JobDetailsMessageBox extends StatelessWidget {
  const JobDetailsMessageBox({
    super.key,
    required this.job,
  });

  final JobsDetailsModel job;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(color: AppColors.body, width: 1),
      ),
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.sm,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.info_outline,
                size: 24,
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  job.checkPointStatusType.statusToMessage,
                  style: AppTextStyles.heading5,
                ),
              ),
            ],
          ),
          Text(
            job.checkPointStatusType.statusToDescription,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
