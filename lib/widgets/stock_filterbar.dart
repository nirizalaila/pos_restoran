import 'package:flutter/material.dart';

class StockFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> locations;
  final String? selectedLocation;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onLocationChanged;

  const StockFilterBar({
    super.key,
    required this.searchController,
    required this.locations,
    required this.selectedLocation,
    required this.onSearchChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: "Cari produk atau SKU...",
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedLocation,
                      hint: const Text(
                        "Semua Lokasi",
                        style: TextStyle(fontSize: 13),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text(
                            "Semua Lokasi",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        ...locations.map(
                              (loc) => DropdownMenuItem(
                            value: loc,
                            child: Text(
                              loc,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                      onChanged: onLocationChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
