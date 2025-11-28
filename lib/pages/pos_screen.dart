import 'package:flutter/material.dart';
import 'package:pos_restoran/models/Product.dart';
import 'package:provider/provider.dart';

import '../providers/CartProvider.dart';
import '../services/ProductService.dart';
import '../services/SalesService.dart';
import '../services/AuthService.dart';

class PoSScreen extends StatelessWidget {
  const PoSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductService>(context, listen: false).fetchProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventara F&B PoS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Row(
        children: const [
          Flexible(flex: 3, child: MenuPanel()),
          Flexible(flex: 2, child: CartPanel()),
        ],
      ),
    );
  }
}

class CartPanel extends StatefulWidget {
  // <-- UBAH KE STATEFUL
  const CartPanel({super.key});

  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
  bool _isCheckingOut = false; // State untuk loading button

  @override
  Widget build(BuildContext context) {
    // Dapatkan Location ID dari User yang login (dipastikan ada dari AuthChecker)
    final user = Provider.of<AuthService>(context).currentUser;
    final locationId = user?.id ?? 1; // Default ke ID 1 jika null

    return Column(
      children: [
        // ... (Header Keranjang) ...

        // Daftar Item di Keranjang (Dikutip dari kode Anda sebelumnya)
        Expanded(
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) {
                return const Center(child: Text('Keranjang kosong.'));
              }
              return ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return ListTile(
                    // ... (Tampilan List Item dan tombol +/-)
                    subtitle: Text('Rp ${item.subtotal.toStringAsFixed(0)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Minus
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 24,
                            color: Colors.red,
                          ),
                          onPressed: _isCheckingOut
                              ? null
                              : () => cart.updateQuantity(
                                  item,
                                  item.quantity - 1,
                                ),
                        ),
                        Text(
                          'x${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Tombol Plus
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            size: 24,
                            color: Colors.green,
                          ),
                          onPressed: _isCheckingOut
                              ? null
                              : () => cart.updateQuantity(
                                  item,
                                  item.quantity + 1,
                                ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Bagian Total dan Checkout
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
            color: Colors.grey[50],
          ),
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              final salesService = Provider.of<SalesService>(
                context,
                listen: false,
              );

              return Column(
                children: [
                  // ... (Row Total) ...
                  const SizedBox(height: 15),
                  ElevatedButton(
                    // Tombol dinonaktifkan jika keranjang kosong ATAU sedang loading
                    onPressed: cart.items.isEmpty || _isCheckingOut
                        ? null
                        : () async {
                            setState(
                              () => _isCheckingOut = true,
                            ); // Mulai Loading
                            try {
                              await salesService.checkout(
                                invoiceNumber: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                locationId: locationId,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Transaksi Sukses! Stok telah dipotong.',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceFirst(
                                      'Exception: ',
                                      'Error Transaksi: ',
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              setState(
                                () => _isCheckingOut = false,
                              ); // Hentikan Loading
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.green,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: _isCheckingOut
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'PROSES CHECKOUT',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class MenuPanel extends StatelessWidget {
  const MenuPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductService>(
      builder: (context, productService, child) {
        if (productService.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productService.products.isEmpty) {
          return const Center(
            child: Text('Menu kosong. Tambahkan produk di Admin Web.'),
          );
        }

        final cartProvider = Provider.of<CartProvider>(context, listen: false);

        return Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: productService.products.length,
            itemBuilder: (context, index) {
              final product = productService.products[index];
              return MenuItemButton(
                product: product,
                onTap: () => cartProvider.addItem(product),
              );
            },
          ),
        );
      },
    );
  }
}

class MenuItemButton extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const MenuItemButton({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${product.salePrice.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
