import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/user_services_notifier.dart';
import '../state/user_services_state.dart';

final AutoDisposeNotifierProvider<UserServicesNotifier, UserServicesState>
userServicesProvider =
    NotifierProvider.autoDispose<UserServicesNotifier, UserServicesState>(
      UserServicesNotifier.new,
    );
