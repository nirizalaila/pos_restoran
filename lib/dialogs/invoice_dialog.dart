import 'package:flutter/material.dart';

class InvoiceDialog extends StatelessWidget {
  final Map<String, dynamic> saleData;
  final String paymentMethod;

  const InvoiceDialog({
    super.key,
    required this.saleData,
    required this.paymentMethod,
  });

  String _methodLabel(String method) {
    switch (method) {
      case 'cash':
        return 'Tunai';
      case 'transfer':
        return 'Transfer';
      case 'qris':
        return 'QRIS';
      default:
        return method;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = (saleData['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    final invoiceNumber = saleData['invoice_number']?.toString() ?? '-';
    final totalAmount = (saleData['total_amount'] ?? 0).toDouble();
    final saleDate = saleData['sale_date']?.toString() ?? '';
    final locationName =
        saleData['location']?['name']?.toString() ?? 'Outlet';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 250, vertical: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF334B76),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: const Text(
              "Struk Transaksi",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Inventara F&B",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  locationName,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text(
                  "Invoice: $invoiceNumber",
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  "Tanggal: $saleDate",
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  "Metode: ${_methodLabel(paymentMethod)}",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: items.map((item) {
                final name = item['product_name']?.toString() ?? '';
                final qty = item['quantity'] ?? 0;
                final price = (item['price_at_sale'] ?? 0).toDouble();
                final subtotal = (item['subtotal'] ?? 0).toDouble();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          "$qty x $name",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Rp ${price.toStringAsFixed(0)}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Rp ${subtotal.toStringAsFixed(0)}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Rp ${totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334B76),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              "Terima kasih telah berbelanja",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "Silakan tunjukkan struk ini jika diperlukan.",
              style: TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 12),
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Selesai"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
