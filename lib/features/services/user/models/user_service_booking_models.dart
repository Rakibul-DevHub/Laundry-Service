import 'package:drop_n_fresh/core/config/images.dart';
import 'package:drop_n_fresh/features/services/user/models/service_products_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class SelectedSchedule {
  final DateTime date;
  final String timeSlot;

  const SelectedSchedule({
    required this.date,
    required this.timeSlot,
  });

  SelectedSchedule copyWith({
    DateTime? date,
    String? timeSlot,
  }) {
    return SelectedSchedule(
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'date': date.toIso8601String(),
    'timeSlot': timeSlot,
  };
}

@immutable
class BookingProductItem {
  final String id; // itemId
  final String name;
  final num price;
  final String categoryId;
  final String categoryName;
  final int quantity; // Mutable for UI updates

  const BookingProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    this.quantity = 0,
  });

  BookingProductItem copyWith({
    String? id,
    String? name,
    num? price,
    String? categoryId,
    String? categoryName,
    int? quantity,
  }) {
    return BookingProductItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      quantity: quantity ?? this.quantity,
    );
  }

  num get totalPrice => price * quantity;

  //  Convert from API item
  factory BookingProductItem.fromApiItem(SelectableProductItem item) {
    return BookingProductItem(
      id: item.itemId,
      name: item.name,
      price: item.price,
      categoryId: item.categoryId,
      categoryName: item.categoryName,
      quantity: item.quantity,
    );
  }
}

@immutable
class DeliveryInstruction {
  final String id;
  final String title;
  final String iconPath;
  final bool isSelected;

  const DeliveryInstruction({
    required this.id,
    required this.title,
    required this.iconPath,
    this.isSelected = false,
  });

  DeliveryInstruction copyWith({
    String? id,
    String? title,
    String? iconPath,
    bool? isSelected,
  }) {
    return DeliveryInstruction(
      id: id ?? this.id,
      title: title ?? this.title,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  static List<DeliveryInstruction> get defaultInstructions =>
      const <DeliveryInstruction>[
        DeliveryInstruction(
          id: 'take_from_door',
          title: 'Take from the door',
          iconPath: AppImages.fromDoor,
        ),
        DeliveryInstruction(
          id: 'knock_at_door',
          title: 'Knock at the door',
          iconPath: AppImages.nockDoor,
        ),
        DeliveryInstruction(
          id: 'leave_at_door',
          title: 'Leave at door',
          iconPath: AppImages.leaveDoor,
        ),
        DeliveryInstruction(
          id: 'avoid_bell',
          title: 'Avoid bell',
          iconPath: AppImages.avoidDoor,
        ),
      ];
}
