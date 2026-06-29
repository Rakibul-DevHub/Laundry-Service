import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/icons.dart';
import '../../../core/config/sizes.dart';
import '../models/earnings_summary_provider_model.dart';
import '../providers/earnings_providers.dart';
import '../state/earnings_provider_state.dart';
import 'earnings_summary_card.dart';
import 'shimmer/summary_shimmer.dart';

class EarningsSummarySectionProvider extends ConsumerWidget {
  const EarningsSummarySectionProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch summary data
    final EarningsSummaryProviderModel? summary = ref.watch(
      providerEarningsProvider.select(
        (EarningsProviderState state) => state.summary,
      ),
    );

    if (summary == null) {
      return const SummaryShimmer();
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: EarningsSummaryCard(
                title: 'All Time Earnings',
                amount: '\$${summary.allTimeEarnings.toStringAsFixed(2)}',
                iconPath: AppIcons.allTimeEarnings,
                backgroundColor: AppColors.paste50,
                borderColor: AppColors.primary,
                onTapCallback: () {},
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: EarningsSummaryCard(
                title: "Today's Earning",
                amount: '\$${summary.todayEarnings.toStringAsFixed(2)}',
                iconPath: AppIcons.todayEarnings,
                backgroundColor: AppColors.green50,
                borderColor: AppColors.title,
                onTapCallback: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceBetweenCards),
        Row(
          children: <Widget>[
            Expanded(
              child: EarningsSummaryCard(
                title: 'Available Balance',
                amount: '\$${summary.availableBalance.toStringAsFixed(2)}',
                iconPath: AppIcons.availableBalance,
                backgroundColor: AppColors.green50,
                borderColor: AppColors.green,
                onTapCallback: () {},
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: EarningsSummaryCard(
                title: 'Total Withdraw',
                amount: '\$${summary.totalWithdrawn.toStringAsFixed(2)}',
                iconPath: AppIcons.balanceWithdraw,
                backgroundColor: AppColors.red50,
                borderColor: AppColors.red,
                onTapCallback: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
