import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/custom_refresh_indicator.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../shared/widgets/offline_content.dart';
import '../../../shared/widgets/rider_home_app_bar.dart';
import '../../home/rider/providers/home_rider_providers.dart';
import '../models/jobs_status_type.dart';
import '../providers/jobs_providers.dart';
import '../state/jobs_overview_state.dart';
import '../widgets/jobs_overview_item.dart';
import '../widgets/shimmer/jobs_overview_shimmer.dart';

class JobsScreen extends ConsumerWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final JobsOverviewState state = ref.watch(jobsOverviewProvider);
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
            onRefresh: () => ref.read(jobsOverviewProvider.notifier).refresh(),
            child: state.isLoading
                ? CustomScrollView(
                    slivers: <Widget>[
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppSizes.spaceBetweenItems,
                        ),
                      ),
                      SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return const JobsOverviewShimmer();
                        },
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppSizes.spaceBetweenItems,
                        ),
                      ),
                    ],
                  )
                : state.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(state.error!),
                        ElevatedButton(
                          onPressed: () =>
                              ref.read(jobsOverviewProvider.notifier).refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    slivers: <Widget>[
                      const SliverToBoxAdapter(
                        child: RiderHomeAppBar(
                          isChatVisible: true,
                        ),
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppSizes.spaceBetweenItems,
                        ),
                      ),

                      if (!onlineStatus)
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: context.screenHeight - 200,
                            child: const Center(child: OfflineContent()),
                          ),
                        ),
                      if (onlineStatus)
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: AppSizes.spaceBetweenItems,
                          ),
                        ),
                      if (onlineStatus)
                        SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 24,
                          childCount: 4,
                          itemBuilder: (BuildContext context, int index) {
                            switch (index) {
                              case 0:
                                return JobsOverviewItem(
                                  title: JobStatusType.newOrders.typeToTitle,
                                  value: state.overview!.newOrders,
                                  iconPath: JobStatusType.newOrders.typeToIcon,
                                  backgroundColor: AppColors.paste50,
                                  borderColor: AppColors.primary,
                                  textColor: AppColors.title,
                                  onTapCallBack: () {
                                    context.push(
                                      RoutePaths.riderJobsByStatus,

                                      extra: JobStatusType.newOrders,
                                    );
                                  },
                                );
                              case 1:
                                return JobsOverviewItem(
                                  title:
                                      JobStatusType.ongoingOrders.typeToTitle,
                                  value: state.overview!.ongoingOrders,
                                  iconPath:
                                      JobStatusType.ongoingOrders.typeToIcon,
                                  backgroundColor: AppColors.grey50,
                                  borderColor: AppColors.body,
                                  textColor: AppColors.title,
                                  onTapCallBack: () {
                                    context.push(
                                      RoutePaths.riderJobsByStatus,

                                      extra: JobStatusType.ongoingOrders,
                                    );
                                  },
                                );
                              case 2:
                                return JobsOverviewItem(
                                  title:
                                      JobStatusType.completedOrders.typeToTitle,
                                  value: state.overview!.completedOrders,
                                  iconPath:
                                      JobStatusType.completedOrders.typeToIcon,
                                  backgroundColor: AppColors.green50,
                                  borderColor: AppColors.green,
                                  textColor: AppColors.green,
                                  onTapCallBack: () {
                                    context.push(
                                      RoutePaths.riderJobsByStatus,

                                      extra: JobStatusType.completedOrders,
                                    );
                                  },
                                );
                              case 3:
                                return JobsOverviewItem(
                                  title:
                                      JobStatusType.canceledOrders.typeToTitle,
                                  value: state.overview!.cancelledOrders,
                                  iconPath:
                                      JobStatusType.canceledOrders.typeToIcon,
                                  backgroundColor: AppColors.red50,
                                  borderColor: AppColors.red,
                                  textColor: AppColors.red,
                                  onTapCallBack: () {
                                    context.push(
                                      RoutePaths.riderJobsByStatus,
                                      extra: JobStatusType.canceledOrders,
                                    );
                                  },
                                );
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
