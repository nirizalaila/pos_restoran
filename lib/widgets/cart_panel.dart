import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/CartProvider.dart';
import '../dialogs/qty_calculator_dialog.dart';
import '../dialogs/payment_dialog.dart';
import '../services/SalesService.dart';
import '../services/AuthService.dart';

class CartPanel extends StatefulWidget {
  const CartPanel({super.key});

  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
  bool _isCheckingOut = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    final locationId = user?.id ?? 1;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: const Text("Order Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),

        Expanded(
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) {
                return const Center(child: Text("Belum ada pesanan."));
              }

              return ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: ListTile(
                      onTap: () async {
                        final newQty = await showDialog(
                          context: context,
                          builder: (_) => QtyCalculatorDialog(
                            initialQty: item.quantity,
                          ),
                        );

                        if (newQty != null) {
                          cart.updateQuantity(item, newQty);
                        }
                      },
                      title: Text(item.product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Rp ${item.subtotal.toStringAsFixed(0)}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () =>
                                cart.updateQuantity(item,item.quantity - 1),
                          ),
                          Text(
                            "${item.quantity}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => cart.updateQuantity(item, item.quantity + 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.dialpad), // tombol kalkulator
                            onPressed: () async {
                              final newQty = await showDialog(
                                context: context,
                                builder: (_) => QtyCalculatorDialog(initialQty: item.quantity),
                              );
                              if (newQty != null) cart.updateQuantity(item, newQty);
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
          builder: (context, cart, child) => checkoutSection(context, cart, locationId),
        ),
      ],
    );
  }

  Widget checkoutSection(BuildContext context, CartProvider cart, int locationId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Colors.grey[100],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Rp ${cart.totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: cart.items.isEmpty || _isCheckingOut
                ? null
                : () async {
              final paymentInfo = await showDialog(
                context: context,
                builder: (_) => PaymentDialog(total: cart.totalAmount),
              );

              if (paymentInfo == null) return;

              setState(() => _isCheckingOut = true);

              try {
                await Provider.of<SalesService>(context, listen: false).checkout(
                  invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
                  locationId: locationId,
                  method: paymentInfo["method"],
                  paymentCode: paymentInfo["code"],
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Transaksi berhasil!")),
                );

                cart.clearCart();
              }
              catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Error: $e"),
                  ),
                );
              }
              finally {
                setState(() => _isCheckingOut = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size.fromHeight(55),
            ),
            child: _isCheckingOut
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Payment", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
