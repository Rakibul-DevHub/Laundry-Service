import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/colors.dart';
import '../providers/notifications_provider.dart';

class NotificationItem extends ConsumerWidget {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final bool isRead;

  const NotificationItem({
    super.key,
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(notificationProvider.notifier).markAsRead(id),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.title.withValues(alpha: 0.1),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: AppTextStyles.paragraph0.copyWith(
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              color: isRead ? AppColors.grey600 : AppColors.title,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                message,
                style: AppTextStyles.paragraph1,
              ),
              const SizedBox(height: 4),
              Text(
                timeAgo,
                style: AppTextStyles.paragraph1,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.body,
                ),
                onPressed: () async {
                  final bool? confirmed = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Delete'),
                      content: const Text('Delete this notification?'),
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

                  if (confirmed == true) {
                    await ref
                        .read(notificationProvider.notifier)
                        .deleteNotification(id);
                  }
                },
                tooltip: 'Delete notification',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
