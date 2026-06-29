class BagCheckoutResponseModel {
  final int code;
  final bool success;
  final String message;
  final CheckoutData data;

  BagCheckoutResponseModel({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory BagCheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    return BagCheckoutResponseModel(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: CheckoutData.fromJson(json['data'] as Map<String, dynamic>),
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

class CheckoutData {
  final String? checkoutUrl;
  final String? checkoutSessionId;
  final String? bagOrderId;
  final int? amount; // in cents
  final int? bagPriceCents;
  final int? shippingCents;

  CheckoutData({
    required this.checkoutUrl,
    required this.checkoutSessionId,
    required this.bagOrderId,
    required this.amount,
    required this.bagPriceCents,
    required this.shippingCents,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      checkoutUrl: json['checkoutUrl'] as String?,
      checkoutSessionId: json['checkoutSessionId'] as String?,
      bagOrderId: json['bagOrderId'] as String?,
      amount: json['amount'] as int?,
      bagPriceCents: json['bagPriceCents'] as int?,
      shippingCents: json['shippingCents'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'checkoutUrl': checkoutUrl,
      'checkoutSessionId': checkoutSessionId,
      'bagOrderId': bagOrderId,
      'amount': amount,
      'bagPriceCents': bagPriceCents,
      'shippingCents': shippingCents,
    };
  }
}
