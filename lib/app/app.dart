import 'package:drop_n_fresh/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/theme.dart';
import 'toast/toast.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // setupNotificationNavigation(ref, ref.read(appRouterProvider));
      ref.read(notificationServiceProvider).init();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Drop N Fresh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(ThemeMode.light),
      darkTheme: AppTheme.getTheme(ThemeMode.dark),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(appRouterProvider),
      builder: (BuildContext context, Widget? child) {
        return ToastProvider(child: child);
      },
    );
  }
}
