import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/menu_panel.dart';
import '../widgets/cart_panel.dart';
import '../services/ProductService.dart';

class PoSScreen extends StatelessWidget {
  const PoSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductService>(context, listen: false).fetchProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: Column(
        children: [
          _buildFancyAppBar(context),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1400),
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Flexible(flex: 2, child: CartPanel()),
                    SizedBox(width: 14),
                    Flexible(flex: 3, child: MenuPanel()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFancyAppBar(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF151C3A), Color(0xFF253A63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(26),
        ),
      ),

      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 22),
            tooltip: "Kembali",
          ),
          const SizedBox(width: 4),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Inventara F&B PoS",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Daily Grocery & Beverage Checkout",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFC5CCE4),
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.print_outlined,
                    color: Colors.white, size: 24),
                tooltip: "Print receipt",
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.history,
                    color: Colors.white, size: 24),
                tooltip: "Riwayat",
              ),
              const SizedBox(width: 14),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,
                          size: 18, color: Colors.black87),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Kasir 1",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
