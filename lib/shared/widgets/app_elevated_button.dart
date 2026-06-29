import 'package:flutter/material.dart';

import '../../app/theme/styles/app_text_styles.dart';
import '../../core/config/colors.dart';

class AppElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const AppElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.height = 48.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        minimumSize: Size(width ?? double.infinity, height!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[icon!, const SizedBox(width: 8)],
                Text(
                  label,
                  style: AppTextStyles.heading5.copyWith(
                    color: textColor ?? AppColors.white,
                  ),
                ),
              ],
            ),
    );
  }
}
