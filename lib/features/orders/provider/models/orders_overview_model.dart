// dashboard_stats_response.dart

class DashboardStatsResponse {
  final int code;
  final bool success;
  final String message;
  final OrdersOverviewModel data;

  DashboardStatsResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardStatsResponse.fromJson(Map<String, dynamic> json) {
    return DashboardStatsResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrdersOverviewModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
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

  DashboardStatsResponse copyWith({
    int? code,
    bool? success,
    String? message,
    OrdersOverviewModel? data,
  }) {
    return DashboardStatsResponse(
      code: code ?? this.code,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

// dashboard_stats_data.dart

class OrdersOverviewModel {
  final int newBookings;
  final int acceptOrders;
  final int readyToReceive;
  final int receivedOrders;
  final int processingOrders;
  final int readyForDelivery;
  final int completedOrders;
  final int canceledOrders;

  OrdersOverviewModel({
    required this.newBookings,
    required this.acceptOrders,
    required this.readyToReceive,
    required this.receivedOrders,
    required this.processingOrders,
    required this.readyForDelivery,
    required this.completedOrders,
    required this.canceledOrders,
  });

  factory OrdersOverviewModel.fromJson(Map<String, dynamic> json) {
    return OrdersOverviewModel(
      newBookings: json['newBookings'] as int? ?? 0,
      acceptOrders: json['acceptOrders'] as int? ?? 0,
      readyToReceive: json['readyToReceive'] as int? ?? 0,
      receivedOrders: json['receivedOrders'] as int? ?? 0,
      processingOrders: json['processingOrders'] as int? ?? 0,
      readyForDelivery: json['readyForDelivery'] as int? ?? 0,
      completedOrders: json['completedOrders'] as int? ?? 0,
      canceledOrders: json['canceledOrders'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'newBookings': newBookings,
      'acceptOrders': acceptOrders,
      'readyToReceive': readyToReceive,
      'receivedOrders': receivedOrders,
      'processingOrders': processingOrders,
      'readyForDelivery': readyForDelivery,
      'completedOrders': completedOrders,
      'canceledOrders': canceledOrders,
    };
  }

  OrdersOverviewModel copyWith({
    int? newBookings,
    int? acceptOrders,
    int? receivedOrders,
    int? processingOrders,
    int? readyForDelivery,
    int? completedOrders,
    int? canceledOrders,
    int? readyToReceive,
  }) {
    return OrdersOverviewModel(
      newBookings: newBookings ?? this.newBookings,
      acceptOrders: acceptOrders ?? this.acceptOrders,
      receivedOrders: receivedOrders ?? this.receivedOrders,
      processingOrders: processingOrders ?? this.processingOrders,
      readyToReceive: readyToReceive ?? this.readyToReceive,
      readyForDelivery: readyForDelivery ?? this.readyForDelivery,
      completedOrders: completedOrders ?? this.completedOrders,
      canceledOrders: canceledOrders ?? this.canceledOrders,
    );
  }


}
