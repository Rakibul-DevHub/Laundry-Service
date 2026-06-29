import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/widgets/app_elevated_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_refresh_indicator.dart';
import '../providers/bags_providers.dart';
import '../state/my_bags_state.dart';
import '../widgets/my_bag_item.dart';
import '../widgets/shimmer/my_bag_item_shimmer.dart';

class MyBagsScreen extends ConsumerWidget {
  const MyBagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("MY BAGS SCREEN BUILD");
    return Scaffold(
      appBar: const CustomAppBar(
        title: "My Bags",
        showBackBtn: false,
        titleAlignment: TitleAlignment.left,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontal,
          vertical: AppSizes.screenVertical,
        ),
        child: CustomRefreshIndicator(
          onRefresh: () async {
            ref.read(myBagProvider.notifier).refresh();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Text(
                  "Track and review your orders",
                  style: AppTextStyles.heading3,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.spaceBetweenItems,
                ),
              ),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final MyBagsState state = ref.watch(
                    myBagProvider.select((MyBagsState state) => state),
                  );
                  if (state.isLoading) {
                    return SliverList.separated(
                      itemCount: 4,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: AppSizes.md),
                      itemBuilder: (BuildContext context, int index) {
                        return const MyBagItemShimmer();
                      },
                    );
                  } else if (state.error != null) {
                    SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(state.error!),
                            ElevatedButton(
                              onPressed: () {},
                              // onPressed: () => ref.read(myBagProvider.notifier).refresh(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: state.bags.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: AppSizes.md),
                    itemBuilder: (BuildContext context, int index) {
                      return MyBagItem(
                        bag: state.bags[index],
                      );
                    },
                  );
                },
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.spaceBetweenItems,
                ),
              ),

              SliverToBoxAdapter(
                child: AppElevatedButton(
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 20,
                  ),
                  label: "Order Bag",
                  onPressed: () {
                    context.push(RoutePaths.userOrderBag);
                  },
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.spaceBetweenItems,
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.paste50,
                    border: Border.all(color: AppColors.primary, width: 1.0),
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusXl,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "About your bags:",
                        style: AppTextStyles.heading5,
                      ),
                      Text(
                        "Each Drop n Fresh bag has a unique QR code that tracks your order from pickup to delivery. Keep your bags safe and ready for your next laundry service.",
                        style: AppTextStyles.paragraph0.copyWith(
                          color: AppColors.body,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.spaceBetweenItems,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
