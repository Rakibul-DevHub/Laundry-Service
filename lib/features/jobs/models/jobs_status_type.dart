import '../../../../core/config/icons.dart';

enum JobStatusType {
  newOrders,
  ongoingOrders,
  completedOrders,
  canceledOrders,
}

extension JobStatusTypeExtensions on JobStatusType {
  String get typeToTitle {
    switch (this) {
      case JobStatusType.newOrders:
        return "New Orders";
      case JobStatusType.ongoingOrders:
        return "Ongoing Orders";
      case JobStatusType.completedOrders:
        return "Completed Orders";
      case JobStatusType.canceledOrders:
        return "Canceled Order";
    }
  }

  String get typeToIcon {
    switch (this) {
      case JobStatusType.newOrders:
        return AppIcons.orderReceived;
      case JobStatusType.ongoingOrders:
        return AppIcons.orderProcessing;
      case JobStatusType.completedOrders:
        return AppIcons.orderCompleted;
      case JobStatusType.canceledOrders:
        return AppIcons.orderDelivery;
    }
  }
}
