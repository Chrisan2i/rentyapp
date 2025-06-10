import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Center(child: Text('Search for products...')),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
    );
  }
}
