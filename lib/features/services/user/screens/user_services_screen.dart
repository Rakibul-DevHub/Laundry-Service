import 'dart:async';

import 'package:drop_n_fresh/features/services/user/notifier/user_services_notifier.dart';
import 'package:drop_n_fresh/shared/widgets/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../providers/user_services_providers.dart';
import '../state/user_services_state.dart';
import '../widgets/shimmer/user_service_shimmer.dart';
import '../widgets/user_service_item.dart';

class UserServicesScreen extends ConsumerStatefulWidget {
  const UserServicesScreen({super.key});

  @override
  ConsumerState<UserServicesScreen> createState() => _UserServicesScreenState();
}

class _UserServicesScreenState extends ConsumerState<UserServicesScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _loadMoreTimer;
  bool _isRequestingMore = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _loadMoreTimer?.cancel();
    super.dispose();
  }

  void _onScroll(UserServicesState state, UserServicesNotifier notifier) {
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
          _loadMore(notifier);
        }
      });
    }
  }

  Future<void> _loadMore(UserServicesNotifier notifier) async {
    if (_isRequestingMore) {
      return;
    }

    _isRequestingMore = true;
    try {
      await notifier.loadMore();
    } finally {
      _isRequestingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserServicesState state = ref.watch(userServicesProvider);
    final UserServicesNotifier notifier = ref.read(
      userServicesProvider.notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontal,
            vertical: AppSizes.screenVertical,
          ),
          child: CustomRefreshIndicator(
            onRefresh: () => notifier.refresh(),
            child: _buildBody(state, notifier),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(UserServicesState state, UserServicesNotifier notifier) {
    if (state.isLoading && state.services.isEmpty) {
      return _buildShimmerContent();
    }

    if (state.error != null) {
      return _buildErrorContent(
        error: state.error!,
        onRetry: () => notifier.refresh(),
      );
    }

    if (state.services.isEmpty) {
      return _buildEmptyContent();
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          _onScroll(state, notifier);
        }
        return false;
      },
      child: _buildContent(state, notifier),
    );
  }

  Widget _buildShimmerContent() {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverToBoxAdapter(
          child: SizedBox(height: 8),
        ),
        SliverList.separated(
          itemCount: 6,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: AppSizes.sm),
          itemBuilder: (BuildContext context, int index) =>
              const UserServiceShimmer(),
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
            'Failed to load services',
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

  Widget _buildEmptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.cleaning_services, size: 64, color: AppColors.body),
          const SizedBox(height: 16),
          Text(
            'No services available',
            style: AppTextStyles.subTitle1.copyWith(color: AppColors.title),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for available providers',
            style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(UserServicesState state, UserServicesNotifier notifier) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        // Header
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Discover services near by you',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 4),
              Text(
                '${state.services.length} services found',
                style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
              ),
              const SizedBox(height: AppSizes.spaceBetweenItems),
            ],
          ),
        ),

        // Services List
        SliverList.separated(
          itemCount: state.services.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: AppSizes.sm),
          itemBuilder: (BuildContext context, int index) {
            if (index == state.services.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return UserServiceItem(service: state.services[index]);
          },
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }
}

extension on UserServicesState {
  bool get hasMore => currentPage < totalPages;
}
