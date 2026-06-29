class CreateServiceRequest {
  final String serviceCategoryId;
  final String description;
  final String estimateTime;
  final List<ProductCategoryItem> productCategories;

  CreateServiceRequest({
    required this.serviceCategoryId,
    required this.description,
    required this.estimateTime,
    required this.productCategories,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'serviceCategoryId': serviceCategoryId,
      'description': description,
      'estimateTime': estimateTime,
      'productCategories': productCategories
          .map((ProductCategoryItem pc) => pc.toJson())
          .toList(),
    };
  }
}

class ProductCategoryItem {
  final String productCategoryId;
  final List<ServiceItem> items;

  ProductCategoryItem({
    required this.productCategoryId,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'productCategoryId': productCategoryId,
      'items': items.map((ServiceItem item) => item.toJson()).toList(),
    };
  }
}

class ServiceItem {
  final String name;
  final num price;

  ServiceItem({required this.name, required this.price});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'price': price * 100,
  };

  ServiceItem copyWith({String? name, num? price}) {
    return ServiceItem(name: name ?? this.name, price: price ?? this.price);
  }
}
