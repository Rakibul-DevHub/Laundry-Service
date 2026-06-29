import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/features/notification/notifier/notification_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_refresh_indicator.dart';
import '../providers/notifications_provider.dart';
import '../state/notification_state.dart';
import '../widgets/notification_list.dart';
import '../widgets/notification_list_shimmer.dart';

class NotificationsScreen extends ConsumerWidget {
  final bool isSeparatedScreen;
  const NotificationsScreen({super.key, this.isSeparatedScreen = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("NOTIFICATION SCREEN BUILD");
    final NotificationState state = ref.watch(
      notificationProvider,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        showBackBtn: isSeparatedScreen,
        titleAlignment: TitleAlignment.left,
        actions: <Widget>[
          if (state.isMarkingAllAsRead || state.isDeleting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (state.notifications.isEmpty)
            const SizedBox()
          else
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String result) async {
                final NotificationNotifier notifier = ref.read(
                  notificationProvider.notifier,
                );

                if (result == 'mark_all') {
                  await notifier.markAllAsRead();
                } else if (result == 'delete_all') {
                  // Show confirmation dialog
                  final bool? confirmed = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Delete All'),
                      content: const Text(
                        'Are you sure you want to delete all notifications?',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => context.pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => context.pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && context.mounted) {
                    await notifier.deleteAllNotifications();
                  }
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'mark_all',
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 8),
                      const Text('Mark All as Read'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'delete_all',
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Delete All',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      backgroundColor: AppColors.white,
      body: CustomRefreshIndicator(
        onRefresh: () => ref.read(notificationProvider.notifier).refresh(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontal,
            vertical: AppSizes.screenVertical,
          ),
          child: state.isLoading
              ? const NotificationListShimmer()
              : state.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSizes.sm,
                    children: <Widget>[
                      Text(state.error ?? "Something went wrong!"),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(notificationProvider.notifier).refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : state.notifications.isEmpty
              ? Center(
                  child: Text(
                    'No notifications to display',
                    style: AppTextStyles.paragraph0,
                  ),
                )
              : NotificationList(state: state),
        ),
      ),
    );
  }
}
