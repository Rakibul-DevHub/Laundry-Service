class ServiceCheckoutResponseModel {
  final int code;
  final bool success;
  final String message;
  final ServiceCheckoutData data;

  ServiceCheckoutResponseModel({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceCheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceCheckoutResponseModel(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ServiceCheckoutData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ServiceCheckoutData {
  final String checkoutUrl;
  final String checkoutSessionId;
  final int amount; // in cents
  final String orderId;

  ServiceCheckoutData({
    required this.checkoutUrl,
    required this.checkoutSessionId,
    required this.orderId,
    required this.amount,
  });

  factory ServiceCheckoutData.fromJson(Map<String, dynamic> json) {
    return ServiceCheckoutData(
      checkoutUrl: json['checkoutUrl'] as String,
      checkoutSessionId: json['checkoutSessionId'] as String,
      orderId: json['orderId'] as String,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'checkoutUrl': checkoutUrl,
      'checkoutSessionId': checkoutSessionId,
      'orderId': orderId,
      'amount': amount,
    };
  }

  double get amountInDollars => amount / 100;
}
