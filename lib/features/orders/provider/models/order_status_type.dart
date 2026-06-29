import '../../../../core/config/icons.dart';

enum OrderStatusType {
  newBookings,
  acceptOrders,
  readyToReceive,
  receivedOrders,
  processingOrders,
  readyForDelivery,
  completedOrders,
  canceledOrders,
}

extension OrderStatusTypeExtensions on OrderStatusType {
  String get typeToTitle {
    switch (this) {
      case OrderStatusType.newBookings:
        return "New Bookings";
      case OrderStatusType.acceptOrders:
        return "Accepted Orders";
      case OrderStatusType.readyToReceive:
        return "Ready To Receive";
      case OrderStatusType.receivedOrders:
        return "Item Received";
      case OrderStatusType.processingOrders:
        return "Processing";
      case OrderStatusType.readyForDelivery:
        return "Ready For Delivery";
      case OrderStatusType.completedOrders:
        return "Completed";
      case OrderStatusType.canceledOrders:
        return "Canceled";
    }
  }

  String get typeToIcon {
    switch (this) {
      case OrderStatusType.newBookings:
        return AppIcons.orderNewBookings;
      case OrderStatusType.acceptOrders:
        return AppIcons.orderAccepted;
      case OrderStatusType.readyToReceive:
        return AppIcons.orderAccepted;
      case OrderStatusType.receivedOrders:
        return AppIcons.orderReceived;
      case OrderStatusType.processingOrders:
        return AppIcons.orderProcessing;
      case OrderStatusType.readyForDelivery:
        return AppIcons.orderDelivery;
      case OrderStatusType.completedOrders:
        return AppIcons.orderCompleted;
      case OrderStatusType.canceledOrders:
        return AppIcons.deleteAccountWarning;
    }
  }
}
