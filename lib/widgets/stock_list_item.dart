import 'package:flutter/material.dart';

class StockListItem extends StatelessWidget {
  final String productName;
  final String? sku;
  final String? unitName;
  final String? locationName;
  final double quantity;
  final double? minStock;
  final VoidCallback onTap;

  const StockListItem({
    super.key,
    required this.productName,
    required this.sku,
    required this.unitName,
    required this.locationName,
    required this.quantity,
    required this.minStock,
    required this.onTap,
  });

  bool get isLowStock {
    if (minStock == null) return false;
    return quantity <= minStock!;
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = isLowStock ? const Color(0xFFDC2626) : const Color(0xFF16A34A);
    final badgeText = isLowStock ? "Low Stock" : "OK";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (sku != null && sku!.isNotEmpty)
                          Text(
                            "SKU: $sku",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        if (sku != null && sku!.isNotEmpty)
                          const SizedBox(width: 10),
                        if (locationName != null)
                          Text(
                            "Lokasi: $locationName",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    if (unitName != null && unitName!.isNotEmpty)
                      Text(
                        "Satuan: $unitName",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    quantity.toStringAsFixed(2).replaceAll('.00', ''),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF243457),
                    ),
                  ),
                  if (minStock != null)
                    Text(
                      "Min: ${minStock!.toStringAsFixed(2).replaceAll('.00', '')}",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: badgeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: badgeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
