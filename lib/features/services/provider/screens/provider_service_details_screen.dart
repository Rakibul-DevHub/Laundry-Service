// features/services/provider/screens/provider_service_details_screen.dart

import 'package:drop_n_fresh/features/services/provider/models/service_list_response.dart';
import 'package:drop_n_fresh/features/services/provider/notifier/service_detail_notifier.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import '../models/service_model.dart';
import '../models/update_service_request.dart';
import '../providers/service_providers.dart';
import '../widgets/product_category_section.dart';

class ProviderServiceDetailsScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const ProviderServiceDetailsScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ProviderServiceDetailsScreen> createState() =>
      _ProviderServiceDetailsScreenState();
}

class _ProviderServiceDetailsScreenState
    extends ConsumerState<ProviderServiceDetailsScreen> {
  bool _isEditing = false;

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _estimateTimeController = TextEditingController();
  bool _isActive = true;
  bool _controllersInitialized = false;

  // Track edited items: Map<itemId, updated ServiceItem>
  final Map<String, ServiceItem> _editedItems = <String, ServiceItem>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(serviceDetailProvider(widget.serviceId).notifier)
          .refresh(widget.serviceId);
    });
  }

  void _initControllers(ProviderService service) {
    if (_controllersInitialized) {
      return;
    }
    _descriptionController = TextEditingController(text: service.description);
    _estimateTimeController = TextEditingController(text: service.estimateTime);
    _isActive = service.isActive;
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset edited items on cancel
        _editedItems.clear();
        _controllersInitialized = false;
      }
    });
  }

  void _updateItem(String itemId, ServiceItem updatedItem) {
    setState(() {
      _editedItems[itemId] = updatedItem;
    });
  }

  Future<void> _saveService() async {
    final ServiceDetailNotifier notifier = ref.read(
      serviceDetailProvider(widget.serviceId).notifier,
    );
    final ProviderService? originalService = ref
        .read(serviceDetailProvider(widget.serviceId))
        .value;

    if (originalService == null) {
      return;
    }

    final UpdateServiceRequest request = UpdateServiceRequest.full(
      description: _descriptionController.text.trim(),
      estimateTime: _estimateTimeController.text.trim(),
      isActive: _isActive,
      productCategories: originalService.productCategories.map((
        ProductCategoryWithItems cat,
      ) {
        final List<UpdateServiceItem> updatedItems = cat.items.map((
          ServiceItem item,
        ) {
          // Use edited item if exists, otherwise original
          final ServiceItem? edited = _editedItems[item.id];
          final ServiceItem finalItem = edited ?? item;
          return UpdateServiceItem(
            name: finalItem.name,
            price: finalItem.price,
          );
        }).toList();
        return UpdateProductCategory(
          id: cat.productCategory.id,
          items: updatedItems,
        );
      }).toList(),
    );

    final bool success = await notifier.updateService(
      widget.serviceId,
      request,
    );

    if (success && mounted) {
      _editedItems.clear();
      _toggleEditMode();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ProviderService? service = ref
        .read(serviceDetailProvider(widget.serviceId))
        .value;
    if (service != null && !_controllersInitialized) {
      _descriptionController = TextEditingController(text: service.description);
      _estimateTimeController = TextEditingController(
        text: service.estimateTime,
      );
      _isActive = service.isActive;
      _controllersInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ProviderService> serviceAsync = ref.watch(
      serviceDetailProvider(widget.serviceId),
    );
    ref.listen<AsyncValue<ProviderService>>(
      serviceDetailProvider(widget.serviceId),
      (
        AsyncValue<ProviderService>? previous,
        AsyncValue<ProviderService> next,
      ) {
        if (previous?.value == null && next.value != null) {
          _initControllers(next.value!);
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: _isEditing ? 'Edit Service' : 'Service Details',
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
        actions: _isEditing
            ? <Widget>[
                AppOutlineButton(
                  onPressed: _toggleEditMode,
                  label: "Cancel",
                  height: 36,
                  width: 20,
                  outlineColor: AppColors.body,
                  backgroundColor: AppColors.body.withValues(alpha: 0.1),
                  textColor: AppColors.body,
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppElevatedButton(
                    onPressed: _saveService,
                    label: 'Save',
                    height: 36,
                    width: 20,
                  ),
                ),
              ]
            : <Widget>[
                AppOutlineButton(
                  onPressed: () {
                    _toggleEditMode();
                    final ProviderService? service = serviceAsync.value;
                    if (service != null) {
                      _initControllers(service);
                    }
                  },
                  label: 'Edit',
                  height: 36,
                  width: 20,
                  outlineColor: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  textColor: AppColors.primary,
                ),
                const SizedBox(width: AppSizes.sm),
              ],
      ),
      body: serviceAsync.when(
        loading: () => _buildShimmerDetails(),
        error: (Object err, StackTrace stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 48, color: AppColors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $err',
                style: AppTextStyles.paragraph1.copyWith(
                  color: AppColors.red,
                ),
              ),
              const SizedBox(height: 24),
              AppOutlineButton(
                onPressed: () => ref
                    .read(serviceDetailProvider(widget.serviceId).notifier)
                    .refresh(widget.serviceId),
                label: 'Retry',
                outlineColor: AppColors.primary,
              ),
            ],
          ),
        ),
        data: (ProviderService service) {
          // if (!_controllersInitialized) {
          //   _initControllers(service);
          // }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ───────── HEADER CARD ─────────
                Card(
                  color: AppColors.white,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Icon
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AssetLoader(
                            assetPath: service.serviceCategory.icon,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                service.serviceCategory.name,
                                style: AppTextStyles.heading4.copyWith(
                                  color: AppColors.title,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.access_time,
                                    size: 24,
                                    color: AppColors.body,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    service.estimateTime,
                                    style: AppTextStyles.paragraph2.copyWith(
                                      color: AppColors.body,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ───────── SERVICE DETAILS SECTION ─────────
                Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Service Details',
                          style: AppTextStyles.subTitle1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        _buildEditableField(
                          label: 'Description',
                          value: _descriptionController.text,
                          isEditing: _isEditing,
                          onChanged: (String value) =>
                              _descriptionController.text = value,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        // Estimate Time
                        _buildEditableField(
                          label: 'Estimate Time',
                          value: _estimateTimeController.text,
                          isEditing: _isEditing,
                          onChanged: (String value) =>
                              _estimateTimeController.text = value,
                          prefixIcon: Icons.access_time,
                        ),
                        const SizedBox(height: 16),

                        // Active Status - SERVICE LEVEL ONLY
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Service Active',
                              style: AppTextStyles.paragraph1.copyWith(
                                color: AppColors.title,
                              ),
                            ),
                            if (_isEditing)
                              Switch(
                                value: _isActive,
                                activeThumbColor: AppColors.primary,
                                onChanged: (bool value) =>
                                    setState(() => _isActive = value),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _isActive
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : AppColors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _isActive ? '✓ Active' : '✗ Inactive',
                                  style: AppTextStyles.paragraph0.copyWith(
                                    color: _isActive
                                        ? Colors.green
                                        : AppColors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ───────── PRODUCT CATEGORIES ─────────
                Text(
                  'Product Categories',
                  style: AppTextStyles.subTitle1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                ...service.productCategories.map((
                  ProductCategoryWithItems category,
                ) {
                  return ServiceDetailCategorySection(
                    key: ValueKey<String>(category.id),
                    category: category,
                    isEditing: _isEditing,
                    editedItems: _editedItems,
                    onItemUpdate: _updateItem,
                  );
                }),

                const SizedBox(height: 24),
                AppOutlineButton(
                  label: "Delete",
                  outlineColor: AppColors.red,
                  onPressed: () {
                    ref
                        .read(serviceDetailProvider(widget.serviceId).notifier)
                        .deleteService(widget.serviceId);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required bool isEditing,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
        ),
        const SizedBox(height: 8),
        if (isEditing)
          TextFormField(
            initialValue: value,
            onChanged: onChanged,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColors.body)
                  : null,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            style: AppTextStyles.paragraph1,
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.body.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: AppTextStyles.paragraph1.copyWith(color: AppColors.title),
            ),
          ),
      ],
    );
  }

  Widget _buildShimmerDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List<Padding>.generate(
            2,
            (int index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _estimateTimeController.dispose();
    super.dispose();
  }
}
