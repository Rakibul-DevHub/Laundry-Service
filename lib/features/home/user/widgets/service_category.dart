import 'package:drop_n_fresh/features/bottom_nav/provider/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../../../services/shared/models/service_category_model.dart';
import '../../../services/shared/providers/service_category_provider.dart';

class ServiceCategoryWidget extends ConsumerWidget {
  const ServiceCategoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ServiceCategory>> categoriesAsync = ref.watch(
      serviceCategoryProvider,
    );

    return categoriesAsync.when(
      // Loading state: Show shimmer placeholders in grid
      loading: () => _buildCategoryShimmerGrid(context),

      // Error state: Show retry option
      error: (Object error, StackTrace stack) => _buildCategoryError(
        error: ExceptionHandler.errorMessage(error),
        onRetry: () =>
            ref.read(serviceCategoryProvider.notifier).fetchCategories(),
      ),

      // Data state: Show actual categories in staggered grid
      data: (List<ServiceCategory> categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildCategoryGrid(categories, ref);
      },
    );
  }

  /// Build staggered grid for categories
  Widget _buildCategoryGrid(
    List<ServiceCategory> categories,
    WidgetRef ref,
  ) {
    return MasonryGridView.builder(
      mainAxisSpacing: AppSizes.sm,
      crossAxisSpacing: AppSizes.sm,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        final ServiceCategory category = categories[index];
        return ServiceCategoryItem(
          categoryName: category.name,
          iconPath: category.icon,
          onTapCallback: () {
            ref.read(bottomNavProvider.notifier).setIndex(1);
          },
        );
      },
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  /// Build shimmer loading state for grid layout
  Widget _buildCategoryShimmerGrid(BuildContext context) {
    final int crossAxisCount = MediaQuery.of(context).size.width >= 600 ? 4 : 3;
    final int placeholderCount =
        crossAxisCount * 2; // Show 2 rows of placeholders

    return MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: AppSizes.sm,
      crossAxisSpacing: AppSizes.sm,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: placeholderCount,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Icon placeholder
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                // Text placeholder (variable width for staggered effect)
                Container(
                  width: 50 + (index % 3) * 15, // Vary width for natural look
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryError({
    required String error,
    required VoidCallback onRetry,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: <Widget>[
          const Icon(Icons.error_outline, color: AppColors.red, size: 32),
          const SizedBox(height: 8),
          Text(
            'Failed to load categories',
            style: AppTextStyles.paragraph1.copyWith(color: AppColors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            error,
            style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 120,
            child: AppOutlineButton(
              onPressed: onRetry,
              label: 'Retry',
              height: 36,
              outlineColor: AppColors.red,
              textColor: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCategoryItem extends ConsumerWidget {
  final String categoryName;
  final String iconPath;
  final VoidCallback onTapCallback;

  const ServiceCategoryItem({
    super.key,
    required this.categoryName,
    required this.iconPath,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.body, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AssetLoader(
              assetPath: iconPath,
              width: 40,
              height: 40,
            ),
            const SizedBox(height: 8),
            Text(
              categoryName,
              maxLines: 1, // Reduced for better grid fit
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // Slightly smaller for grid density
              ),
            ),
          ],
        ),
      ),
    );
  }
}
