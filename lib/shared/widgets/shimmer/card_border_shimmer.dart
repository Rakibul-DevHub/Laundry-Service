import 'package:flutter/material.dart';

import '../../../core/config/colors.dart';

class CardBorderShimmer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const CardBorderShimmer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.title.withValues(alpha: 0.1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}
