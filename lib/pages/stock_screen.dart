import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/StockService.dart';
import '../widgets/stock_filterbar.dart';
import '../widgets/stock_list_item.dart';
import '../dialogs/stock_detail_dialog.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  late Future<List<Map<String, dynamic>>> _futureStock;

  List<Map<String, dynamic>> _allRows = [];
  List<Map<String, dynamic>> _filteredRows = [];

  final TextEditingController _searchController = TextEditingController();
  String? _selectedLocation;
  List<String> _locations = [];

  @override
  void initState() {
    super.initState();
    _futureStock =
        Provider.of<StockService>(context, listen: false).fetchStockSummary()
            .then((rows) {
          _allRows = rows;
          _filteredRows = List.from(rows);
          _extractLocations(rows);
          return rows;
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  void _extractLocations(List<Map<String, dynamic>> rows) {
    final set = <String>{};
    for (final row in rows) {
      final loc = row['location_name']?.toString() ??
          row['location']?['name']?.toString();
      if (loc != null && loc.isNotEmpty) {
        set.add(loc);
      }
    }
    _locations = set.toList()..sort();
  }

  String _extractProductName(Map<String, dynamic> row) {
    return row['product_name']?.toString() ??
        row['product']?['name']?.toString() ??
        row['name']?.toString() ??
        '-';
  }

  String? _extractSku(Map<String, dynamic> row) {
    return row['sku']?.toString() ?? row['product']?['sku']?.toString();
  }

  String? _extractLocationName(Map<String, dynamic> row) {
    return row['location_name']?.toString() ??
        row['location']?['name']?.toString();
  }

  String? _extractUnitName(Map<String, dynamic> row) {
    return row['unit_name']?.toString() ??
        row['unit']?['name']?.toString();
  }

  double _extractQty(Map<String, dynamic> row) {
    return _toDouble(
      row['quantity'] ??
          row['stock'] ??
          row['on_hand'] ??
          row['qty'],
    );
  }

  double? _extractMinStock(Map<String, dynamic> row) {
    if (row['stock_minimum'] == null) return null;
    return _toDouble(row['stock_minimum']);
  }

  void _applyFilters() {
    final keyword = _searchController.text.trim().toLowerCase();
    final selectedLoc = _selectedLocation;

    List<Map<String, dynamic>> result = _allRows.where((row) {
      final productName = _extractProductName(row).toLowerCase();
      final sku = _extractSku(row)?.toLowerCase() ?? '';

      final matchSearch =
          productName.contains(keyword) || sku.contains(keyword);

      if (selectedLoc != null) {
        final loc = _extractLocationName(row);
        if (loc == null || loc != selectedLoc) {
          return false;
        }
      }

      return matchSearch;
    }).toList();

    setState(() {
      _filteredRows = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: Column(
        children: [
          _buildHeader(context),

          StockFilterBar(
            searchController: _searchController,
            locations: _locations,
            selectedLocation: _selectedLocation,
            onSearchChanged: (_) => _applyFilters(),
            onLocationChanged: (loc) {
              setState(() {
                _selectedLocation = loc;
              });
              _applyFilters();
            },
          ),

          const SizedBox(height: 10),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureStock,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Gagal memuat stok:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (_filteredRows.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada data stok.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 10),
                  itemCount: _filteredRows.length,
                  itemBuilder: (context, index) {
                    final row = _filteredRows[index];

                    final productName = _extractProductName(row);
                    final sku = _extractSku(row);
                    final loc = _extractLocationName(row);
                    final unit = _extractUnitName(row);
                    final qty = _extractQty(row);
                    final minStock = _extractMinStock(row);

                    return StockListItem(
                      productName: productName,
                      sku: sku,
                      unitName: unit,
                      locationName: loc,
                      quantity: qty,
                      minStock: minStock,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              StockDetailDialog(stockRow: row),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF151C3A), Color(0xFF253A63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 4),
          const Text(
            "Stok Bahan & Menu",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
