import 'package:flutter/material.dart';

class HistoryDetailDialog extends StatelessWidget {
  final Map<String, dynamic> sale;

  const HistoryDetailDialog({
    super.key,
    required this.sale,
  });

  double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  String _formatDateTime(dynamic value) {
    if (value == null) return "-";
    final s = value.toString();
    try {
      final dt = DateTime.parse(s);
      return "${dt.day.toString().padLeft(2, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.year} "
          "${dt.hour.toString().padLeft(2, '0')}:"
          "${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoice = sale['invoice_number']?.toString() ?? '-';
    final total = _toDouble(sale['total_amount']);
    final createdAt = sale['created_at']?.toString() ?? '';
    final userName = sale['user']?['name']?.toString() ?? 'Kasir';
    final items = (sale['items'] as List<dynamic>? ?? []);

    final formattedDate = _formatDateTime(createdAt);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 260, vertical: 60),
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
              "Invoice $invoice",
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
                Text("Kasir: $userName"),
                Text("Tanggal: $formattedDate"),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 6),
                const Text(
                  "Items",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),

                ...items.map((raw) {
                  final item = raw as Map<String, dynamic>;
                  final qty = item['quantity'] ?? 0;
                  final subtotal = _toDouble(item['subtotal']);
                  final productName =
                      item['product']?['name']?.toString() ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "$qty x $productName",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(
                          "Rp ${subtotal.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Text(
                      "Rp ${total.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF243457),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
