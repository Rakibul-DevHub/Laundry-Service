import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/general/contact_us_state.dart';

class ContactUsNotifier extends AutoDisposeNotifier<ContactUsState> {
  @override
  ContactUsState build() {
    Future<dynamic>.microtask(() {
      _retrieveContactUs();
    });
    return const ContactUsState();
  }

  Future<void> _retrieveContactUs() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // final apiClient = ref.read(apiClientProvider);
      // final response = await apiClient.handleRequest<String>(
      //   httpMethod: HttpMethod.get,
      //   endpoint: // ApiEndpoints.aboutUs,
      // );

      state = state.copyWith(
        htmlContent: '''
            <h1>Contact Us</h1>
            <p>We'd love to hear from you! Reach out to us through any of the following channels:</p>

            <h2>Customer Support</h2>
            <p><strong>Email:</strong> support@yourapp.com</p>
            <p><strong>Phone:</strong> +1 (555) 123-4567</p>
            <p><strong>Hours:</strong> Monday-Friday, 9 AM - 6 PM</p>

            <h2>Business Inquiries</h2>
            <p><strong>Email:</strong> business@yourapp.com</p>

            <h2>Office Address</h2>
            <p>123 Innovation Street<br>
            Tech City, TC 10001<br>
            United States</p>

            <h2>Response Time</h2>
            <p>We typically respond to all inquiries within 24 business hours.</p>
            ''',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load contact us content',
        isLoading: false,
      );
    }
  }

  Future<void> refreshContent() async {
    _retrieveContactUs();
  }
}
