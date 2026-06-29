import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/general/about_us_state.dart';

class AboutUsNotifier extends AutoDisposeNotifier<AboutUsState> {
  @override
  AboutUsState build() {
    Future<dynamic>.microtask(() {
      _retrieveAboutUs();
    });
    return const AboutUsState();
  }

  Future<void> _retrieveAboutUs() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // final apiClient = ref.read(apiClientProvider);
      // final response = await apiClient.handleRequest<String>(
      //   httpMethod: HttpMethod.get,
      //   endpoint: // ApiEndpoints.aboutUs,
      // );

      state = state.copyWith(
        htmlContent: '''
              <h1>About Us</h1>
              <p>We are a dedicated team passionate about delivering exceptional services to our community. Our mission is to provide reliable, efficient, and user-friendly solutions that make everyday life easier.</p>

              <h2>Our Values</h2>
              <ul>
                <li><strong>Integrity:</strong> We operate with honesty and transparency</li>
                <li><strong>Innovation:</strong> We continuously improve our services</li>
                <li><strong>Customer Focus:</strong> Your satisfaction is our priority</li>
              </ul>

              <h2>Our Journey</h2>
              <p>Founded in 2023, we've grown from a small startup to serving thousands of customers across the region. We're committed to sustainable growth and community development.</p>
              ''',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load about us content',
        isLoading: false,
      );
    }
  }

  Future<void> refreshContent() async {
    _retrieveAboutUs();
  }
}
