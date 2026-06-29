// features/riders/jobs/screens/home_rider_screen.dart

import 'dart:async';

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/core/extensions/context_extensions.dart';
import 'package:drop_n_fresh/features/home/rider/models/jobs_request_model.dart';
import 'package:drop_n_fresh/features/home/rider/providers/home_rider_providers.dart';
import 'package:drop_n_fresh/features/home/rider/state/jobs_requests_state.dart';
import 'package:drop_n_fresh/features/home/rider/widgets/jobs_rq_list_item.dart';
import 'package:drop_n_fresh/features/home/rider/widgets/shimmer/jobs_request_shimmer.dart';
import 'package:drop_n_fresh/features/location/widgets/update_location_tile.dart';
import 'package:drop_n_fresh/shared/widgets/custom_refresh_indicator.dart';
import 'package:drop_n_fresh/shared/widgets/offline_content.dart';
import 'package:drop_n_fresh/shared/widgets/rider_home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeRiderScreen extends ConsumerStatefulWidget {
  const HomeRiderScreen({super.key});

  @override
  ConsumerState<HomeRiderScreen> createState() => _HomeRiderScreenState();
}

class _HomeRiderScreenState extends ConsumerState<HomeRiderScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _loadMoreTimer;
  bool _isRequestingMore = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _loadMoreTimer?.cancel();
    super.dispose();
  }

  //  Pagination: Trigger loadMore when scrolling near bottom
  void _onScroll(JobsRequestsState state) {
    // Don't load if already loading, no more pages, or already requesting
    if (state.isLoading || !state.hasMore || _isRequestingMore) {
      return;
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    // Trigger when within 200px of bottom
    if (currentScroll >= maxScroll - 200) {
      // Debounce to avoid multiple rapid calls
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted &&
            !state.isLoading &&
            state.hasMore &&
            !_isRequestingMore) {
          _isRequestingMore = true;
          ref
              .read(jobsRequestsProvider.notifier)
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
    final JobsRequestsState state = ref.watch(jobsRequestsProvider);
    final bool onlineStatus = ref.watch(onlineStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontal,
            vertical: AppSizes.screenVertical,
          ),
          child: CustomRefreshIndicator(
            onRefresh: () => ref.read(jobsRequestsProvider.notifier).refresh(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollUpdateNotification && onlineStatus) {
                  _onScroll(state);
                }
                return false;
              },
              child: _buildBody(state, onlineStatus),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(JobsRequestsState state, bool onlineStatus) {
    if (!onlineStatus) {
      return _buildOfflineContent(context);
    }

    if (state.isLoading) {
      return _buildShimmerContent();
    }

    if (state.error != null) {
      return _buildErrorContent(
        error: state.error!,
        onRetry: () => ref.read(jobsRequestsProvider.notifier).refresh(),
      );
    }

    return _buildOnlineContent(state);
  }

  Widget _buildShimmerContent() {
    return CustomScrollView(
      controller: _scrollController, //  Attach for pagination
      slivers: <Widget>[
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.spaceBetweenItems),
        ),
        SliverList.separated(
          itemCount: 6,
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppSizes.spaceBetweenItems),
          itemBuilder: (_, _) => const JobsRequestShimmer(),
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
            style: AppTextStyles.subTitle1.copyWith(color: AppColors.title),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 120,
            child: OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const RiderHomeAppBar(),
          SizedBox(
            height: context.screenHeight - 200,
            child: const Center(child: OfflineContent()),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineContent(JobsRequestsState state) {
    return CustomScrollView(
      controller: _scrollController, //  Attach for pagination
      slivers: <Widget>[
        const SliverToBoxAdapter(child: RiderHomeAppBar()),
        const SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: AppSizes.sm),
              UpdateLocationTile(),
              SizedBox(height: AppSizes.spaceBetweenItems),
            ],
          ),
        ),

        if (state.requests.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Available Jobs", style: AppTextStyles.heading3),
              ],
            ),
          ),
        if (state.requests.isEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: context.screenHeight * .6,
              child: Center(
                child: Text(
                  "No Job Request Available",
                  style: AppTextStyles.paragraph0,
                ),
              ),
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.spaceBetweenItems),
        ),

        SliverList.separated(
          itemCount: state.requests.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: AppSizes.md),
          itemBuilder: (BuildContext context, int index) {
            if (index == state.requests.length && state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final JobsRequestModel request = state.requests[index];
            return JobsRqListItem(
              service: request,
              onAcceptCallback: () {
                // Handle accept action
                if (ref
                    .watch(
                      jobsRequestsProvider,
                    )
                    .acceptLoading
                    .loading) {
                  return;
                }
                ref.read(jobsRequestsProvider.notifier).acceptJob(request.id);
              },
              onCancelCallback: () {
                // Handle cancel action
                ref.read(jobsRequestsProvider.notifier).cancelJob(request.id);
              },
            );
          },
        ),
      ],
    );
  }
}
