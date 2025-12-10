import 'package:flutter/material.dart';

class StockDetailDialog extends StatelessWidget {
  final Map<String, dynamic> stockRow;

  const StockDetailDialog({
    super.key,
    required this.stockRow,
  });

  double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  String _extractProductName() {
    return stockRow['product_name']?.toString() ??
        stockRow['product']?['name']?.toString() ??
        stockRow['name']?.toString() ??
        '-';
  }

  String? _extractSku() {
    return stockRow['sku']?.toString() ??
        stockRow['product']?['sku']?.toString();
  }

  String? _extractLocationName() {
    return stockRow['location_name']?.toString() ??
        stockRow['location']?['name']?.toString();
  }

  String? _extractUnitName() {
    return stockRow['unit_name']?.toString() ??
        stockRow['unit']?['name']?.toString();
  }

  @override
  Widget build(BuildContext context) {
    final productName = _extractProductName();
    final sku = _extractSku();
    final locationName = _extractLocationName();
    final unitName = _extractUnitName();

    final qty = _toDouble(
      stockRow['quantity'] ??
          stockRow['stock'] ??
          stockRow['on_hand'] ??
          stockRow['qty'],
    );

    final minStock = stockRow['stock_minimum'] != null
        ? _toDouble(stockRow['stock_minimum'])
        : null;

    final isLowStock =
    (minStock != null && qty <= minStock) ? true : false;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 260, vertical: 80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF243457),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Text(
              productName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sku != null && sku.isNotEmpty) ...[
                  const Text(
                    "SKU",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  Text(
                    sku,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                ],
                if (locationName != null) ...[
                  const Text(
                    "Lokasi",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  Text(
                    locationName,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                ],
                if (unitName != null) ...[
                  const Text(
                    "Satuan",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  Text(
                    unitName,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                ],
                const Text(
                  "Stok Saat Ini",
                  style:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                Text(
                  qty.toStringAsFixed(2).replaceAll('.00', ''),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF243457),
                  ),
                ),
                if (minStock != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Minimum: ${minStock.toStringAsFixed(2).replaceAll('.00', '')}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                if (minStock != null)
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isLowStock
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isLowStock
                            ? "Stok berada di bawah minimum."
                            : "Stok masih aman di atas minimum.",
                        style: TextStyle(
                          fontSize: 12,
                          color: isLowStock
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tutup"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
