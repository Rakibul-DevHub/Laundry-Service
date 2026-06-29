import 'package:flutter/material.dart';

import '../../core/config/sizes.dart';

class CustomPopup {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    Color barrierColor = Colors.black54,
    double borderRadius = 12,
    bool isDismissible = true, // ← controls BOTH tap-outside AND back button
    Color backgroundColor = Colors.white,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return PopScope(
          canPop: isDismissible,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(AppSizes.sm),
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.all(16),
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }
}
