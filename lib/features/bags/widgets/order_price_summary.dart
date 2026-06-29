import 'package:flutter/material.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../shared/widgets/dashed_divider.dart';
import '../models/order_bag_model.dart';

class OrderPriceSummary extends StatelessWidget {
  const OrderPriceSummary({
    super.key,
    required this.bag,
  });

  final BagDetails bag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.body, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Bag Price',
                style: AppTextStyles.paragraph0.copyWith(
                  color: AppColors.body,
                ),
              ),
              Text(
                '${(bag.priceCents / 100.0).toStringAsFixed(2)} ${bag.currency.toUpperCase()}',
                style: AppTextStyles.paragraph1.copyWith(
                  color: AppColors.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Shipping',
                style: AppTextStyles.paragraph0.copyWith(
                  color: AppColors.body,
                ),
              ),
              Text(
                bag.isShippingFree
                    ? 'FREE'
                    : '${(bag.shippingCents / 100.0).toStringAsFixed(2)} ${bag.currency.toUpperCase()}',
                style: AppTextStyles.paragraph1.copyWith(
                  color: bag.isShippingFree ? AppColors.green : AppColors.body,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          const DashedDivider(
            dashGap: 1,
            dashLength: 5.0,
            color: AppColors.body,
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: AppTextStyles.paragraph0.copyWith(
                  color: AppColors.body,
                ),
              ),
              Text(
                '${(bag.totalCents / 100.0).toStringAsFixed(2)} ${bag.currency.toUpperCase()}',
                style: AppTextStyles.paragraph1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
