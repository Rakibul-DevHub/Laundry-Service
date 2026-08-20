import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../models/notification_model.dart';
import '../notifier/notification_notifier.dart';
import '../state/notification_state.dart';

final AutoDisposeNotifierProvider<NotificationNotifier, NotificationState>
notificationProvider =
    AutoDisposeNotifierProvider<NotificationNotifier, NotificationState>(
      NotificationNotifier.new,
    );

class NotificationBadgeNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() {
    Future<dynamic>.microtask(refresh);
    return 0;
  }

  Future<void> refresh() async {
    try {
      final ApiClient apiClient = ref.read(apiClientProvider);
      final NotificationsResponse response = await apiClient
          .handleRequest<NotificationsResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.notifications,
            fromJson: NotificationsResponse.fromJson,
            queryParameters: const <String, dynamic>{
              'page': '1',
              'limit': '1',
            },
          );
      final int unread = response.data.unreadCount;
      final int total = response.data.pagination.total;
      state = total == 0 ? 0 : unread;
    } catch (_) {
      state = 0;
    }
  }
}

final AutoDisposeNotifierProvider<NotificationBadgeNotifier, int>
notificationBadgeProvider =
    AutoDisposeNotifierProvider<NotificationBadgeNotifier, int>(
      NotificationBadgeNotifier.new,
    );
