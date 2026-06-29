import 'dart:async';
import 'dart:convert';

import 'package:drop_n_fresh/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_logger.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  AppLogger().i('Background tap payload: ${response.payload}');

  if (response.payload != null) {
    try {
      final Map<String, dynamic> data =
          jsonDecode(response.payload!) as Map<String, dynamic>;
      AppLogger().i('Background tap parsed: $data');
      _globalNotificationTapController?.add(data);
    } catch (e, stack) {
      AppLogger().e(
        'Failed to parse background tap: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

StreamController<Map<String, dynamic>>? _globalNotificationTapController;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<Map<String, dynamic>> _notificationTapController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationTapStream =>
      _notificationTapController.stream;

  Future<void> init() async {
    try {
      AppLogger().i('Initializing FCM...');

      _globalNotificationTapController = _notificationTapController;

      await _requestPermissions();
      await _initLocalNotifications();

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      AppLogger().i('FCM initialized');
    } catch (e, stack) {
      AppLogger().e('FCM init failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Map<String, dynamic> _extractData(RemoteMessage message) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(message.data);
    return <String, dynamic>{
      'type': data['type'] ?? "Unknown Type",
      'id': "Unknown ID",
    };
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    AppLogger().i('Foreground: ${message.notification?.title}');

    await _showLocalNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    try {
      AppLogger().i('Tapped: ${message.data}');
      final Map<String, dynamic> data = _extractData(message);
      _notificationTapController.add(data);
    } catch (e, stack) {
      AppLogger().e('Tap failed', error: e, stackTrace: stack);
    }
  }

  Future<void> showBackgroundNotification(RemoteMessage message) async {
    try {
      if (message.notification != null) {
        AppLogger().i('System notification already shown, skipping local');
        return;
      }

      await _showLocalNotification(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: jsonEncode(message.data),
      );
    } catch (e, stack) {
      AppLogger().e(
        'Failed to show background notification',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> _requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: false,
    );
  }

  Future<void> _initLocalNotifications() async {
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),

      onDidReceiveNotificationResponse: (NotificationResponse details) {
        try {
          AppLogger().i('Foreground tap: ${details.payload}');

          if (details.payload != null) {
            final Map<String, dynamic> data =
                jsonDecode(details.payload!) as Map<String, dynamic>;
            _notificationTapController.add(data);
          }
        } catch (e, stack) {
          AppLogger().e('Foreground tap failed', error: e, stackTrace: stack);
        }
      },

      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'drop_n_fresh_channel',
            'Drop N Fresh Notifications',
            importance: Importance.high,
            playSound: true,
          ),
        );
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'drop_n_fresh_channel',
          'Drop N Fresh Notifications',
          channelDescription: 'Important notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void dispose() {
    _globalNotificationTapController = null;
    _notificationTapController.close();
  }
}

final Provider<NotificationService> notificationServiceProvider =
    Provider<NotificationService>((Ref<NotificationService> ref) {
      final NotificationService service = NotificationService();
      ref.onDispose(service.dispose);
      return service;
    });
