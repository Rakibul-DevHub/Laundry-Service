import 'package:drop_n_fresh/features/services/provider/models/service_list_response.dart';
import 'package:drop_n_fresh/shared/widgets/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/service_providers.dart';
import '../widgets/service_list_item.dart';
import '../widgets/shimmer/service_shimmer.dart';

class ProviderServicesScreen extends ConsumerWidget {
  const ProviderServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ProviderService>> servicesAsync = ref.watch(
      servicesListProvider,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Services",
        showBackBtn: false,
        titleAlignment: TitleAlignment.left,
        actions: <Widget>[
          AppOutlineButton(
            onPressed: () {
              context.push(RoutePaths.createService);
            },
            label: "Add New Service",
            width: 100,
            height: 40,
            outlineColor: AppColors.green,
            backgroundColor: AppColors.green50,
            icon: const Icon(
              Icons.add,
              color: AppColors.green,
            ),
          ),
          const SizedBox(
            width: AppSizes.sm,
          ),
        ],
      ),
      backgroundColor: AppColors.white,
      body: servicesAsync.when(
        loading: () => ListView.separated(
          itemCount: 6,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: AppSizes.sm),
          itemBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: ServiceShimmer(),
            );
          },
        ),
        error: (Object error, StackTrace stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error', style: AppTextStyles.paragraph1),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(servicesListProvider.notifier).fetchServices(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (List<ProviderService> services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.cleaning_services,
                    size: 64,
                    color: AppColors.body,
                  ),
                  const SizedBox(height: 16),
                  Text('No services yet', style: AppTextStyles.heading5),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first service to get started',
                    style: AppTextStyles.paragraph1,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push(RoutePaths.createService),
                    icon: const Icon(Icons.add, color: AppColors.white),
                    label: const Text(
                      'Create Service',
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomRefreshIndicator(
            onRefresh: () =>
                ref.read(servicesListProvider.notifier).fetchServices(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: services.length,
              itemBuilder: (BuildContext context, int index) =>
                  ServiceListItem(service: services[index]),
            ),
          );
        },
      ),
    );
  }
}
