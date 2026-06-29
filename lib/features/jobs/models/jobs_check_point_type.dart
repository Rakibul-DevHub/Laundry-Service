// features/riders/jobs/models/jobs_check_point_type.dart

import 'package:flutter/material.dart';

enum JobsCheckPointType {
  // === Pickup Leg ===
  pickupAssigned, // PICKUP_RIDER_ASSIGNED
  arrivedAtPickup, // ARRIVED_AT_PICKUP
  itemsPickedUp, // PICKED_UP
  arrivedAtDropoff, // ARRIVED_AT_DROPOFF (at provider)
  receivedAtProvider, // RECEIVED_AT_PROVIDER
  // === Delivery Leg ===
  deliveryAssigned, // DELIVERY_RIDER_ASSIGNED
  deliveryCollected, // OUT_FOR_DELIVERY
  deliveryArrived, // ARRIVED_AT_DROPOFF (at customer)
  delivered, // DELIVERED
  // === Common ===
  cancelled, // CANCELLED
}

JobsCheckPointType jobsCheckPointTypeFromApiString(String? backendStatus) {
  if (backendStatus == null) {
    return JobsCheckPointType.pickupAssigned;
  }
  final String status = backendStatus.toUpperCase().trim();
  switch (status) {
    case 'DELIVERY_RIDER_ASSIGNED':
    case 'PICKUP_RIDER_ASSIGNED':
    case 'AWAITING_PICKUP_RIDER':
      return JobsCheckPointType.pickupAssigned;
    case 'ARRIVED_AT_PICKUP':
    case 'ARRIVED_AT_DROPOFF':
      return JobsCheckPointType.arrivedAtPickup;
    case 'PICKED_UP':
    case 'IN_PROCESSING':
    case 'OUT_FOR_DELIVERY':
      return JobsCheckPointType.itemsPickedUp;
    case 'READY_FOR_DELIVERY':
    case 'ARRIVED_AT_PROVIDER':
      return JobsCheckPointType.arrivedAtDropoff;
    case 'RECEIVED_AT_PROVIDER':
      return JobsCheckPointType.receivedAtProvider;
    // case 'AWAITING_DELIVERY_RIDER':
    //   return JobsCheckPointType.deliveryAssigned;
    // case 'OUT_FOR_DELIVERY':
    //   return JobsCheckPointType.deliveryCollected;
    case 'DELIVERED':
    case 'COMPLETED':
    case 'AWAITING_DELIVERY_RIDER':
      return JobsCheckPointType.delivered;
    case 'CANCELLED':
      return JobsCheckPointType.cancelled;
    default:
      return JobsCheckPointType.pickupAssigned;
  }
}

