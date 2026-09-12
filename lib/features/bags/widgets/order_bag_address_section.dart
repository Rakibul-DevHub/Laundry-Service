import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../shared/widgets/app_elevated_button.dart';
import '../../../shared/widgets/app_outline_button.dart';
import '../../profile/model/user_location_model.dart';
import '../../profile/notifier/user_location_notifier.dart';
import '../../profile/state/user_location_state.dart';
import '../providers/bags_providers.dart';
import '../state/order_bag_state.dart';

class OrderBagAddressSection extends ConsumerStatefulWidget {
  const OrderBagAddressSection({super.key});

  @override
  ConsumerState<OrderBagAddressSection> createState() =>
      _OrderBagAddressSectionState();
}

class _OrderBagAddressSectionState
    extends ConsumerState<OrderBagAddressSection> {
  final List<String> _orderIds = <String>[];

  Future<void> _openAddLocation() async {
    final Set<String> existingIds = _orderIds.toSet();
    await context.push(RoutePaths.userAddressAdd);
    if (!mounted) {
      return;
    }
    await ref.read(userLocationProvider.notifier).refresh();
    if (!mounted) {
      return;
    }
    final UserLocation? addedLocation = ref
        .read(userLocationProvider)
        .savedLocations
        .where((UserLocation location) => !existingIds.contains(location.id))
        .lastOrNull;
    if (addedLocation != null) {
      ref.read(orderBagProvider.notifier).selectLocation(addedLocation.id);
    }
  }

  void _selectLocation(UserLocation location) {
    ref.read(orderBagProvider.notifier).selectLocation(location.id);
  }

  List<UserLocation> _orderedLocations(List<UserLocation> locations) {
    final Map<String, UserLocation> byId = <String, UserLocation>{
      for (final UserLocation location in locations) location.id: location,
    };
    final List<UserLocation> ordered = <UserLocation>[];
    for (final String id in _orderIds) {
      final UserLocation? location = byId.remove(id);
      if (location != null) {
        ordered.add(location);
      }
    }
    ordered.addAll(byId.values);
    _orderIds
      ..clear()
      ..addAll(ordered.map((UserLocation location) => location.id));
    return ordered;
  }

  String? _resolveSelectedId(
    List<UserLocation> locations,
    String? selectedLocationId,
  ) {
    if (selectedLocationId != null &&
        locations.any(
          (UserLocation location) => location.id == selectedLocationId,
        )) {
      return selectedLocationId;
    }
    return locations
            .where((UserLocation location) => location.isDefault)
            .firstOrNull
            ?.id ??
        locations.firstOrNull?.id;
  }

  @override
  Widget build(BuildContext context) {
    final UserLocationState state = ref.watch(userLocationProvider);
    final String? selectedLocationId = ref.watch(
      orderBagProvider.select(
        (OrderBagState orderState) => orderState.selectedLocationId,
      ),
    );
    final List<UserLocation> locations = _orderedLocations(
      state.savedLocations,
    );
    final String? selectedId = _resolveSelectedId(
      locations,
      selectedLocationId,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text('Delivery address', style: AppTextStyles.heading5),
            ),
            TextButton.icon(
              onPressed: _openAddLocation,
              icon: const Icon(
                Icons.add_location_alt_outlined,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
              label: Text(
                'Add',
                style: AppTextStyles.heading5.copyWith(
                  color: AppColors.primary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        if (state.isLoading && locations.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.md),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state.error != null && locations.isEmpty)
          _AddressError(
            message: state.error!,
            onRetry: () =>
                ref.read(userLocationProvider.notifier).fetchSavedLocations(),
          )
        else if (locations.isEmpty)
          _EmptyAddressPrompt(onAdd: _openAddLocation)
        else
          Column(
            children: locations.map((UserLocation location) {
              return _AddressOption(
                key: ValueKey<String>(location.id),
                location: location,
                selectedId: selectedId,
                onSelect: () => _selectLocation(location),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _AddressOption extends StatelessWidget {
  const _AddressOption({
    super.key,
    required this.location,
    required this.selectedId,
    required this.onSelect,
  });

  final UserLocation location;
  final String? selectedId;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = location.id == selectedId;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.md,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.body.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                Radio<String>(
                  value: location.id,
                  // ignore: deprecated_member_use
                  groupValue: selectedId,
                  // ignore: deprecated_member_use
                  onChanged: (_) => onSelect(),
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              location.name,
                              style: AppTextStyles.heading5.copyWith(
                                color: AppColors.title,
                              ),
                            ),
                          ),
                          if (location.isDefault) ...<Widget>[
                            const SizedBox(width: AppSizes.sm),
                            const _AddressBadge(label: 'Default'),
                          ],
                          if (isSelected) ...<Widget>[
                            const SizedBox(width: AppSizes.sm),
                            const _AddressBadge(label: 'Selected'),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        location.address,
                        style: AppTextStyles.paragraph1.copyWith(
                          color: AppColors.body,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressBadge extends StatelessWidget {
  const _AddressBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.paragraph3.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyAddressPrompt extends StatelessWidget {
  const _EmptyAddressPrompt({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Add an address so we can deliver your bag.',
          style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
        ),
        const SizedBox(height: AppSizes.md),
        AppElevatedButton(
          label: 'Add address',
          onPressed: onAdd,
          icon: const Icon(
            Icons.add_location_alt_outlined,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}

class _AddressError extends StatelessWidget {
  const _AddressError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Could not load saved addresses.',
          style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          message,
          style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          width: 120,
          child: AppOutlineButton(label: 'Retry', onPressed: onRetry),
        ),
      ],
    );
  }
}
