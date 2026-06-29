// features/services/provider/widgets/service_detail_category_section.dart

// ignore_for_file: inference_failure_on_function_return_type

import 'package:flutter/material.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../models/service_model.dart';
import 'service_detail_item_tile.dart';

class ServiceDetailCategorySection extends StatelessWidget {
  final ProductCategoryWithItems category;
  final bool isEditing;
  final Map<String, ServiceItem> editedItems;
  final Function(String, ServiceItem) onItemUpdate;

  const ServiceDetailCategorySection({
    super.key,
    required this.category,
    required this.isEditing,
    required this.editedItems,
    required this.onItemUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: <Widget>[
            Text(
              category.productCategory.name,
              style: AppTextStyles.paragraph1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.paste200.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${category.items.length}',
                style: AppTextStyles.paragraph0.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: category.items.map((ServiceItem item) {
                final ServiceItem editedItem = editedItems[item.id] ?? item;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ServiceDetailItemTile(
                    key: ValueKey<String>(item.id),
                    item: editedItem,
                    originalItem: item,
                    isEditing: isEditing,
                    onUpdate: (ServiceItem updated) =>
                        onItemUpdate(item.id, updated),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
