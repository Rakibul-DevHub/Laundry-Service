import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/general/contact_us_notifier.dart';
import '../notifier/general/privacy_policy_notifier.dart';
import '../notifier/general/support_notifier.dart';
import '../notifier/general/terms_and_conditions_notifier.dart';
import '../state/general/contact_us_state.dart';
import '../state/general/privacy_policy_state.dart';
import '../state/general/support_state.dart';
import '../state/general/terms_and_conditions_state.dart';
import '../notifier/general/about_us_notifier.dart';
import '../state/general/about_us_state.dart';

// about us provider
final AutoDisposeNotifierProvider<AboutUsNotifier, AboutUsState>
aboutUsProvider = AutoDisposeNotifierProvider<AboutUsNotifier, AboutUsState>(
  AboutUsNotifier.new,
);

// contact us provider
final AutoDisposeNotifierProvider<ContactUsNotifier, ContactUsState>
contactUsProvider =
    AutoDisposeNotifierProvider<ContactUsNotifier, ContactUsState>(
      ContactUsNotifier.new,
    );

// support provider
final AutoDisposeNotifierProvider<SupportNotifier, SupportState>
supportProvider = AutoDisposeNotifierProvider<SupportNotifier, SupportState>(
  SupportNotifier.new,
);

// privacy policy provider
final AutoDisposeNotifierProvider<PrivacyPolicyNotifier, PrivacyPolicyState>
privacyPolicyProvider =
    AutoDisposeNotifierProvider<PrivacyPolicyNotifier, PrivacyPolicyState>(
      PrivacyPolicyNotifier.new,
    );

// terms and conditions provider
final AutoDisposeNotifierProvider<
  TermsAndConditionsNotifier,
  TermsAndConditionsState
>
termsAndConditionsProvider =
    AutoDisposeNotifierProvider<
      TermsAndConditionsNotifier,
      TermsAndConditionsState
    >(
      TermsAndConditionsNotifier.new,
    );
