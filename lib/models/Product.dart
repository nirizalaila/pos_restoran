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
    return Product(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),

      name: json['name'] as String,

      salePrice: json['sale_price'] is num
          ? (json['sale_price'] as num).toDouble()
          : double.tryParse(json['sale_price'].toString()) ?? 0.0,

      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.parse(json['category_id'].toString()),

      sku: json['sku'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sale_price': salePrice,
      'category_id': categoryId,
      'sku': sku,
    };
  }
}
