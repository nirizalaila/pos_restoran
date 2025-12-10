import 'package:flutter/material.dart';
import 'package:pos_restoran/pages/history_screen.dart';
import 'package:pos_restoran/pages/stock_screen.dart';
import 'package:provider/provider.dart';
import '../services/AuthService.dart';
import 'pos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daily Sales Operations",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),

                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(top: 6),
                        itemCount: 3,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 22,
                          mainAxisSpacing: 22,
                          childAspectRatio: 4 / 3,
                        ),
                        itemBuilder: (context, index) {
                          final List<Map<String, dynamic>> menu = [
                            {
                              "title": "Point of Sale",
                              "subtitle":
                              "Buat transaksi penjualan harian dengan cepat.",
                              "icon": Icons.point_of_sale,
                              "color": const Color(0xFF243457),
                              "page": const PoSScreen(),
                            },
                            {
                              "title": "Riwayat",
                              "subtitle":
                              "Lihat riwayat transaksi & ringkasan penjualan.",
                              "icon": Icons.history,
                              "color": const Color(0xFFFFA726),
                              "page":
                              const HistoryScreen(),
                            },
                            {
                              "title": "Stok",
                              "subtitle":
                              "Pantau pergerakan stok bahan & menu harian.",
                              "icon": Icons.inventory_2_outlined,
                              "color": const Color(0xFF22C55E),
                              "page":
                              const StockScreen(),
                            },
                          ];

                          return _menuCard(
                            context,
                            icon: menu[index]["icon"],
                            title: menu[index]["title"],
                            subtitle: menu[index]["subtitle"],
                            page: menu[index]["page"],
                            color: menu[index]["color"],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF151C3A), Color(0xFF253A63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                "Dashboard Kasir & Inventori",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFC5CCE4),
                ),
              ),
            ],
          ),

          ElevatedButton.icon(
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.logout, size: 16, color: Colors.white),
            label: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
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
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.12),
                      color.withOpacity(0.28),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(icon, size: 26, color: color),
              ),
              const SizedBox(height: 14),

              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Buka",
                    style: TextStyle(
                      color: Color(0xFF4F46E5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios,
                      size: 12, color: Color(0xFF4F46E5)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
