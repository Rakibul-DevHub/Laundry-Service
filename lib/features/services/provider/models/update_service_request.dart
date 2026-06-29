// features/services/provider/models/update_service_request.dart

import 'dart:convert';

class UpdateServiceRequest {
  final String? description;
  final String? estimateTime;
  final bool? isActive;
  final List<UpdateProductCategory>? productCategories;

  UpdateServiceRequest({
    this.description,
    this.estimateTime,
    this.isActive,
    this.productCategories,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (description != null) {
      json['description'] = description;
    }
    if (estimateTime != null) {
      json['estimateTime'] = estimateTime;
    }
    if (isActive != null) {
      json['isActive'] = isActive;
    }
    if (productCategories != null) {
      json['productCategories'] = productCategories!
          .map((UpdateProductCategory pc) => pc.toJson())
          .toList();
    }

    return json;
  }

  @override
  String toString() {
    return 'UpdateServiceRequest(${jsonEncode(toJson())})';
  }

  String toPrettyString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }

  factory UpdateServiceRequest.full({
    required String description,
    required String estimateTime,
    required bool isActive,
    required List<UpdateProductCategory> productCategories,
  }) {
    return UpdateServiceRequest(
      description: description,
      estimateTime: estimateTime,
      isActive: isActive,
      productCategories: productCategories,
    );
  }

  factory UpdateServiceRequest.description(String description) {
    return UpdateServiceRequest(description: description);
  }

  factory UpdateServiceRequest.estimateTime(String estimateTime) {
    return UpdateServiceRequest(estimateTime: estimateTime);
  }

  factory UpdateServiceRequest.active(bool isActive) {
    return UpdateServiceRequest(isActive: isActive);
  }

  factory UpdateServiceRequest.categoryItems({
    required String productCategoryId,
    required List<UpdateServiceItem> items,
  }) {
    return UpdateServiceRequest(
      productCategories: <UpdateProductCategory>[
        UpdateProductCategory.withItems(
          productCategoryId: productCategoryId,
          items: items,
        ),
      ],
    );
  }

  factory UpdateServiceRequest.itemPrice({
    required String productCategoryId,
    required String itemName,
    required num newPrice,
  }) {
    return UpdateServiceRequest(
      productCategories: <UpdateProductCategory>[
        UpdateProductCategory.withItems(
          productCategoryId: productCategoryId,
          items: <UpdateServiceItem>[
            UpdateServiceItem.full(name: itemName, price: newPrice),
          ],
        ),
      ],
    );
  }
}

class UpdateProductCategory {
  final String id; // Internal: this is the category's _id
  final List<UpdateServiceItem>? items;

  UpdateProductCategory({
    required this.id,
    this.items,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'productCategoryId': id,
    };
    if (items != null) {
      json['items'] = items!
          .map((UpdateServiceItem item) => item.toJson())
          .toList();
    }
    return json;
  }

  @override
  String toString() {
    return 'UpdateProductCategory{id: $id, items: ${items?.length ?? 0}}';
  }

  String toPrettyString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }

  factory UpdateProductCategory.withItems({
    required String productCategoryId,
    required List<UpdateServiceItem> items,
  }) {
    return UpdateProductCategory(
      id: productCategoryId,
      items: items,
    );
  }
}

class UpdateServiceItem {
  final String? name;
  final num? price;

  UpdateServiceItem({
    this.name,
    this.price,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (name != null) {
      json['name'] = name;
    }
    if (price != null) {
      json['price'] = (price! * 100);
    }
    return json;
  }

  @override
  String toString() {
    return 'UpdateServiceItem{name: $name, price: $price}';
  }

  String toPrettyString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }

  factory UpdateServiceItem.name(String name) {
    return UpdateServiceItem(name: name);
  }

  factory UpdateServiceItem.price(num price) {
    return UpdateServiceItem(price: price);
  }

  factory UpdateServiceItem.full({required String name, required num price}) {
    return UpdateServiceItem(name: name, price: price);
  }
}
