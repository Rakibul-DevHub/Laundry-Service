import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../shared/enums/role.dart';
import '../../../shared/provider/role_provider.dart';

class RoleContainer extends ConsumerWidget {
  final Role role;
  final String title;
  final String description;
  final String asset;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const RoleContainer({
    super.key,
    required this.title,
    required this.role,
    required this.description,
    required this.asset,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Role> selectedRole = ref.watch(selectedRoleProvider);

    // Check if this role is selected
    final bool isSelected = selectedRole.maybeWhen(
      data: (Role value) => value == role,
      orElse: () => false,
    );

    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.06)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      child: InkWell(
        onTap: () async {
          // Update selected role in Riverpod
          await ref.read(selectedRoleProvider.notifier).setRole(role);
          onTap?.call();
        },
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        splashColor: AppColors.primary.withValues(alpha: 0.15),
        highlightColor: AppColors.primary.withValues(alpha: 0.02),
        child: Container(
          padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.title,
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const SizedBox(width: AppSizes.md),
              AssetLoader(
                assetPath: asset,
                width: 116,
                height: 116,
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: AppSizes.md),
                    Text(title, style: AppTextStyles.heading4),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      description,
                      maxLines: 4,
                      style: AppTextStyles.paragraph1.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
