import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/SalesService.dart';
import '../widgets/history_filterbar.dart';
import '../widgets/history_list_item.dart';
import '../dialogs/history_detail_dialog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _futureHistory;

  List<Map<String, dynamic>> _allSales = [];
  List<Map<String, dynamic>> _filteredSales = [];

  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _futureHistory =
        Provider.of<SalesService>(context, listen: false).fetchSalesHistory()
            .then((data) {
          _allSales = data;
          _filteredSales = List.from(data);
          return data;
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

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final s = value.toString();
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  String _formatDateTime(dynamic value) {
    final dt = _parseDate(value);
    if (dt == null) return value?.toString() ?? "-";
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  void _applyFilters() {
    final keyword = _searchController.text.trim().toLowerCase();

    List<Map<String, dynamic>> result = _allSales.where((sale) {
      final invoice =
          sale['invoice_number']?.toString().toLowerCase() ?? "";
      final matchSearch = invoice.contains(keyword);

      final saleDate = _parseDate(sale['created_at']);

      if (saleDate != null) {
        if (_startDate != null &&
            saleDate.isBefore(
              DateTime(_startDate!.year, _startDate!.month, _startDate!.day),
            )) {
          return false;
        }

        if (_endDate != null &&
            saleDate.isAfter(
              DateTime(
                _endDate!.year,
                _endDate!.month,
                _endDate!.day,
                23,
                59,
                59,
              ),
            )) {
          return false;
        }
      }

      return matchSearch;
    }).toList();

    setState(() {
      _filteredSales = result;
    });
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _startDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
      _applyFilters();
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _endDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: Column(
        children: [
          _buildHeader(context),

          HistoryFilterBar(
            searchController: _searchController,
            startDate: _startDate,
            endDate: _endDate,
            onSearchChanged: (_) => _applyFilters(),
            onStartDateTap: _pickStartDate,
            onEndDateTap: _pickEndDate,
          ),

          const SizedBox(height: 10),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureHistory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Gagal memuat riwayat:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (_filteredSales.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada transaksi ditemukan.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 10),
                  itemCount: _filteredSales.length,
                  itemBuilder: (context, index) {
                    final sale = _filteredSales[index];

                    final invoice = sale['invoice_number']?.toString() ?? '-';
                    final total = _toDouble(sale['total_amount']);
                    final createdAt = sale['created_at']?.toString() ?? '';
                    final userName =
                        sale['user']?['name']?.toString() ?? 'Kasir';
                    final items = (sale['items'] as List<dynamic>? ?? []);
                    final itemCount = items.length;
                    final formattedDate = _formatDateTime(createdAt);

                    return HistoryListItem(
                      invoice: invoice,
                      userName: userName,
                      itemCount: itemCount,
                      total: total,
                      dateText: formattedDate,
                      onTap: () => _showDetailDialog(sale),
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
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 4),
          const Text(
            "Riwayat Transaksi",
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

  void _showDetailDialog(Map<String, dynamic> sale) {
    showDialog(
      context: context,
      builder: (_) => HistoryDetailDialog(sale: sale),
    );
  }
}
