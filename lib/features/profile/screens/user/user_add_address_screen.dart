// features/location/user/screens/add_location_screen.dart

import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/profile/state/user_location_state.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:drop_n_fresh/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../model/user_location_model.dart';
import '../../notifier/user_location_notifier.dart';
import '../../widgets/location_search_result.dart';

class UserAddAddressScreen extends ConsumerStatefulWidget {
  const UserAddAddressScreen({super.key});

  @override
  ConsumerState<UserAddAddressScreen> createState() =>
      _UserAddAddressScreenState();
}

class _UserAddAddressScreenState extends ConsumerState<UserAddAddressScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  SearchedLocation? _selectedLocation;
  final bool _isDefault = false;
  bool _showSearchResults = false;

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().length >= 2) {
      ref.read(userLocationProvider.notifier).searchLocations(query);
      setState(() => _showSearchResults = true);
    } else {
      ref.read(userLocationProvider.notifier).clearSearch();
      setState(() => _showSearchResults = false);
    }
  }

  void _selectLocation(SearchedLocation location) {
    setState(() {
      _selectedLocation = location;
      _showSearchResults = false;
      _searchController.text = location.address;
    });
  }

  Future<void> _saveLocation() async {
    if (_selectedLocation == null || _nameController.text.trim().isEmpty) {
      Toast.showWarning('Please select a location and enter a name');
      return;
    }

    final SaveLocationRequest request = SaveLocationRequest(
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      address: _selectedLocation!.address,
      name: _nameController.text.trim(),
      isDefault: _isDefault,
    );

    final bool success = await ref
        .read(userLocationProvider.notifier)
        .saveLocation(request);

    if (success && mounted) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserLocationState state = ref.watch(userLocationProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: 'Add Location',
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search Field
            Text(
              'Search Location *',
              style: AppTextStyles.heading5.copyWith(color: AppColors.title),
            ),
            const SizedBox(height: 8),
            AppTextField(
              labelText: "Search for address, landmark, or place",
              controller: _searchController,
              prefixIcon: const Icon(Icons.search, color: AppColors.body),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.body),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(userLocationProvider.notifier).clearSearch();
                        setState(() {
                          _selectedLocation = null;
                          _showSearchResults = false;
                        });
                      },
                    )
                  : null,
              onChanged: _onSearchChanged,
            ),
            const SizedBox(
              height: AppSizes.md,
            ),
            AppElevatedButton(
              icon: const Icon(
                Icons.location_searching_sharp,
                color: AppColors.white,
              ),
              label: "Set on map",
              onPressed: () async {
                final Map<String, dynamic>? result = await context.push(
                  RoutePaths.updateLocation,
                );

                if (result != null) {
                  _selectLocation(
                    SearchedLocation(
                      placeId: "placeId",
                      latitude: result['lat'] as double,
                      longitude: result['long'] as double,
                      name: "name",
                      address: result['address'] as String,
                    ),
                  );
                }
              },
            ),

            // Search Results Dropdown
            if (_showSearchResults) ...<Widget>[
              const SizedBox(height: 8),
              if (state.isSearching)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.searchError != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    state.searchError!,
                    style: AppTextStyles.paragraph2.copyWith(
                      color: AppColors.red,
                    ),
                  ),
                )
              else if (state.searchResults.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No results found'),
                )
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      color: AppColors.body.withValues(alpha: 0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      final SearchedLocation result =
                          state.searchResults[index];
                      return LocationSearchResult(
                        location: result,
                        onTap: () => _selectLocation(result),
                      );
                    },
                  ),
                ),
            ],

            // Selected Location Preview
            if (_selectedLocation != null) ...<Widget>[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.body,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Selected Location',
                          style: AppTextStyles.paragraph0.copyWith(
                            color: AppColors.title,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedLocation!.address,
                      style: AppTextStyles.paragraph1.copyWith(),
                    ),
                  ],
                ),
              ),
            ],

            // Custom Name Field
            const SizedBox(height: 24),
            Text(
              'Location Name *',
              style: AppTextStyles.heading5.copyWith(color: AppColors.title),
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _nameController,
              labelText: 'e.g., Home, Work, Gym, Office',
              onChanged: (String value) => setState(() {}),
            ),

            // // Set as Default Toggle
            // const SizedBox(height: 24),
            // SwitchListTile(
            //   title: Text(
            //     'Set as default location',
            //     style: AppTextStyles.heading4.copyWith(
            //       color: AppColors.title,
            //     ),
            //   ),
            //   subtitle: Text(
            //     'This location will be used by default for orders',
            //     style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
            //   ),
            //   value: _isDefault,
            //   onChanged: (bool value) => setState(() => _isDefault = value),
            //   activeThumbColor: AppColors.primary,
            //   contentPadding: EdgeInsets.zero,
            // ),
            // Save Button
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: AppElevatedButton(
                onPressed:
                    (_selectedLocation != null &&
                        _nameController.text.trim().isNotEmpty)
                    ? _saveLocation
                    : null,
                label: 'Save Location',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
