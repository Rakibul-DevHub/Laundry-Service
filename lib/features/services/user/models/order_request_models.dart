// features/services/user/models/order_request_models.dart

import 'package:flutter/foundation.dart';

// ============================================================================
//  REQUEST MODELS (Send to Backend)
// ============================================================================

/// Request body for placing an order or calculating price summary
@immutable
class PlaceOrderRequest {
  final String providerId;
  final List<String> bagIds;
  final List<OrderLineRequest> orderLines;
  final String specialInstructions;
  final String? scheduledPickupDate; // ISO 8601 format
  final String? scheduledPickupSlot; // e.g., "9am-10am"
  final String deliveryInstruction; // e.g., "KNOCK_AT_DOOR"
  final String driverType; // "HIRE_CARRIER" or "MYSELF"

  const PlaceOrderRequest({
    required this.providerId,
    required this.bagIds,
    required this.orderLines,
    required this.specialInstructions,
    this.scheduledPickupDate,
    this.scheduledPickupSlot,
    required this.deliveryInstruction,
    required this.driverType,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'providerId': providerId,
    'bagIds': bagIds,
    'orderLines': orderLines
        .map((OrderLineRequest line) => line.toJson())
        .toList(),
    'specialInstructions': specialInstructions,
    if (scheduledPickupDate != null) 'scheduledPickupDate': scheduledPickupDate,
    if (scheduledPickupSlot != null) 'scheduledPickupSlot': scheduledPickupSlot,
    'deliveryInstruction': deliveryInstruction,
    'driverType': driverType,
  };

  @override
  String toString() =>
      'PlaceOrderRequest(providerId: $providerId, bagIds: $bagIds, orderLines: ${orderLines.length}, driverType: $driverType)';
}

/// Individual order line item (product + quantity)
@immutable
class OrderLineRequest {
  final String itemId;
  final int quantity;

  const OrderLineRequest({
    required this.itemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'itemId': itemId,
    'quantity': quantity,
  };

  @override
  String toString() => 'OrderLineRequest(itemId: $itemId, quantity: $quantity)';
}
