import 'package:carousel_slider/carousel_slider.dart';
import 'package:drop_n_fresh/features/bags/providers/bags_providers.dart';
import 'package:drop_n_fresh/features/bags/state/my_bags_state.dart';
import 'package:drop_n_fresh/features/home/user/models/banner_model.dart';
import 'package:drop_n_fresh/features/home/user/notifier/banners_notifier.dart';
import 'package:drop_n_fresh/features/home/user/state/banners_state.dart';
import 'package:drop_n_fresh/features/home/user/widgets/banner_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/icons.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../models/default_location_model.dart';
import '../notifier/default_location_notifier.dart';
import '../widgets/service_category.dart';

class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontal,
            vertical: AppSizes.screenVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Pickup Address
              const HomeTopSection(),
              const SizedBox(height: AppSizes.md),

              // Image
              const HomeBannerSection(),
              const SizedBox(height: AppSizes.spaceBetweenItems),

              // I'm Looking For Section
              Text(
                "I'm Looking For",
                style: AppTextStyles.heading4,
              ),
              const SizedBox(height: AppSizes.spaceBetweenItems),

              const ServiceCategoryWidget(),

              const SizedBox(height: AppSizes.spaceBetweenItems),
              const HomeBagSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBannerSection extends ConsumerWidget {
  final double height;

  const HomeBannerSection({
    super.key,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BannersState state = ref.watch(bannersProvider);
    final BannersNotifier notifier = ref.read(bannersProvider.notifier);

    if (state.isLoading) {
      return _buildShimmerBanner();
    }

    if (state.error != null) {
      return _buildErrorBanner(
        error: state.error!,
        onRetry: notifier.refresh,
      );
    }

    if (state.banners.isEmpty) {
      return _buildEmptyBanner();
    }

    return _buildBannerCarousel(state, notifier);
  }

  Widget _buildShimmerBanner() {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.screenHorizontal),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      // child: const CustomShimmer(
      //   borderRadius: BorderRadius.all(Radius.circular(12)),
      // ),
    );
  }

  Widget _buildErrorBanner({
    required String error,
    required VoidCallback onRetry,
  }) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.screenHorizontal),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.body.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load banners',
              style: TextStyle(
                color: AppColors.body.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBanner() {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.screenHorizontal),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'No banners available',
          style: TextStyle(color: AppColors.body),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(BannersState state, BannersNotifier notifier) {
    final List<BannerModel> uniqueBanners = state.banners
        .fold<List<BannerModel>>(<BannerModel>[], (
          List<BannerModel> prev,
          BannerModel item,
        ) {
          if (!prev.any((BannerModel b) => b.id == item.id)) {
            prev.add(item);
          }
          return prev;
        });

    if (uniqueBanners.length == 1) {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.xs,
        ),
        child: BannerItem(banner: uniqueBanners.first, height: height),
      );
    }

    // Multiple banners: carousel with FULL WIDTH items
    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
        viewportFraction: 1.0,
        disableCenter: true,
        pageSnapping: true,
        enableInfiniteScroll: uniqueBanners.length > 1,
        onPageChanged: (int index, CarouselPageChangedReason reason) =>
            notifier.updatePage(index),
      ),
      items: uniqueBanners.map((BannerModel banner) {
        return BannerItem(banner: banner, height: height);
      }).toList(),
    );
  }
}

class HomeTopSection extends ConsumerWidget {
  const HomeTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserLocation?> locationAsync = ref.watch(
      defaultLocationProvider,
    );
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () => context.push(RoutePaths.userAddressInfo),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Default address',
                        style: AppTextStyles.subTitle1.copyWith(
                          color: AppColors.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  locationAsync.when(
                    loading: () => _buildLoadingPlaceholder(),
                    error: (_, _) => _buildDefaultPlaceholder(context),
                    data: (UserLocation? location) {
                      if (location == null) {
                        return _buildDefaultPlaceholder(context);
                      }
                      return _buildLocationDisplay(location);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => context.push(RoutePaths.notification),
          borderRadius: BorderRadius.circular(
            AppSizes.borderRadiusMd,
          ),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AppColors.paste50,
              border: Border.all(color: AppColors.body, width: 1.0),
              borderRadius: BorderRadius.circular(
                AppSizes.borderRadiusMd,
              ),
            ),
            child: const AssetLoader(
              assetPath: AppIcons.notification,
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
        const SizedBox(
          width: AppSizes.sm,
        ),
        GestureDetector(
          onTap: () {
            context.push(RoutePaths.conversations);
          },
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AppColors.paste50,
              border: Border.all(color: AppColors.body, width: 1.0),
              borderRadius: BorderRadius.circular(
                AppSizes.borderRadiusMd,
              ),
            ),
            child: const AssetLoader(
              assetPath: AppIcons.chat,
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      height: 16,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.userAddressInfo),
      child: Text(
        "Set your location",
        style: AppTextStyles.paragraph0.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildLocationDisplay(UserLocation location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          location.name,
          style: AppTextStyles.paragraph0.copyWith(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
// ── Widget ────────────────────────────────────────────────────────────────────

class HomeBagSection extends ConsumerWidget {
  const HomeBagSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyBagsState state = ref.watch(myBagProvider);

    // Loading — match your shimmer style from HomeBannerSection
    if (state.isLoading) {
      return _BagShimmer();
    }

    // Error — silent fail, don't break home screen
    if (state.error != null) {
      return const SizedBox.shrink();
    }

    // Has bags — don't show promo
    if (state.bags.isNotEmpty) {
      return const SizedBox.shrink();
    }

    // Empty — show free bag promo
    return const _FreeBagCard();
  }
}

// ── Shimmer placeholder ───────────────────────────────────────────────────────

class _BagShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      ),
    );
  }
}

// ── Free bag promo card ───────────────────────────────────────────────────────

class _FreeBagCard extends StatelessWidget {
  const _FreeBagCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        // Soft gradient-like layered look using your paste50 palette
        color: AppColors.primary.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          // Text side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'New user offer',
                    style: AppTextStyles.subTitle2.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Get your first bag free!',
                  style: AppTextStyles.heading4,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Order a reusable bag and start fresh.',
                  style: AppTextStyles.paragraph1.copyWith(
                    color: AppColors.body,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Before placing an order, please ensure your bag is at home.',
                  style: AppTextStyles.paragraph1.copyWith(
                    color: AppColors.body,
                  ),
                ),
                const SizedBox(height: 12),

                _OrderBagButton(),
              ],
            ),
          ),

          // CTA button
        ],
      ),
    );
  }
}

// ── Order bag button ──────────────────────────────────────────────────────────

class _OrderBagButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(RoutePaths.userOrderBag);
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        ),
        child: Text(
          'Order',
          style: AppTextStyles.subTitle1.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
