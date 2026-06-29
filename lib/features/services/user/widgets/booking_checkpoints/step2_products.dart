// ignore_for_file: inference_failure_on_function_return_type

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/services/user/models/service_products_model.dart';
import 'package:drop_n_fresh/features/services/user/models/user_service_booking_models.dart';
import 'package:drop_n_fresh/features/services/user/notifier/service_products_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step2Products extends ConsumerStatefulWidget {
  final String serviceId;
  final String providerId;
  final Function(List<BookingProductItem> selectedItems) onSubmit;
  final VoidCallback onPrevious;

  const Step2Products({
    super.key,
    required this.serviceId,
    required this.providerId,
    required this.onSubmit,
    required this.onPrevious,
  });

  @override
  ConsumerState<Step2Products> createState() => _Step2ProductsState();
}

class _Step2ProductsState extends ConsumerState<Step2Products> {
  final Map<String, int> _selectedQuantities = <String, int>{};

  final Map<String, bool> _expandedCategories = <String, bool>{};

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ServiceProductData>> productsAsync = ref.watch(
      serviceProductsProvider(
        ServiceProductsArgs(
          serviceId: widget.serviceId,
          providerId: widget.providerId,
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Add Products',
            style: AppTextStyles.heading4,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Select items and quantities for your service',
            style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
          ),
          const SizedBox(height: AppSizes.md),

          productsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (Object error, StackTrace stack) => _buildErrorContent(
              error: error.toString(),
              onRetry: () => ref
                  .read(
                    serviceProductsProvider(
                      ServiceProductsArgs(
                        serviceId: widget.serviceId,
                        providerId: widget.providerId,
                      ),
                    ).notifier,
                  )
                  .refresh(
                    ServiceProductsArgs(
                      serviceId: widget.serviceId,
                      providerId: widget.providerId,
                    ),
                  ),
            ),
            data: (List<ServiceProductData> services) {
              if (services.isEmpty) {
                return _buildEmptyContent();
              }

              final List<SelectableProductItem> allItems = services
                  .expand((ServiceProductData service) => service.allItems)
                  .toList();

              if (allItems.isEmpty) {
                return _buildEmptyContent();
              }

              final Map<String, List<SelectableProductItem>> groupedItems =
                  _groupByCategory(allItems);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...groupedItems.entries.map((
                    MapEntry<String, List<SelectableProductItem>> entry,
                  ) {
                    final String categoryName = entry.key;
                    final List<SelectableProductItem> categoryItems =
                        entry.value;

                    if (!_expandedCategories.containsKey(categoryName)) {
                      _expandedCategories[categoryName] =
                          false; // Default: collapsed
                    }

                    return _CategorySection(
                      categoryName: categoryName,
                      items: categoryItems,
                      isExpanded: _expandedCategories[categoryName]!,
                      selectedQuantities: _selectedQuantities,
                      onToggleExpand: () {
                        setState(() {
                          _expandedCategories[categoryName] =
                              !(_expandedCategories[categoryName] ?? true);
                        });
                      },
                      onQuantityChanged: (String itemId, int qty) {
                        setState(() {
                          if (qty <= 0) {
                            _selectedQuantities.remove(itemId);
                          } else {
                            _selectedQuantities[itemId] = qty;
                          }
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 24),

                  // Validation Message
                  if (_selectedQuantities.values.every((int qty) => qty <= 0))
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Please select at least one item with quantity > 0',
                              style: AppTextStyles.paragraph3.copyWith(
                                color: AppColors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Navigation Buttons
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onPrevious,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _selectedQuantities.values.any(
                                (int qty) => qty > 0,
                              )
                              ? _submitSelection
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Map<String, List<SelectableProductItem>> _groupByCategory(
    List<SelectableProductItem> items,
  ) {
    final Map<String, List<SelectableProductItem>> grouped =
        <String, List<SelectableProductItem>>{};
    for (final SelectableProductItem item in items) {
      if (!grouped.containsKey(item.categoryName)) {
        grouped[item.categoryName] = <SelectableProductItem>[];
      }
      grouped[item.categoryName]!.add(item);
    }
    return grouped;
  }

  void _submitSelection() {
    final List<BookingProductItem> selectedItems = <BookingProductItem>[];

    final AsyncValue<List<ServiceProductData>> productsAsync = ref.read(
      serviceProductsProvider(
        ServiceProductsArgs(
          serviceId: widget.serviceId,
          providerId: widget.providerId,
        ),
      ),
    );

    if (productsAsync is AsyncData && productsAsync.value != null) {
      final List<SelectableProductItem> allItems = productsAsync.value!
          .expand((ServiceProductData service) => service.allItems)
          .toList();

      for (final SelectableProductItem item in allItems) {
        final int qty = _selectedQuantities[item.itemId] ?? 0;
        if (qty > 0) {
          selectedItems.add(
            BookingProductItem.fromApiItem(item).copyWith(quantity: qty),
          );
        }
      }
    }

    widget.onSubmit(selectedItems);
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
            'Failed to load products',
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
          const Icon(Icons.inventory_2, size: 64, color: AppColors.body),
          const SizedBox(height: 16),
          Text(
            'No products available',
            style: AppTextStyles.subTitle1.copyWith(color: AppColors.title),
          ),
          const SizedBox(height: 8),
          Text(
            'This service doesn\'t have any selectable items',
            style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Add this widget class at the bottom of the file:

class _CategorySection extends StatefulWidget {
  final String categoryName;
  final List<SelectableProductItem> items;
  final bool isExpanded;
  final Map<String, int> selectedQuantities;
  final VoidCallback onToggleExpand;
  final Function(String itemId, int quantity) onQuantityChanged;

  const _CategorySection({
    required this.categoryName,
    required this.items,
    required this.isExpanded,
    required this.selectedQuantities,
    required this.onToggleExpand,
    required this.onQuantityChanged,
  });

  @override
  State<_CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_CategorySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.body.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: widget.onToggleExpand,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: <Widget>[
                  // Category Name + Item Count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.categoryName,
                          style: AppTextStyles.paragraph0.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.title,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.items.length} item${widget.items.length > 1 ? 's' : ''}',
                          style: AppTextStyles.paragraph1.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Animated Chevron Icon
                  RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.body,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: widget.items.map((SelectableProductItem item) {
                final int currentQty =
                    widget.selectedQuantities[item.itemId] ?? 0;
                return _ProductItemRow(
                  item: item,
                  quantity: currentQty,
                  onQuantityChanged: widget.onQuantityChanged,
                );
              }).toList(),
            ),
            crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }
}

class _ProductItemRow extends StatelessWidget {
  final SelectableProductItem item;
  final int quantity;
  final Function(String itemId, int quantity) onQuantityChanged;

  const _ProductItemRow({
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.body.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
      ),
      child: Row(
        children: <Widget>[
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: AppTextStyles.paragraph0.copyWith(
                    color: AppColors.title,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${(item.price / 100).toStringAsFixed(2)}',
                  style: AppTextStyles.paragraph2.copyWith(
                    color: AppColors.title,
                  ),
                ),
                if (quantity > 0) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    'Total: \$${((item.price / 100) * quantity).toStringAsFixed(2)}',
                    style: AppTextStyles.paragraph1.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Quantity Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: quantity > 0
                    ? () => onQuantityChanged(item.itemId, quantity - 1)
                    : null,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: quantity > 0
                          ? AppColors.primary
                          : AppColors.body.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 18,
                    color: quantity > 0
                        ? AppColors.primary
                        : AppColors.body.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 40,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: InputBorder.none,
                    ),
                    style: AppTextStyles.paragraph1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    controller: TextEditingController(
                      text: quantity.toString(),
                    ),
                    onChanged: (String value) {
                      final int qty = int.tryParse(value) ?? 0;
                      if (qty >= 0) {
                        onQuantityChanged(item.itemId, qty);
                      }
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onQuantityChanged(item.itemId, quantity + 1),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
