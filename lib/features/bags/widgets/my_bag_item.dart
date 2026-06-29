// widgets/my_bag_item.dart

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/icons.dart';
import 'package:drop_n_fresh/core/extensions/context_extensions.dart';
import 'package:drop_n_fresh/core/extensions/strings_extensions.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../models/bag_model.dart';

class MyBagItem extends ConsumerWidget {
  final BagModel bag;

  const MyBagItem({
    super.key,
    required this.bag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        _showQrCodeDialog(context, bag);
      },
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
      splashColor: AppColors.paste50,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
          border: Border.all(
            color: bag.needsReplacement ? AppColors.red : AppColors.body,
            width: bag.needsReplacement ? 2.0 : 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildBagIcon(bag),
              const SizedBox(width: AppSizes.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          bag.displayCode,
                          style: AppTextStyles.paragraph0,
                        ),
                        if (bag.needsReplacement) ...<Widget>[
                          const SizedBox(width: AppSizes.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Replace',
                              style: AppTextStyles.paragraph2.copyWith(
                                color: AppColors.red,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: AppSizes.xs),

                    Row(
                      children: <Widget>[
                        Text(
                          bag.status.displayName.toCapitalize,
                          style: AppTextStyles.paragraph1.copyWith(),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        // 🔄 Trip Count
                        Text(
                          '• ${bag.tripCount} ${bag.tripCount > 1 ? 'trips' : 'trip'}',
                          style: AppTextStyles.paragraph0.copyWith(
                            color: AppColors.body.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MaterialIconButton(
                icon: Icons.qr_code_2_outlined,
                tooltip: 'Show QR Code',
                onPressed: () => _showQrCodeDialog(context, bag),
                size: 32,
                iconSize: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBagIcon(BagModel bag) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const AssetLoader(
            assetPath: AppIcons.bag,
            width: 20,
            height: 20,
            color: AppColors.white,
          ),
          if (bag.needsReplacement)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Add this method inside MyBagItem class or in your screen:

  void _showQrCodeDialog(BuildContext context, BagModel bag) {
    CustomPopup.show<Column>(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          QrImageView(
            data: bag.qrCode,
            version: QrVersions.auto,
            size: context.screenWidth * 0.8,
          ),
        ],
      ),
    );
  }
}

class MaterialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double? size;
  final double? iconSize;
  final Color? color;

  const MaterialIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 40,
    this.iconSize = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: color ?? AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
