class Product {
  final int id;
  final String name;
  final double salePrice;
  final String? sku;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.categoryId,
    this.sku,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final price = json['sale_price'];

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      salePrice: double.tryParse(price.toString()) ?? 0.0,
      categoryId: json['category_id'] as int,
      sku: json['sku'] as String?,
    );
  }
}
