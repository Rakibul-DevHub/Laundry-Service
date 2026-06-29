import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/profile_notifier.dart';
import '../notifier/provider_profile_notifier.dart';
import '../notifier/rider_profile_notifier.dart';
import '../notifier/user_profile_notifier.dart';
import '../state/profile_state.dart';
import '../state/provider_profile_state.dart';
import '../state/rider_profile_state.dart';
import '../state/user_profile_state.dart';

final AutoDisposeNotifierProvider<ProfileNotifier, ProfileState>
profileProvider = AutoDisposeNotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);

// rider profile providers
final AutoDisposeNotifierProvider<RiderProfileNotifier, RiderProfileState>
riderProfileProvider =
    NotifierProvider.autoDispose<RiderProfileNotifier, RiderProfileState>(
      () => RiderProfileNotifier(),
    );

// user profile providers
final AutoDisposeNotifierProvider<UserProfileNotifier, UserProfileState>
userProfileProvider =
    NotifierProvider.autoDispose<UserProfileNotifier, UserProfileState>(
      () => UserProfileNotifier(),
    );
// provider profile providers
final AutoDisposeNotifierProvider<ProviderProfileNotifier, ProviderProfileState>
providerProfileProvider =
    NotifierProvider.autoDispose<ProviderProfileNotifier, ProviderProfileState>(
      () => ProviderProfileNotifier(),
    );
