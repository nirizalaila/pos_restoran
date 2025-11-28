import './Product.dart';
import './user.dart';
import './Location.dart';

class StockMovement {
  final int id;
  final double quantityChange;
  final String type;
  final String remarks;
  final DateTime createdAt;
  final User? user;
  final Product? product;
  final Location? location;

  StockMovement({
    required this.id,
    required this.quantityChange,
    required this.type,
    required this.remarks,
    required this.createdAt,
    this.user,
    this.product,
    this.location,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'] as int,
      quantityChange:
          double.tryParse(json['quantity_change'].toString()) ?? 0.0,
      type: json['type'] as String,
      remarks: json['remarks'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),

      user: json['user'] != null ? User.fromJson(json['user']) : null,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
  }
}
