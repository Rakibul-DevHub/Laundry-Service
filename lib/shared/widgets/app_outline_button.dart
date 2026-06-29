import 'package:flutter/material.dart';

import '../../app/theme/styles/app_text_styles.dart';
import '../../core/config/colors.dart';

class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final double? height;
  final double? width;
  final Color? outlineColor;
  final Color? backgroundColor;
  final Color? textColor;

  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.outlineColor,
    this.backgroundColor,
    this.textColor,
    this.height = 48.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(width ?? double.infinity, height!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          width: .5,
          color: isEnabled
              ? outlineColor ?? AppColors.primary
              : AppColors.grey50,
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[icon!, const SizedBox(width: 8)],
                Text(
                  label,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subTitle1.copyWith(
                    color: textColor ?? outlineColor,
                  ),
                ),
              ],
            ),
    );
  }
}
