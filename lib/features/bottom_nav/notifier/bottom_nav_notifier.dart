import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/bottom_nav_state.dart';

class BottomNavNotifier extends Notifier<BottomNavState> {
  @override
  BottomNavState build() {
    Future<dynamic>.microtask(
      () {
        // Save token when available
        FirebaseMessaging.instance.getToken().then((String? token) {
          saveToken(token);
        });

        // Handle token refresh
        FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
          saveToken(newToken);
        });
      },
    );
    return const BottomNavState();
  }

  Future<void> saveToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      ref
          .read(apiClientProvider)
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.fcmToken,
            data: <String, String?>{"fcmToken": token},
          );
    }
  }

  void setIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
