import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/sizes.dart';
import '../models/earnings_model.dart';
import '../state/earnings_provider_state.dart';
import '../providers/earnings_providers.dart';
import 'earnings_list_item.dart';
import 'shimmer/earnings_list_item_shimmer.dart';

class EarningsListSectionProvider extends ConsumerWidget {
  const EarningsListSectionProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<EarningsModel> earnings = ref.watch(
      providerEarningsProvider.select(
        (EarningsProviderState state) => state.earnings,
      ),
    );
    final int earningsLength = ref.watch(
      providerEarningsProvider.select(
        (EarningsProviderState state) => state.earnings.length,
      ),
    );
    final bool isLoading = ref.watch(
      providerEarningsProvider.select(
        (EarningsProviderState state) => state.isLoading,
      ),
    );
    final bool hasMore = ref.watch(
      providerEarningsProvider.select((EarningsProviderState state) => state.hasMore),
    );

    return SliverList.separated(
      itemCount: earningsLength + (isLoading && hasMore ? 1 : 0),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: AppSizes.spaceBetweenItems,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index < earnings.length) {
          return EarningsListItem(earning: earnings[index]);
        } else if (isLoading && hasMore) {
          return const EarningsListItemShimmer();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
