import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/update_location_notifier.dart';

final AutoDisposeNotifierProvider<LocationNotifier, DateTime?>
locationProvider = NotifierProvider.autoDispose<LocationNotifier, DateTime?>(
  LocationNotifier.new,
);
