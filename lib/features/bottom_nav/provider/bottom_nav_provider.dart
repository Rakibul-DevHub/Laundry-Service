import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/bottom_nav_notifier.dart';
import '../state/bottom_nav_state.dart';

final NotifierProvider<BottomNavNotifier, BottomNavState>
bottomNavProvider = NotifierProvider<BottomNavNotifier, BottomNavState>(
  BottomNavNotifier.new,
);
