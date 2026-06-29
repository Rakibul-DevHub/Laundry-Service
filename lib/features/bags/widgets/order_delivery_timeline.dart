import 'package:drop_n_fresh/core/config/icons.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../shared/widgets/asset_loader.dart';
import '../models/order_bag_model.dart';

class OrderDeliveryTimeline extends StatelessWidget {
  const OrderDeliveryTimeline({
    super.key,
    required this.bag,
  });

  final BagDetails bag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.body, width: 1),
        borderRadius: BorderRadius.circular(
          AppSizes.borderRadiusLg,
        ),
      ),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Delivery Timeline',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: AppSizes.spaceBetweenItems),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bag.deliveryTimeline.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
                  height: AppSizes.md,
                ),
            itemBuilder: (BuildContext context, int index) {
              final DeliveryTimelineItem step = bag.deliveryTimeline[index];
              return Row(
                children: <Widget>[
                  AssetLoader(
                    assetPath: step.key == "processing"
                        ? AppIcons.orderProcessing
                        : step.key == "shipping"
                        ? AppIcons.shipping
                        : step.key == "arrival"
                        ? AppIcons.tick
                        : AppIcons.tick,
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          step.title,
                          style: AppTextStyles.heading4,
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          step.eta,
                          style: AppTextStyles.paragraph0.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
