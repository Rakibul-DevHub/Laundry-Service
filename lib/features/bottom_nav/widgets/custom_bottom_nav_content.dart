import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_logger.dart';
import '../../../shared/enums/role.dart';
import '../config/bottom_nav_config.dart';
import '../provider/bottom_nav_provider.dart';
import '../state/bottom_nav_state.dart';

class BottomNavContent extends ConsumerWidget {
  final Role role;

  const BottomNavContent({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("BOTTOM NAV CONTENT BUILD");
    final int currentIndex = ref.watch(
      bottomNavProvider.select((BottomNavState state) => state.currentIndex),
    );

    final List<Widget> screens = getScreensForRole(role);

    return IndexedStack(
      index: currentIndex,
      children: screens,
    );
  }
}
