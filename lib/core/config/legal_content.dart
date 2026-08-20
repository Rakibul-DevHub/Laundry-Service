class LegalContent {
  LegalContent._();

  static const String support = '''
<h1>Support</h1>
<p>Need help with Drop n Fresh? Our team is here for guests, agents, and couriers.</p>
<h2>Contact us</h2>
<p><strong>Email:</strong> support@dropnfreshapp.com</p>
<p><strong>Hours:</strong> Monday–Friday, 9:00 AM – 6:00 PM (local time)</p>
<h2>Common topics</h2>
<ul>
  <li><strong>Bag orders:</strong> Save a delivery address before ordering a bag. Add or update it from Home or Profile → Address.</li>
  <li><strong>Pickups and deliveries:</strong> Keep your bag ready and follow the in-app instructions for your order.</li>
  <li><strong>Account:</strong> Update your name, phone, photo, and address from Profile.</li>
  <li><strong>Payments:</strong> Checkout is completed through our secure payment partner.</li>
</ul>
<h2>Response time</h2>
<p>We typically respond within one business day. For order-specific issues, include your order number in the email.</p>
''';

  static const String termsAndConditions = '''
<h1>Terms &amp; Conditions</h1>
<p>Last updated: August 20, 2026</p>
<p>These Terms &amp; Conditions govern your use of the Drop n Fresh mobile app and laundry services. By creating an account or placing an order, you agree to these terms.</p>
<h2>1. Who we are</h2>
<p>Drop n Fresh provides pickup, laundry (including wash &amp; fold and dry cleaning), and delivery through independent agents and couriers.</p>
<h2>2. Accounts</h2>
<p>You must provide accurate information, including a valid delivery address. You are responsible for keeping your login details secure and for activity on your account.</p>
<h2>3. Orders and bags</h2>
<p>Service availability depends on your location and participating agents. Reusable bags may be ordered through the app and should be kept at your address for pickup. Prices, fees, and timelines shown at checkout apply to that order.</p>
<h2>4. Pickup and delivery</h2>
<p>Please have items ready according to the instructions in the app. If we cannot complete a pickup or delivery because of an incorrect address, inaccessible location, or missing bag, the order may be delayed or cancelled.</p>
<h2>5. Payments</h2>
<p>Payments are processed by our payment provider. By confirming an order you authorize the listed charges, including bag fees and service totals.</p>
<h2>6. Cancellations</h2>
<p>You may cancel an order only while the app still allows cancellation for that status. Completed or in-progress services may not be refundable except as required by law.</p>
<h2>7. Acceptable use</h2>
<p>Do not misuse the app, harass others, or send prohibited or hazardous items. We may suspend accounts that violate these terms.</p>
<h2>8. Changes</h2>
<p>We may update these terms from time to time. Continued use of Drop n Fresh after an update means you accept the revised terms.</p>
<h2>9. Contact</h2>
<p>Questions about these terms: support@dropnfreshapp.com</p>
''';

  static const String privacyPolicy = '''
<h1>Privacy Policy</h1>
<p>Last updated: August 20, 2026</p>
<p>Drop n Fresh respects your privacy. This policy explains what information we collect and how we use it when you use the Guest app.</p>
<h2>1. Information we collect</h2>
<ul>
  <li><strong>Account details:</strong> name, email, phone number, password, and profile photo if you upload one.</li>
  <li><strong>Address:</strong> saved delivery locations used for bag orders and laundry pickup/delivery.</li>
  <li><strong>Orders:</strong> services, bags, schedules, and payment status.</li>
  <li><strong>Messages:</strong> chats you start with an Agent after selecting them for an order.</li>
  <li><strong>Device data:</strong> app notifications token and basic device information needed to operate the service.</li>
</ul>
<h2>2. How we use it</h2>
<p>We use this information to create your account, deliver bags and laundry, process payments, send order updates, provide support, and improve the app.</p>
<h2>3. Sharing</h2>
<p>We share only what is needed with Agents and Couriers fulfilling your order, and with payment, mapping, and hosting providers who process data on our behalf. We do not sell your personal information.</p>
<h2>4. Retention</h2>
<p>We keep account and order records for as long as your account is active and as required for legal, tax, or dispute purposes. You may request account deletion from Profile → Delete Account.</p>
<h2>5. Your choices</h2>
<p>You can update your profile, photo, and addresses in the app. You can also turn off push notifications in your device settings.</p>
<h2>6. Contact</h2>
<p>Privacy questions: support@dropnfreshapp.com</p>
''';

  static bool looksLikePlaceholder(String? content) {
    if (content == null || content.trim().isEmpty) {
      return true;
    }
    final String lower = content.toLowerCase();
    return lower.contains('yourapp') ||
        lower.contains('lorem ipsum') ||
        lower.contains('test data') ||
        lower.contains('placeholder') ||
        lower.contains('dummy') ||
        lower.contains('example.com');
  }
}
