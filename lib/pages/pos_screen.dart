import 'package:flutter/material.dart';
import '../widgets/menu_panel.dart';
import '../widgets/cart_panel.dart';
import '../services/ProductService.dart';
import 'package:provider/provider.dart';
import '../services/AuthService.dart';

class PoSScreen extends StatelessWidget {
  const PoSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductService>(context, listen: false).fetchProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventara F&B PoS", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),

      body: const Row(
        children: [
          Flexible(flex: 3, child: MenuPanel()),
          Flexible(flex: 2, child: CartPanel()),
        ],
      ),
    );
  }
}
