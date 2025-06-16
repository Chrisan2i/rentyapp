// lib/features/search/widgets/filter_options_sheet.dart

import 'package:flutter/material.dart';

class FilterOptionsSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterOptionsSheet({
    super.key,
    required this.initialFilters,
    required this.onApplyFilters,
  });

  @override
  _FilterOptionsSheetState createState() => _FilterOptionsSheetState();
}

class _FilterOptionsSheetState extends State<FilterOptionsSheet> {
  late String? _sortBy;

  @override
  void initState() {
    super.initState();
    _sortBy = widget.initialFilters['sortBy'];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort by',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSortOption('Relevance', null),
          _buildSortOption('Price: Low to High', 'price_asc'),
          _buildSortOption('Price: High to Low', 'price_desc'),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // Aplicar los filtros seleccionados
              widget.onApplyFilters({'sortBy': _sortBy});
            },
            child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSortOption(String title, String? value) {
    final bool isSelected = _sortBy == value;
    return RadioListTile<String?>(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: _sortBy,
      onChanged: (newValue) {
        setState(() {
          _sortBy = newValue;
        });
      },
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}