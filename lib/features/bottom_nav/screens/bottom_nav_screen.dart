import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_logger.dart';
import '../../../shared/enums/role.dart';
import '../../auth/providers/auth_providers.dart';
import '../config/bottom_nav_config.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_bottom_nav_content.dart';

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("BOTTOM NAV SCREEN BUILD");

    final AuthState authState = ref.watch(authProvider);
    final Role? role = authState.role;

    if (role == null) {
      return const Scaffold(body: Center(child: Text('Please log in')));
    }

    return Scaffold(
      body: BottomNavContent(role: role), // 👈 Separate widget
      bottomNavigationBar: CustomBottomNavBar(
        items: getBottomNavItems(role),
      ),
    );
  }
}