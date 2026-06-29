// features/location/user/screens/user_locations_screen.dart

import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:drop_n_fresh/shared/widgets/app_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_refresh_indicator.dart';
import '../../model/user_location_model.dart';
import '../../notifier/user_location_notifier.dart';
import '../../state/user_location_state.dart';
import '../../widgets/shimmer/location_shimmer.dart';
import '../../widgets/user_location_item.dart';

class UserAddressInfoScreen extends ConsumerWidget {
  const UserAddressInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserLocationState state = ref.watch(userLocationProvider);
    final UserLocationNotifier notifier = ref.read(
      userLocationProvider.notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "My Locations",
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_location, color: AppColors.primary),
            onPressed: () => context.push(RoutePaths.userAddressAdd),
            tooltip: 'Add new location',
          ),
        ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: _buildBody(state, notifier, context),
      ),
    );
  }

  Widget _buildBody(
    UserLocationState state,
    UserLocationNotifier notifier,
    BuildContext context,
  ) {
    // Loading state
    if (state.isLoading && state.savedLocations.isEmpty) {
      return _buildShimmerContent();
    }
    // Error state
    if (state.error != null) {
      return _buildErrorContent(
        error: state.error!,
        onRetry: () => notifier.fetchSavedLocations(),
      );
    }

    // Empty state
    if (state.savedLocations.isEmpty) {
      return _buildEmptyContent(
        onAdd: () => context.push(RoutePaths.userAddressAdd),
      );
    }

    // Success state
    return _buildContent(state, notifier);
  }

  Widget _buildShimmerContent() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (BuildContext context, int index) => const LocationShimmer(),
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
          const Icon(Icons.location_off, size: 64, color: AppColors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load locations',
            style: AppTextStyles.heading4.copyWith(color: AppColors.title),
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
            child: AppOutlineButton(label: "Retry", onPressed: onRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyContent({required VoidCallback onAdd}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.location_on, size: 64, color: AppColors.body),
            const SizedBox(height: 16),
            Text(
              'No saved locations',
              style: AppTextStyles.heading4.copyWith(color: AppColors.title),
            ),
            const SizedBox(height: 8),
            Text(
              'Save your home, work, or favorite places',
              style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppElevatedButton(
              label: "Add Location",
              onPressed: onAdd,
              icon: const Icon(
                Icons.add_location,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(UserLocationState state, UserLocationNotifier notifier) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.savedLocations.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == state.savedLocations.length) {
          return Column(
            children: <Widget>[
              const SizedBox(
                height: AppSizes.md,
              ),
              AppElevatedButton(
                label: "Add Location",
                onPressed: () {
                  context.push(RoutePaths.userAddressAdd);
                },
              ),
            ],
          );
        }
        final UserLocation location = state.savedLocations[index];
        return UserLocationItem(
          location: location,
          isDefault: state.isDefault(location.id),
          onSetDefault: () => notifier.setDefaultLocation(location.id),
          onDelete: () => _confirmDelete(context, notifier, location.id),
          onTap: () => _handleLocationSelect(context, location),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    UserLocationNotifier notifier,
    String locationId,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Location'),
        content: const Text('Are you sure you want to delete this location?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await notifier.deleteLocation(locationId);
    }
  }

  void _handleLocationSelect(BuildContext context, UserLocation location) {
    // Return selected location to previous screen if navigating back
    // if (context.mounted) {
    //   context.pop(location);
    // }
  }
}
