import './SaleItem.dart';
import './user.dart';

class Sale {
  final int id;
  final String invoiceNumber;
  final double totalAmount;
  final User? user; // Pengguna (Kasir)
  final List<SaleItem>? items; // Detail barang yang dijual

  Sale({
    required this.id,
    required this.invoiceNumber,
    required this.totalAmount,
    this.user,
    this.items,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? itemsJson = json['items'];

    return Sale(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,

      // Parsing relasi
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      items: itemsJson?.map((i) => SaleItem.fromJson(i)).toList(),
    );
  }
}
