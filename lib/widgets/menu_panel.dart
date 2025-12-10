import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ProductService.dart';
import '../providers/CartProvider.dart';
import '../models/Product.dart';

class MenuPanel extends StatefulWidget {
  const MenuPanel({super.key});

  @override
  State<MenuPanel> createState() => _MenuPanelState();
}

class _MenuPanelState extends State<MenuPanel> {
  String _search = '';
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 8),
        Expanded(
          child: Consumer2<ProductService, CartProvider>(
            builder: (context, productService, cart, child) {
              if (productService.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<Product> allProducts = productService.products;
              var filtered = allProducts.where((p) {
                if (_search.isNotEmpty &&
                    !p.name.toLowerCase().contains(_search)) {
                  return false;
                }
                // kalau nanti mau pisah kategori, pake _activeFilter di sini
                return true;
              }).toList();

              if (filtered.isEmpty) {
                return const Center(
                  child: Text(
                    "Produk tidak ditemukan.",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 4 / 3,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final product = filtered[index];
                  final qtyInCart = cart.items
                      .where((item) => item.product.id == product.id)
                      .fold<int>(0, (prev, item) => prev + item.quantity);

                  final bool isSelected = qtyInCart > 0;

                  return _menuTile(
                    context: context,
                    product: product,
                    qty: qtyInCart,
                    isSelected: isSelected,
                    onTap: () => cart.addItem(product),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search menu...",
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: const Color(0xFFF6F7FB),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) {
                setState(() {
                  _search = v.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(width: 12),

          GestureDetector(
            onTap: () => setState(() => _activeFilter = 'all'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF243457),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF243457).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: const Text(
                "All Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required BuildContext context,
    required Product product,
    required int qty,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color baseColor = isSelected
        ? const Color(0xFF243457)
        : const Color(0xFFF9FAFF);

    final Color accentColor =
    isSelected ? Colors.white : const Color(0xFF243457);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.18 : 0.08),
              blurRadius: isSelected ? 12 : 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.12)
                        : const Color(0xFFE9F8ED),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "Rp ${product.salePrice.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1F7A3F),
                    ),
                  ),
                ),
                if (qty > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      "x$qty",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF243457),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
