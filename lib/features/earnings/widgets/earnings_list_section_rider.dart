// features/earnings/widgets/earnings_list_section.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/sizes.dart';
import '../models/earnings_model.dart';
import '../providers/earnings_providers.dart';
import '../state/earnings_rider_state.dart';
import 'earnings_list_item.dart';

class EarningsListSection extends ConsumerStatefulWidget {
  const EarningsListSection({super.key});

  @override
  ConsumerState<EarningsListSection> createState() =>
      _EarningsListSectionState();
}

class _EarningsListSectionState extends ConsumerState<EarningsListSection> {
  Timer? _loadMoreTimer;
  bool _isRequestingMore = false;

  @override
  void dispose() {
    _loadMoreTimer?.cancel();
    super.dispose();
  }

  //  Pagination: Trigger loadMore when scrolling near bottom
  void _onScroll(EarningsRiderState state, ScrollMetrics metrics) {
    if (state.isLoading || !state.hasMore || _isRequestingMore) {
      return;
    }

    final double maxScroll = metrics.maxScrollExtent;
    final double currentScroll = metrics.pixels;

    if (currentScroll >= maxScroll - 200) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted &&
            !state.isLoading &&
            state.hasMore &&
            !_isRequestingMore) {
          _isRequestingMore = true;
          ref
              .read(riderEarningsProvider.notifier)
              .loadMore()
              .then((_) {
                if (mounted) {
                  _isRequestingMore = false;
                }
              })
              .catchError((_) {
                if (mounted) {
                  _isRequestingMore = false;
                }
              });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final EarningsRiderState state = ref.watch(riderEarningsProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          _onScroll(state, notification.metrics);
        }
        return false;
      },
      child: SliverList.separated(
        //  REMOVED: controller parameter (not supported by SliverList)
        itemCount: state.earnings.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) =>
            const SizedBox(height: AppSizes.spaceBetweenItems),
        itemBuilder: (BuildContext context, int index) {
          //  Show loading indicator at end when loading more
          if (index == state.earnings.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final EarningsModel earning = state.earnings[index];
          return EarningsListItem(earning: earning);
        },
      ),
    );
  }
}
