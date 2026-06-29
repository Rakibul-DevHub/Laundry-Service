import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/features/home/rider/notifier/rider_online_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../providers/home_rider_providers.dart';

class RiderOnlineStatus extends ConsumerWidget {
  const RiderOnlineStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isOnline = ref.watch(onlineStatusProvider);
    final OnlineStatusNotifier notifier = ref.read(
      onlineStatusProvider.notifier,
    );

    return UnconstrainedBox(
      child: GestureDetector(
        onTap: () => notifier.toggle(),
        onPanStart: (_) => notifier.toggle(),
        onPanUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 10) {
            // Swipe right → Online
            if (!isOnline) {
              notifier.setOnline(true);
            }
          } else if (details.delta.dx < -10) {
            // Swipe left → Offline
            if (isOnline) {
              notifier.setOnline(false);
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isOnline ? AppColors.green50 : AppColors.red50,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isOnline ? AppColors.green : AppColors.red,
              width: .8,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isOnline)
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.green300,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.power_settings_new,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: AppTextStyles.heading5.copyWith(
                  color: isOnline ? AppColors.green : AppColors.red,
                ),
              ),
              const SizedBox(width: 12),
              if (!isOnline)
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.red300,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.power_settings_new,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
