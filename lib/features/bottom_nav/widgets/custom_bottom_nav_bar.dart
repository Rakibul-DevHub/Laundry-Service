// lib/core/shared/widgets/custom_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/utils/app_logger.dart';
import '../config/bottom_nav_config.dart';
import '../provider/bottom_nav_provider.dart';
import '../state/bottom_nav_state.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final List<CustomBottomNavItem> items;

  const CustomBottomNavBar({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("BOTTOM NAV BAR BUILD");

    final int currentIndex = ref.watch(
      bottomNavProvider.select((BottomNavState state) => state.currentIndex),
    );

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.grey100, width: .5),
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate max width per tab
          final double itemWidth = constraints.maxWidth / items.length;

          return Row(
            children: items.asMap().entries.map((
              MapEntry<int, CustomBottomNavItem> entry,
            ) {
              final int index = entry.key;
              final CustomBottomNavItem item = entry.value;
              final bool isActive = index == currentIndex;

              return SizedBox(
                width: itemWidth,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(bottomNavProvider.notifier).setIndex(index),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (isActive)
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 650),
                            curve: Curves.easeOut,
                            builder: (BuildContext context, double t, _) {
                              return Transform.translate(
                                offset: Offset(
                                  12 * (1 - t),
                                  0,
                                ),
                                child: Opacity(
                                  opacity: t * t,
                                  child: item.activeIcon,
                                ),
                              );
                            },
                          )
                        else
                          item.icon,

                        if (isActive)
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 650),
                            curve: Curves.easeOut,
                            builder: (BuildContext context, double t, _) {
                              return Transform.translate(
                                offset: Offset(
                                  12 * (1 - t),
                                  0,
                                ),
                                child: Opacity(
                                  opacity: t * t,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: SizedBox(
                                      width:
                                          itemWidth -
                                          32, // Account for icon width + padding
                                      child: Text(
                                        item.label,
                                        key: ValueKey<String>('$index-label'),
                                        style: AppTextStyles.paragraph1
                                            .copyWith(
                                              color: AppColors.primary,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
