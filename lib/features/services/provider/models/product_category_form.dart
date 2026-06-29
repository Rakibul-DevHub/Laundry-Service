import 'create_service_request.dart';

class ProductCategoryForm {
  final String id; // Unique ID for this form item
  final String productCategoryId;
  final List<ServiceItem> items;
  final String? error;

  ProductCategoryForm({
    required this.id,
    this.productCategoryId = '',
    this.items = const <ServiceItem>[],
    this.error,
  });

  ProductCategoryForm copyWith({
    String? productCategoryId,
    List<ServiceItem>? items,
    String? error,
  }) {
    return ProductCategoryForm(
      id: id,
      productCategoryId: productCategoryId ?? this.productCategoryId,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }

  bool get isValid =>
      productCategoryId.isNotEmpty &&
      items.isNotEmpty &&
      items.every((ServiceItem i) => i.name.isNotEmpty && i.price > 0);

  ProductCategoryItem toItem() {
    return ProductCategoryItem(
      productCategoryId: productCategoryId,
      items: items,
    );
  }
}
