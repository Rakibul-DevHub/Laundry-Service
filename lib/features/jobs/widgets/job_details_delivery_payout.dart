import 'package:flutter/material.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../models/jobs_details_model.dart';

class JobDetailsDeliveryPayout extends StatelessWidget {
  const JobDetailsDeliveryPayout({
    super.key,
    required this.job,
  });

  final JobsDetailsModel job;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green, width: 1),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.info_outline,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            job.isDelivery ? "Delivery Payout" : "Pickup Payout",
            style: AppTextStyles.heading5,
          ),
          const Spacer(),
          Text(
            ' ${job.isDelivery ? job.deliveryPayout.toStringAsFixed(2) : job.pickupPayout.toStringAsFixed(2)}',
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
