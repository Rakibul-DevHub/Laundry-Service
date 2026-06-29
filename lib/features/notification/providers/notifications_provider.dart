import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/notification_notifier.dart';
import '../state/notification_state.dart';

final AutoDisposeNotifierProvider<NotificationNotifier, NotificationState>
notificationProvider =
    AutoDisposeNotifierProvider<NotificationNotifier, NotificationState>(
      NotificationNotifier.new,
    );
