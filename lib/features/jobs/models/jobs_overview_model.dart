class RiderDashboardStatsResponse {
  final int code;
  final bool success;
  final String message;
  final JobsOverviewModel data;

  RiderDashboardStatsResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory RiderDashboardStatsResponse.fromJson(Map<String, dynamic> json) {
    return RiderDashboardStatsResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: JobsOverviewModel.fromJson(
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

  RiderDashboardStatsResponse copyWith({
    int? code,
    bool? success,
    String? message,
    JobsOverviewModel? data,
  }) {
    return RiderDashboardStatsResponse(
      code: code ?? this.code,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class JobsOverviewModel {
  final int marketJobs;
  final int newOrders;
  final int ongoingOrders;
  final int completedOrders;
  final int cancelledOrders;

  const JobsOverviewModel({
    required this.marketJobs,
    required this.newOrders,
    required this.ongoingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
  });

  factory JobsOverviewModel.fromJson(Map<String, dynamic> json) {
    return JobsOverviewModel(
      marketJobs: json['marketJobs'] as int? ?? 0,
      newOrders: json['newOrders'] as int? ?? 0,
      ongoingOrders: json['ongoingOrders'] as int? ?? 0,
      completedOrders: json['completedOrders'] as int? ?? 0,
      cancelledOrders: json['cancelledOrders'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'marketJobs': marketJobs,
      'newOrders': newOrders,
      'ongoingOrders': ongoingOrders,
      'completedOrders': completedOrders,
      'cancelledOrders': cancelledOrders,
    };
  }

  JobsOverviewModel copyWith({
    int? marketJobs,
    int? newOrders,
    int? ongoingOrders,
    int? completedOrders,
    int? cancelledOrders,
  }) {
    return JobsOverviewModel(
      marketJobs: marketJobs ?? this.marketJobs,
      newOrders: newOrders ?? this.newOrders,
      ongoingOrders: ongoingOrders ?? this.ongoingOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
    );
  }

  // Optional: Total orders helper
  int get totalOrders =>
      newOrders + ongoingOrders + completedOrders + cancelledOrders;

  // Optional: Active orders helper
  int get activeOrders => newOrders + ongoingOrders;
}