extension JobsCheckPointTypeExtensions on JobsCheckPointType {
  String get statusToTitle {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
        return "Head To Pickup";
      case JobsCheckPointType.arrivedAtPickup:
        return "Arrived at Pickup";
      case JobsCheckPointType.itemsPickedUp:
        return "Items Picked Up";
      case JobsCheckPointType.arrivedAtDropoff:
        return "Arrived at Drop-Off";
      case JobsCheckPointType.receivedAtProvider:
        return "Received at Provider";
      case JobsCheckPointType.deliveryAssigned:
        return "Head to Provider";
      case JobsCheckPointType.deliveryCollected:
        return "Out for Delivery";
      case JobsCheckPointType.deliveryArrived:
        return "Arrived at Customer";
      case JobsCheckPointType.delivered:
        return "Delivered";
      case JobsCheckPointType.cancelled:
        return "Cancelled";
    }
  }

  String get statusToMessage {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
        return "Head To The Pick-Up Location";
      case JobsCheckPointType.arrivedAtPickup:
        return "Collect The Items From The Customer";
      case JobsCheckPointType.itemsPickedUp:
        return "Head To The Drop-Off Location";
      case JobsCheckPointType.arrivedAtDropoff:
        return "Wait for Provider to Scan";
      case JobsCheckPointType.receivedAtProvider:
        return "Items Received at Provider";
      case JobsCheckPointType.deliveryAssigned:
        return "Head To Provider Pickup";
      case JobsCheckPointType.deliveryCollected:
        return "Head To Customer Drop-Off";
      case JobsCheckPointType.deliveryArrived:
        return "Drop-off the items to customer";
      case JobsCheckPointType.delivered:
        return "Order Completed";
      case JobsCheckPointType.cancelled:
        return "Order was cancelled";
    }
  }

  String get statusToDescription {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
        return "Drive safely to the customer's pick-up location";
      case JobsCheckPointType.arrivedAtPickup:
        return "Scan bag QR codes to collect items";
      case JobsCheckPointType.itemsPickedUp:
        return "Drive safely to the provider location";
      case JobsCheckPointType.arrivedAtDropoff:
        return "Provider will verify and scan items";
      case JobsCheckPointType.receivedAtProvider:
        return "Provider has received the items";
      case JobsCheckPointType.deliveryAssigned:
        return "Drive safely to the provider location";
      case JobsCheckPointType.deliveryCollected:
        return "Drive safely to the customer's location";
      case JobsCheckPointType.deliveryArrived:
        return "Complete the delivery to customer";
      case JobsCheckPointType.delivered:
        return "Job completed successfully";
      case JobsCheckPointType.cancelled:
        return "This order is no longer active";
    }
  }

  int get statusToIndex {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
        return 0;
      case JobsCheckPointType.arrivedAtPickup:
        return 1;
      case JobsCheckPointType.itemsPickedUp:
        return 2;
      case JobsCheckPointType.arrivedAtDropoff:
        return 3;
      case JobsCheckPointType.receivedAtProvider:
        return 4;
      case JobsCheckPointType.deliveryAssigned:
        return 5;
      case JobsCheckPointType.deliveryCollected:
        return 6;
      case JobsCheckPointType.deliveryArrived:
        return 7;
      case JobsCheckPointType.delivered:
        return 8;
      case JobsCheckPointType.cancelled:
        return 8;
    }
  }

  String get checkpointAction {
    switch (this) {
      case JobsCheckPointType.arrivedAtPickup:
        return 'ARRIVED_AT_PICKUP';
      case JobsCheckPointType.arrivedAtDropoff:
        return 'ARRIVED_AT_DROPOFF';
      case JobsCheckPointType.itemsPickedUp:
        return 'PICKED_UP';
      case JobsCheckPointType.deliveryCollected:
        return 'OUT_FOR_DELIVERY';
      case JobsCheckPointType.delivered:
        return 'DELIVERED';
      default:
        return '';
    }
  }

  String get legType {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
      case JobsCheckPointType.arrivedAtPickup:
      case JobsCheckPointType.itemsPickedUp:
      case JobsCheckPointType.arrivedAtDropoff:
      case JobsCheckPointType.receivedAtProvider:
        return 'PICKUP';
      case JobsCheckPointType.deliveryAssigned:
      case JobsCheckPointType.deliveryCollected:
      case JobsCheckPointType.deliveryArrived:
      case JobsCheckPointType.delivered:
        return 'DELIVERY';
      default:
        return 'PICKUP';
    }
  }

  bool canTransitionTo(JobsCheckPointType next) {
    if (next == JobsCheckPointType.cancelled) {
      return true;
    }
    return next.statusToIndex == statusToIndex + 1;
  }

  JobsCheckPointType? get nextCheckpoint {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
        return JobsCheckPointType.arrivedAtPickup;
      case JobsCheckPointType.arrivedAtPickup:
        return JobsCheckPointType.itemsPickedUp;
      case JobsCheckPointType.itemsPickedUp:
        return JobsCheckPointType.arrivedAtDropoff;
      case JobsCheckPointType.arrivedAtDropoff:
        return JobsCheckPointType.receivedAtProvider;
      case JobsCheckPointType.receivedAtProvider:
        return JobsCheckPointType.deliveryAssigned;
      case JobsCheckPointType.deliveryAssigned:
        return JobsCheckPointType.deliveryCollected;
      case JobsCheckPointType.deliveryCollected:
        return JobsCheckPointType.deliveryArrived;
      case JobsCheckPointType.deliveryArrived:
        return JobsCheckPointType.delivered;
      default:
        return null;
    }
  }

  JobsCheckPointType? get previousCheckpoint {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
        return null;
      case JobsCheckPointType.arrivedAtPickup:
        return JobsCheckPointType.pickupAssigned;
      case JobsCheckPointType.itemsPickedUp:
        return JobsCheckPointType.arrivedAtPickup;
      case JobsCheckPointType.arrivedAtDropoff:
        return JobsCheckPointType.itemsPickedUp;
      case JobsCheckPointType.receivedAtProvider:
        return JobsCheckPointType.arrivedAtDropoff;
      case JobsCheckPointType.deliveryAssigned:
        return JobsCheckPointType.receivedAtProvider;
      case JobsCheckPointType.deliveryCollected:
        return JobsCheckPointType.deliveryAssigned;
      case JobsCheckPointType.deliveryArrived:
        return JobsCheckPointType.deliveryCollected;
      default:
        return JobsCheckPointType.deliveryArrived;
    }
  }

  Color get statusColor {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
        return Colors.orange;
      case JobsCheckPointType.arrivedAtPickup:
        return Colors.blue;
      case JobsCheckPointType.itemsPickedUp:
        return Colors.purple;
      case JobsCheckPointType.arrivedAtDropoff:
        return Colors.indigo;
      case JobsCheckPointType.receivedAtProvider:
        return Colors.teal;
      case JobsCheckPointType.deliveryAssigned:
        return Colors.orange;
      case JobsCheckPointType.deliveryCollected:
        return Colors.purple;
      case JobsCheckPointType.deliveryArrived:
        return Colors.indigo;
      case JobsCheckPointType.delivered:
        return Colors.green;
      case JobsCheckPointType.cancelled:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (this) {
      case JobsCheckPointType.pickupAssigned:
        return Icons.navigation_outlined;
      case JobsCheckPointType.arrivedAtPickup:
        return Icons.location_on_outlined;
      case JobsCheckPointType.itemsPickedUp:
        return Icons.local_shipping_outlined;
      case JobsCheckPointType.arrivedAtDropoff:
        return Icons.store_outlined;
      case JobsCheckPointType.receivedAtProvider:
        return Icons.check_circle_outline;
      case JobsCheckPointType.deliveryAssigned:
        return Icons.navigation_outlined;
      case JobsCheckPointType.deliveryCollected:
        return Icons.local_shipping_outlined;
      case JobsCheckPointType.deliveryArrived:
        return Icons.home_outlined;
      case JobsCheckPointType.delivered:
        return Icons.task_alt_outlined;
      case JobsCheckPointType.cancelled:
        return Icons.cancel_outlined;
    }
  }

  bool get requiresQrScan => this == JobsCheckPointType.arrivedAtPickup;
  bool get requiresProviderScan => this == JobsCheckPointType.arrivedAtDropoff;
}
