// features/riders/jobs/screens/jobs_list_screen_by_status.dart

import 'dart:async';

import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/jobs/models/jobs_model.dart';
import 'package:drop_n_fresh/features/jobs/models/jobs_status_type.dart';
import 'package:drop_n_fresh/features/jobs/providers/jobs_providers.dart';
import 'package:drop_n_fresh/features/jobs/state/jobs_state.dart';
import 'package:drop_n_fresh/features/jobs/widgets/jobs_list_item.dart';
import 'package:drop_n_fresh/features/jobs/widgets/shimmer/jobs_item_shimmer.dart';
import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:drop_n_fresh/shared/widgets/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JobsListScreenByStatus extends ConsumerStatefulWidget {
  final JobStatusType type;

  const JobsListScreenByStatus({super.key, required this.type});

  @override
  ConsumerState<JobsListScreenByStatus> createState() =>
      _JobsListScreenByStatusState();
}

class _JobsListScreenByStatusState
    extends ConsumerState<JobsListScreenByStatus> {
  final ScrollController _scrollController = ScrollController();
  Timer? _loadMoreTimer;
  bool _isRequestingMore = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _loadMoreTimer?.cancel();
    super.dispose();
  }

  void _onScroll(JobsState state) {
    if (state.isLoading || !state.hasMore || _isRequestingMore) {
      return;
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted &&
            !state.isLoading &&
            state.hasMore &&
            !_isRequestingMore) {
          _isRequestingMore = true;
          ref
              .read(jobsProvider(widget.type).notifier)
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
    final JobsState state = ref.watch(jobsProvider(widget.type));

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.type.typeToTitle,
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontal,
          vertical: AppSizes.screenVertical,
        ),
        child: CustomRefreshIndicator(
          onRefresh: () =>
              ref.read(jobsProvider(widget.type).notifier).refresh(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                _onScroll(state);
              }
              return false;
            },
            child: _buildBody(state),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(JobsState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return _buildShimmerContent();
    }

    if (state.error != null) {
      return _buildErrorContent(
        error: state.error!,
        onRetry: () => ref.read(jobsProvider(widget.type).notifier).refresh(),
      );
    }

    if (state.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No jobs found',
              style: AppTextStyles.paragraph0,
            ),
          ],
        ),
      );
    }

    return _buildContent(state);
  }

  Widget _buildShimmerContent() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverList.separated(
          itemCount: 6,
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppSizes.spaceBetweenItems),
          itemBuilder: (_, _) => const JobsItemShimmer(),
        ),
      ],
    );
  }

  Widget _buildErrorContent({
    required String error,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48, color: AppColors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load jobs',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.body,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildContent(JobsState state) {
    return CustomScrollView(
      controller: _scrollController, //  Attach for pagination
      slivers: <Widget>[
        SliverList.separated(
          itemCount: state.orders.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppSizes.spaceBetweenItems),
          itemBuilder: (BuildContext context, int index) {
            //  Show loading indicator at end when loading more
            if (index == state.orders.length && state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final JobsModel job = state.orders[index];
            return JobsListItem(
              jobs: job,
              type: widget.type,
              onTapCallback: () {
                if (widget.type != JobStatusType.newOrders) {
                  context.push(
                    RoutePaths.riderJobsDetails,
                    extra: job.id,
                  );
                }
              },
              onAcceptCallback: () {
                // Handle accept action
                if (ref
                    .watch(
                      jobsProvider(widget.type),
                    )
                    .acceptLoading
                    .loading) {
                  return;
                }
                ref.read(jobsProvider(widget.type).notifier).acceptJob(job.id);
              },
              onCancelCallback: () {
                // Handle cancel action
                ref.read(jobsProvider(widget.type).notifier).cancelJob(job.id);
              },
            );
          },
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSizes.spaceBetweenSections,
          ),
        ),
      ],
    );
  }
}
