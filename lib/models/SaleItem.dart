import 'package:pos_restoran/models/Product.dart';

class SaleItem {
  final int id;
  final int quantity;
  final double subtotal;
  final Product? product;

  SaleItem({
    required this.id,
    required this.quantity,
    required this.subtotal,
    this.product,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }
}
