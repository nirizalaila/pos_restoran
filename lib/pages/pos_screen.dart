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
        title: const Text(
          "Inventara F&B PoS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF334B76),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
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
