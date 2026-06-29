// ignore_for_file: always_specify_types

import 'package:flutter/foundation.dart';

class ServiceProductsResponse {
  final int code;
  final bool success;
  final String message;
  final List<ServiceProductData> data;

  ServiceProductsResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceProductsResponse.fromJson(Map<String, dynamic> json) {
    return ServiceProductsResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map(
            (item) => ServiceProductData.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

@immutable
class ServiceProductData {
  final String serviceId;
  final String serviceName;
  final String serviceSlug;
  final String estimateTime;
  final String description;
  final List<ProductCategory> productCategories;

  const ServiceProductData({
    required this.serviceId,
    required this.serviceName,
    required this.serviceSlug,
    required this.estimateTime,
    required this.description,
    required this.productCategories,
  });

  factory ServiceProductData.fromJson(Map<String, dynamic> json) {
    return ServiceProductData(
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      serviceSlug: json['serviceSlug'] as String,
      estimateTime: json['estimateTime'] as String,
      description: json['description'] as String,
      productCategories: (json['productCategories'] as List)
          .map((cat) => ProductCategory.fromJson(cat as Map<String, dynamic>))
          .toList(),
    );
  }

  List<SelectableProductItem> get allItems {
    final List<SelectableProductItem> items = <SelectableProductItem>[];
    for (final ProductCategory category in productCategories) {
      for (final ProductItem item in category.items) {
        items.add(
          SelectableProductItem(
            itemId: item.itemId,
            categoryId: category.categoryId,
            name: item.name,
            price: item.price,
            categoryName: category.categoryName,
          ),
        );
      }
    }
    return items;
  }
}

@immutable
class ProductCategory {
  final String categoryId;
  final String categoryName;
  final String categorySlug;
  final List<ProductItem> items;

  const ProductCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug,
    required this.items,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      categorySlug: json['categorySlug'] as String,
      items: (json['items'] as List)
          .map((item) => ProductItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

@immutable
class ProductItem {
  final String itemId;
  final String name;
  final num price;

  const ProductItem({
    required this.itemId,
    required this.name,
    required this.price,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num),
    );
  }
}

@immutable
class SelectableProductItem {
  final String itemId;
  final String categoryId;
  final String name;
  final num price;
  final String categoryName;
  final int quantity;

  const SelectableProductItem({
    required this.itemId,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.categoryName,
    this.quantity = 0,
  });

  SelectableProductItem copyWith({
    String? itemId,
    String? categoryId,
    String? name,
    num? price,
    String? categoryName,
    int? quantity,
  }) {
    return SelectableProductItem(
      itemId: itemId ?? this.itemId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryName: categoryName ?? this.categoryName,
      quantity: quantity ?? this.quantity,
    );
  }
}
