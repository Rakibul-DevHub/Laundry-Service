part of "../api_client.dart";

/// [ApiEndpoints] API endpoints for the app
class ApiEndpoints {
  ApiEndpoints._();
  //*-----------------------Auth endpoints-----------------------------------------------//

  static const String register = '${AppConstants.baseUrl}/auth/register';
  static const String login = '${AppConstants.baseUrl}/auth/login';
  static const String forgotPassword =
      '${AppConstants.baseUrl}/auth/forgot-password';
  static const String verifyOtp = '${AppConstants.baseUrl}/auth/verify-email';
  static const String verifyResetOtp =
      '${AppConstants.baseUrl}/auth/verify-reset-otp';
  static const String resendVerification =
      '${AppConstants.baseUrl}/auth/resend-verification';
  static const String resendOtp = '${AppConstants.baseUrl}/auth/resend-otp';
  static const String resetPassword =
      '${AppConstants.baseUrl}/auth/reset-password';
  static const String changePassword =
      '${AppConstants.baseUrl}/auth/change-password';

  static const String refreshToken =
      '${AppConstants.baseUrl}/auth/refresh-token';
  static const String logout = '${AppConstants.baseUrl}/auth/logout';

  //*-----------------------Profile endpoints-----------------------------------------------//
  // Profile endpoints
  static const String account = '${AppConstants.baseUrl}/users/account';
  static const String userProfile = '${AppConstants.baseUrl}/users/profile';
  static const String providerProfile =
      '${AppConstants.baseUrl}/providers/profile';

  static const String userProfilePicture =
      '${AppConstants.baseUrl}/users/profile/picture';
  static const String providerProfilePicture =
      '${AppConstants.baseUrl}/providers/profile/picture';
  static const String userLocations = '${AppConstants.baseUrl}/locations/me';
  static const String locations = '${AppConstants.baseUrl}/locations';
  static const String userLocationsDefault =
      '${AppConstants.baseUrl}/locations/default';
  static const String userLocationsSearch =
      '${AppConstants.baseUrl}/locations/search';
  static const String userLocationsSave =
      '${AppConstants.baseUrl}/locations/save';

  //*-----------------------Profile Rider endpoints-----------------------------------------------//
  static const String riderProfile = '${AppConstants.baseUrl}/riders/profile';
  static const String riderDocuments =
      '${AppConstants.baseUrl}/riders/documents';
  static const String riderDocumentsNid =
      '${AppConstants.baseUrl}/riders/documents/nid';
  static const String riderDocumentsDrivingLicense =
      '${AppConstants.baseUrl}/riders/documents/driving-license';
  static const String riderDocumentsInsurance =
      '${AppConstants.baseUrl}/riders/documents/insurance';
  static const String riderDocumentsSelfie =
      '${AppConstants.baseUrl}/riders/documents/selfie';
  static const String riderDocumentsVehicle =
      '${AppConstants.baseUrl}/riders/documents/vehicle';
  static const String riderProfilePicture =
      '${AppConstants.baseUrl}/riders/profile/picture';

  //*-----------------------Rider Document Verify-----------------------------------------------//
  static const String uploadRiderNid =
      '${AppConstants.baseUrl}/upload/rider/nid';
  static const String uploadRiderLicense =
      '${AppConstants.baseUrl}/upload/rider/license';
  static const String uploadRiderInsurance =
      '${AppConstants.baseUrl}/upload/rider/insurance';
  static const String uploadRiderSelfie =
      '${AppConstants.baseUrl}/upload/rider/selfie';
  static const String uploadRiderVehicle =
      '${AppConstants.baseUrl}/upload/rider/vehicle';
  static const String riderProfileDocuments =
      '${AppConstants.baseUrl}/profile/rider/documents';
  static const String riderProfileDocumentsSubmit =
      '${AppConstants.baseUrl}/profile/rider/submit';
  static const String riderAvailability =
      '${AppConstants.baseUrl}/riders/availability';
  static const String riderDashboard =
      '${AppConstants.baseUrl}/riders/dashboard';
  static const String riderEarnings =
      '${AppConstants.baseUrl}/payments/rider/earnings';
  static const String providerEarnings =
      '${AppConstants.baseUrl}/payments/provider/earnings';
  static const String riderLocation = '${AppConstants.baseUrl}/riders/location';

  //*---------------------------------------------------------------------//
  static const String providerDashboard =
      '${AppConstants.baseUrl}/providers/dashboard';
  static const String serviceCategories =
      '${AppConstants.baseUrl}/public/service-categories';
  static const String productCategories =
      '${AppConstants.baseUrl}/public/product-categories';
  static const String providerServices =
      '${AppConstants.baseUrl}/providers/services';
  static const String services = '${AppConstants.baseUrl}/public/services';
  static const String bagDetails = '${AppConstants.baseUrl}/bags/details';
  static const String userBags = '${AppConstants.baseUrl}/bags/my';
  static const String bagRequestExtra =
      '${AppConstants.baseUrl}/bags/request-extra';
  static const String bagCheckout =
      '${AppConstants.baseUrl}/payments/bag/checkout';
  static const String providerBusinessHours =
      '${AppConstants.baseUrl}/providers/business-hours';
  static const String userServiceOrders = '${AppConstants.baseUrl}/orders';
  static const String userServiceOrdersList =
      '${AppConstants.baseUrl}/orders/my';
  static const String providerOrders =
      '${AppConstants.baseUrl}/providers/orders';
  static const String riderAvailableOrders =
      '${AppConstants.baseUrl}/riders/orders/available';
  static const String riderStripeOnboard =
      '${AppConstants.baseUrl}/payments/rider/stripe/onboard';
  static const String providerStripeOnboard =
      '${AppConstants.baseUrl}/payments/provider/stripe/onboard';
  static const String riderWithdraw =
      '${AppConstants.baseUrl}/payments/rider/earnings/withdraw';
  static const String providerWithdraw =
      '${AppConstants.baseUrl}/payments/provider/earnings/withdraw';
  static const String riderEarningsTransaction =
      '${AppConstants.baseUrl}/payments/rider/earnings/transactions';
  static const String providerEarningsTransaction =
      '${AppConstants.baseUrl}/payments/provider/earnings/transactions';
  static const String riderOrders = '${AppConstants.baseUrl}/riders/orders';
  static String providerBusinessHoursById(String providerId) =>
      '${AppConstants.baseUrl}/public/providers/$providerId/business-hours';
  static String providerServicesProducts(String serviceId) =>
      '${AppConstants.baseUrl}/public/providers/$serviceId/services/products';
  static String userServiceCheckout(String orderId) =>
      '${AppConstants.baseUrl}/payments/order/$orderId/checkout';
  //*-----------------------General-----------------------------------------------//
  static const String termAndConditions =
      '${AppConstants.baseUrl}/public/content/terms';
  static const String privacyPolicy =
      '${AppConstants.baseUrl}/public/content/privacy';
  static const String support =
      '${AppConstants.baseUrl}/public/content/support';
  static const String conversations =
      '${AppConstants.baseUrl}/messages/conversations';
  static const String reportConversation =
      '${AppConstants.baseUrl}/messages/report';
  static const String messages = '${AppConstants.baseUrl}/messages';
  static String deleteConversation(String id) =>
      '${AppConstants.baseUrl}/messages/conversations/$id';

  static const String contactUs =
      '${AppConstants.baseUrl}/settings/content/contactUs';
  static const String banners = '${AppConstants.baseUrl}/public/banners';
  static const String notifications = '${AppConstants.baseUrl}/notifications';
  static const String fcmToken =
      '${AppConstants.baseUrl}/notifications/fcm-token';
}
