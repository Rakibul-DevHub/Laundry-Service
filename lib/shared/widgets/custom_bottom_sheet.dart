import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/colors.dart';

/// A truly dynamic bottom sheet that sizes to content
class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.maxHeightFraction = 0.8,
    this.padding = const EdgeInsets.all(16),
    this.titlePadding = const EdgeInsets.fromLTRB(16, 8, 16, 16),
    this.backgroundColor = Colors.white,
  });

  final Widget child;
  final String? title;
  final double maxHeightFraction;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry titlePadding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: const Border(
          top: BorderSide(width: 5.0, color: AppColors.primary),
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate max allowed height based on screen
          final double maxHeight =
              MediaQuery.of(context).size.height * maxHeightFraction;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Title
                    if (title != null)
                      Padding(
                        padding: titlePadding,
                        child: Text(
                          title!,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),

                    // Content (no Expanded - lets content size naturally)
                    Padding(
                      padding: padding,
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Show bottom sheet with dynamic height
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double maxHeightFraction = 0.8,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? titlePadding,
    bool showDragHandle = true,
    bool isDismissible = true,
    bool useRootNavigator = false,
    Color backgroundColor = Colors.white,
  }) {
    HapticFeedback.lightImpact();

    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Critical for keyboard handling
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      enableDrag: true,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: CustomBottomSheet(
            title: title,
            maxHeightFraction: maxHeightFraction,
            padding: padding ?? const EdgeInsets.all(16),
            titlePadding:
                titlePadding ?? const EdgeInsets.fromLTRB(16, 8, 16, 16),
            backgroundColor: backgroundColor,
            child: child,
          ),
        );
      },
    );
  }
}
