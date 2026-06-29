/// Route paths for the app
class RoutePaths {
  RoutePaths._();

  // Onboarding routes
  static const String initial = '/initial';
  static const String role = '/role';
  static const String onboarding = '/onboarding';

  // Auth routes
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';
  static const String changePassword = '/settings/change-password';
  static const String deleteAccount = '/settings/delete-account';

  // ====================== Profile routes
  static const String profile = '/profile';
  static const String profileInfo = '/profile-info';
  static const String riderProfileInfo = '/rider-profile-info';
  static const String userProfileInfo = '/user-profile-info';
  static const String userAddressInfo = '/user-address-info';
  static const String userAddressAdd = '/user-address-add';
  static const String providerProfileInfo = '/provider-profile-info';
  static const String profileEdit = '/profile/edit';
  static const String riderProfileEdit = '/profile-rider-edit';
  static const String userProfileEdit = '/profile-user-edit';
  static const String providerProfileEdit = '/profile-provider-edit';
  static const String privacyPolicy = '/settings/privacy-policy';
  static const String termsCondition = '/settings/terms-condition';
  static const String contactUs = '/settings/contact-us';
  static const String support = '/settings/support';
  static const String aboutUs = '/settings/about-us';
  static const String settings = '/settings';

  // Verify Rider
  static const String verifyRiderHome = '$rider/profile/verify-rider-home';
  static const String verifyRiderHomeNoRole = 'profile/verify-rider-home';

  static const String verifyRiderNID = '$rider/profile/verify-rider-nid';
  static const String verifyRiderNIDNoRole = 'profile/verify-rider-nid';

  static const String verifyRiderDrivingLicense =
      '$rider/profile/verify-rider-driving-license';
  static const String verifyRiderDrivingLicenseNoRole =
      'profile/verify-rider-driving-license';

  static const String verifyRiderInsuranceInfo =
      '$rider/profile/verify-rider-insurance-info';
  static const String verifyRiderInsuranceInfoNoRole =
      'profile/verify-rider-insurance-info';

  static const String verifyRiderVehicle =
      '$rider/profile/verify-rider-vehicle-info';
  static const String verifyRiderVehicleNoRole =
      'profile/verify-rider-vehicle-info';

  static const String verifyRiderSelfie =
      '$rider/profile/verify-rider-selfie-info';
  static const String verifyRiderSelfieNoRole =
      'profile/verify-rider-selfie-info';

  // ============== earnings
  // rider earnings
  static const String riderAllEarnings = '$rider/rider-all-earnings';
  static const String riderAllEarningsNoRole = 'rider-all-earnings';

  static const String riderBalance = '$rider/rider-balance';
  static const String riderBalanceNoRole = 'rider-balance';

  static const String riderWithdraw = '$rider/rider-withdraw';
  static const String riderWithdrawNoRole = 'rider-withdraw';

  // provider earnings
  static const String providerAllEarnings = '$provider/provider-all-earnings';
  static const String providerAllEarningsNoRole = 'provider-all-earnings';

  static const String providerBalance = '$provider/provider-balance';
  static const String providerBalanceNoRole = 'provider-balance';

  static const String providerWithdraw = '$provider/provider-withdraw';
  static const String providerWithdrawNoRole = 'provider-withdraw';

  // ============ bags
  // user bags
  static const String userMyBags = '$user/user-my-bags';
  static const String userMyBagsNoRole = 'user-my-bags';

  static const String userOrderBag = '$user/user-order-bags';
  static const String userOrderBagNoRole = 'user-order-bags';

  static const String conversations = '/messaging/conversations';
  static const String chat = '/messaging/chat';

  // ============ orders
  // provider orders
  static const String providerOrdersByStatus = '$provider/orders-by-status';
  static const String providerOrdersByStatusNoRole = 'orders-by-status';

  static const String providerOrdersDetailsByStatus =
      '$provider/orders-details-by-status';
  static const String providerOrdersDetailsByStatusNoRole =
      'orders-details-by-status';
  // user orders
  static const String userOrdersDetails = '$user/user-orders-details';
  static const String userOrdersDetailsNoRole = 'user-orders-details';

  // ============ jobs
  // rider jobs
  static const String riderJobsByStatus = '$rider/rider-jobs-by-status';
  static const String riderJobsByStatusNoRole = 'rider-jobs-by-status';

  static const String riderJobsDetails = '$rider/rider-jobs-details';
  static const String riderJobsDetailsNoRole = 'rider-jobs-details';

  // App routes
  static const String home = '/home';
  static const String notification = '/notifications';

  static const String imageFullScreen = "/image-full-screen";
  // bottom nav
  static const String bottomNav = "/bottom-nav";

  static const String updateLocation = "/update-location";
  //
  static const String createService = '$provider/create-service';
  static const String createServiceNoRole = "/create-service";

  static const String detailsService = '$provider/details-service';
  static const String detailsServiceNoRole = "/details-service";

  static const String userServiceBooking = '$user/service-booking';
  static const String userServiceBookingNoRole = "/service-booking";

  static const String userBagCheckout = '$user/bag-checkout';
  static const String userBagCheckoutNoRole = "/bag-checkout";

  static const String userServiceCheckout = '$user/service-checkout';
  static const String userServiceCheckoutNoRole = "/service-checkout";

  // provider orders
  static const String providerBusinessHours = '$provider/business-hours';
  static const String providerBusinessHoursNoRole = 'business-hours';

  static const String onboardScreen = '/onboard-screen';
  static const String jobMapScreen = '/job-map-screen';
  static const String jobScanQrScreen = '/job-scan-qr-screen';
  static const String orderScanQrScreen = '/order-scan-qr-screen';

  // role based
  static const String user = '/user';
  static const String rider = '/rider';
  static const String provider = '/provider';
}
