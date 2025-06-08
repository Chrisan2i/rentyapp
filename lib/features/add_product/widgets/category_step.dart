import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryStep extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryStep({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Choose Category',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the category that best describes your item',
          style: TextStyle(color: Color(0xFF999999), fontSize: 14),
        ),
        const SizedBox(height: 24),

        // Firestore categorías
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .where('isActive', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final docs = snapshot.data?.docs ?? [];

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final slug = data['slug'] ?? '';
                final name = data['name'] ?? '';
                final description = data['description'] ?? '';
                final iconUrl = data['iconUrl'] ?? '';

                final isSelected = slug == selectedCategory;

                return GestureDetector(
                  onTap: () => onCategorySelected(slug),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0085FF) : const Color(0xFF1A1A1A),
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.white10,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Image.network(iconUrl, width: 48, height: 48, fit: BoxFit.contain),
                        const SizedBox(height: 8),
                        Text(name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text(description,
                            style: const TextStyle(color: Color(0xFF999999), fontSize: 12),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
