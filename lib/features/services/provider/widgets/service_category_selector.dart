import 'package:drop_n_fresh/features/services/provider/notifier/create_service_notifier.dart';
import 'package:drop_n_fresh/features/services/provider/state/create_service_form_state.dart';
import 'package:drop_n_fresh/features/services/shared/models/service_category_model.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../shared/providers/service_category_provider.dart';
import '../providers/service_providers.dart';

class ServiceCategorySelector extends ConsumerWidget {
  const ServiceCategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CreateServiceFormState formState = ref.watch(createServiceProvider);
    final AsyncValue<List<ServiceCategory>> categoriesAsync = ref.watch(
      serviceCategoryProvider,
    );
    final CreateServiceNotifier notifier = ref.read(
      createServiceProvider.notifier,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Service Category *',
          style: AppTextStyles.heading4.copyWith(color: AppColors.title),
        ),
        const SizedBox(height: 8),
        categoriesAsync.when(
          loading: () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List<Container>.generate(6, (int index) {
              return Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minHeight: 120),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white, // Solid background for skeleton
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: <Widget>[
                    // Icon Placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text Placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 60, // Approximate width of text
                        height: 12, // Approximate height of paragraph1
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          error: (Object e, _) =>
              Text('Error: $e', style: const TextStyle(color: Colors.red)),
          data: (List<ServiceCategory> categories) {
            final String selectedId = formState.serviceCategoryId;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((ServiceCategory category) {
                final bool isSelected = category.id == selectedId;
                return GestureDetector(
                  onTap: () => notifier.setServiceCategory(category.id),
                  child: Container(
                    width: 100,
                    constraints: const BoxConstraints(minHeight: 120),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? AppColors.paste100 : AppColors.body,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? AppColors.paste100.withValues(alpha: 0.2)
                          : Colors.transparent,
                    ),
                    child: Column(
                      children: <Widget>[
                        if (category.icon.isNotEmpty)
                          AssetLoader(
                            assetPath: category.icon,
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                            shape: BoxShape.rectangle,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          category.name,
                          maxLines: 3,
                          style: AppTextStyles.paragraph1.copyWith(
                            color: isSelected
                                ? AppColors.paste500
                                : AppColors.title,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        if (formState.errors['serviceCategoryId'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              formState.errors['serviceCategoryId']!,
              style: AppTextStyles.paragraph3.copyWith(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
