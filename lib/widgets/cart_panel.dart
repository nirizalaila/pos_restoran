import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/CartProvider.dart';
import '../dialogs/qty_calculator_dialog.dart';
import '../dialogs/payment_dialog.dart';
import '../dialogs/invoice_dialog.dart';
import '../services/SalesService.dart';

class CartPanel extends StatefulWidget {
  const CartPanel({super.key});

  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
  bool _isCheckingOut = false;

  @override
  Widget build(BuildContext context) {
    const int locationId = 1; // fix sementara

    return Column(
      children: [
        // HEADER "Order Details"
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Text(
              "Order Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334B76),
              ),
            ),
          ),
        ),

        Expanded(
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada pesanan.",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];

                  return Card(
                    elevation: 1,
                    margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      onTap: () async {
                        final newQty = await showDialog<int>(
                          context: context,
                          builder: (_) =>
                              QtyCalculatorDialog(initialQty: item.quantity),
                        );

                        if (newQty != null) {
                          cart.updateQuantity(item, newQty);
                        }
                      },
                      title: Text(
                        item.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        "Rp ${item.subtotal.toStringAsFixed(0)}",
                        style: TextStyle(color: Colors.green.shade700),
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => cart.updateQuantity(
                                item, item.quantity - 1),
                          ),
                          Text(
                            "${item.quantity}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () =>
                                cart.updateQuantity(item, item.quantity + 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.dialpad),
                            onPressed: () async {
                              final newQty = await showDialog<int>(
                                context: context,
                                builder: (_) => QtyCalculatorDialog(
                                  initialQty: item.quantity,
                                ),
                              );
                              if (newQty != null) {
                                cart.updateQuantity(item, newQty);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        Consumer<CartProvider>(
          builder: (context, cart, child) =>
              checkoutSection(context, cart, locationId),
        ),
      ],
    );
  }

  Widget checkoutSection(
      BuildContext context, CartProvider cart, int locationId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Taxes", style: TextStyle(color: Colors.black54)),
              Text("Rp 0", style: TextStyle(color: Colors.black54)),
            ],
          ),
          const Divider(height: 18),

          // TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334B76)),
              ),
              Text(
                "Rp ${cart.totalAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334B76)),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ElevatedButton(
            onPressed: cart.items.isEmpty
                ? null
                : () async {
              final paymentInfo = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (_) => PaymentDialog(total: cart.totalAmount),
              );

              if (paymentInfo == null) return;

              final String method = paymentInfo['method'];

              setState(() => _isCheckingOut = true);

              try {
                final saleData =
                await Provider.of<SalesService>(context,
                    listen: false)
                    .checkout(
                  invoiceNumber: DateTime.now()
                      .millisecondsSinceEpoch
                      .toString(),
                  locationId: locationId,
                  method: method,
                  paymentCode: null,
                );

                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => InvoiceDialog(
                    saleData: saleData,
                    paymentMethod: method,
                  ),
                );

                cart.clearCart();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Transaksi berhasil"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Error: $e"),
                  ),
                );
              } finally {
                setState(() => _isCheckingOut = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size.fromHeight(55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isCheckingOut
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              "Payment",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
