import 'package:drop_n_fresh/features/services/provider/models/create_service_request.dart';
import 'package:drop_n_fresh/features/services/provider/models/product_category_form.dart';
import 'package:drop_n_fresh/features/services/provider/notifier/create_service_notifier.dart';
import 'package:drop_n_fresh/features/services/provider/state/create_service_form_state.dart';
import 'package:drop_n_fresh/features/services/shared/models/product_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../shared/providers/product_category_provider.dart';
import '../providers/service_providers.dart';
import 'item_editor.dart';

class ProductCategoryBuilder extends ConsumerWidget {
  final String formId;

  const ProductCategoryBuilder({super.key, required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CreateServiceFormState formState = ref.watch(createServiceProvider);
    final AsyncValue<List<ProductCategory>> categoriesAsync = ref.watch(
      productCategoryProvider,
    );
    final CreateServiceNotifier notifier = ref.read(
      createServiceProvider.notifier,
    );

    final ProductCategoryForm productCategory = formState.productCategories
        .firstWhere((ProductCategoryForm pc) => pc.id == formId);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Product Category *',
                  style: AppTextStyles.heading5.copyWith(
                    color: AppColors.title,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 24,
                  ),
                  onPressed: () => notifier.removeProductCategory(formId),
                  tooltip: 'Remove category',
                ),
              ],
            ),
            const SizedBox(height: 8),
            categoriesAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (Object e, _) =>
                  Text('Error: $e', style: const TextStyle(color: Colors.red)),
              data: (List<ProductCategory> categories) {
                return DropdownButtonFormField<String>(
                  dropdownColor: AppColors.white,
                  focusColor: AppColors.paste100,
                  initialValue: productCategory.productCategoryId.isEmpty
                      ? null
                      : productCategory.productCategoryId,
                  decoration: InputDecoration(
                    hintText: 'Select product category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: formState.errors['productCategory_$formId'],
                  ),
                  items: categories.map((ProductCategory category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      notifier.updateProductCategory(formId, value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Items *',
                  style: AppTextStyles.heading5.copyWith(
                    color: AppColors.title,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => notifier.addItem(formId),
                  icon: const Icon(Icons.add, size: 24),
                  label: const Text('Add Item'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            if (formState.errors['items_$formId'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  formState.errors['items_$formId']!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ...productCategory.items.asMap().entries.map((
              MapEntry<int, ServiceItem> entry,
            ) {
              final int index = entry.key;
              final ServiceItem item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ItemEditor(
                  item: item,
                  index: index,
                  formId: formId,
                  onUpdate: (ServiceItem updatedItem) =>
                      notifier.updateItem(formId, index, updatedItem),
                  onRemove: () => notifier.removeItem(formId, index),
                  nameError: formState.errors['item_name_${formId}_$index'],
                  priceError: formState.errors['item_price_${formId}_$index'],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
