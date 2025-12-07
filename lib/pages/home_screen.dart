import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/AuthService.dart';

// Screen
import 'pos_screen.dart';
//import 'history_screen.dart';
//import 'stock_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f4f6),

      appBar: AppBar(
        backgroundColor: const Color(0xFF334B76),
        elevation: 0,
        title: const Text(
          "Inventara F&B PoS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffdc2626),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.logout, size: 16, color: Colors.white),
              label: const Text("Logout",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Menu Utama",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xff1f2937),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 6),
                itemCount: 3,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final List<Map<String, dynamic>> menu = [
                    {
                      "title": "Point of Sale",
                      "icon": Icons.point_of_sale,
                      "color": const Color(0xff00008b),
                      "page": const PoSScreen(),
                    },
                    {
                      "title": "Riwayat",
                      "icon": Icons.history,
                      "color": const Color(0xfffbbf24),
                      "page": const HomeScreen(),
                    },
                    {
                      "title": "Stok",
                      "icon": Icons.inventory,
                      "color": const Color(0xff22c55e),
                      "page": const HomeScreen()
                    },
                  ];

                  return _menuCard(
                    context,
                    icon: menu[index]["icon"],
                    title: menu[index]["title"],
                    page: menu[index]["page"],
                    color: menu[index]["color"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CARD KECIL ELEGAN — gaya dashboard web
  Widget _menuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget page,
        required Color color,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffe5e7eb)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 26, color: color),
              ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  color: Color(0xff1f2937),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
