import 'package:drop_n_fresh/features/services/provider/models/product_category_form.dart';
import 'package:drop_n_fresh/features/services/provider/notifier/create_service_notifier.dart';
import 'package:drop_n_fresh/features/services/provider/state/create_service_form_state.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../providers/service_providers.dart';
import '../widgets/product_category_builder.dart';
import '../widgets/service_category_selector.dart';

class ProviderCreateServiceScreen extends ConsumerWidget {
  const ProviderCreateServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CreateServiceFormState formState = ref.watch(createServiceProvider);
    final CreateServiceNotifier notifier = ref.read(
      createServiceProvider.notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: 'Create Service',
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Service Category
            const ServiceCategorySelector(),
            const SizedBox(height: 24),

            // Description
            Text(
              'Description *',
              style: AppTextStyles.heading5.copyWith(color: AppColors.title),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: formState.description,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your service (min 10 characters)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: formState.errors['description'],
              ),
              onChanged: notifier.setDescription,
              onEditingComplete: notifier.validateDescription,
            ),
            const SizedBox(height: 24),

            // Estimate Time
            Text(
              'Estimate Time *',
              style: AppTextStyles.heading5.copyWith(color: AppColors.title),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: formState.estimateTime,
              decoration: InputDecoration(
                hintText: 'e.g., 24 hours, 2-3 days',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: formState.errors['estimateTime'],
              ),
              onChanged: notifier.setEstimateTime,
            ),
            const SizedBox(height: 24),

            // Product Categories Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Product Categories *',
                  style: AppTextStyles.heading5.copyWith(
                    color: AppColors.title,
                  ),
                ),
                TextButton.icon(
                  onPressed: notifier.addProductCategory,
                  icon: const Icon(Icons.add, size: 24),
                  label: const Text('Add Category'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.paste500,
                  ),
                ),
              ],
            ),
            if (formState.errors['productCategories'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  formState.errors['productCategories']!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 8),

            // Dynamic Product Categories
            ...formState.productCategories.map(
              (ProductCategoryForm pc) => ProductCategoryBuilder(formId: pc.id),
            ),

            const SizedBox(height: 32),

            AppElevatedButton(
              label: "Submit",
              isLoading: formState.isSubmitting,
              onPressed: formState.isSubmitting
                  ? null
                  : () async {
                      final bool success = await notifier.submitService();
                      if (success && context.mounted) {
                        context.pop();
                      }
                    },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
