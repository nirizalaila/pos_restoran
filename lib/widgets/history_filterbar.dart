import 'package:flutter/material.dart';

class HistoryFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;

  const HistoryFilterBar({
    super.key,
    required this.searchController,
    required this.startDate,
    required this.endDate,
    required this.onSearchChanged,
    required this.onStartDateTap,
    required this.onEndDateTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: "Cari berdasarkan Invoice...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(
                child: _dateButton(
                  label: "Dari",
                  date: startDate,
                  onTap: onStartDateTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dateButton(
                  label: "Sampai",
                  date: endDate,
                  onTap: onEndDateTap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label: ${_formatDate(date)}",
              style: const TextStyle(fontSize: 12),
            ),
            const Icon(Icons.calendar_month, size: 18),
          ],
        ),
      ),
    );
  }
}
