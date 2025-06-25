// lib/features/add_product/widgets/category_step.dart
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
          'Choose a Category',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the category that best describes your item.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF999999), fontSize: 14),
        ),
        const SizedBox(height: 24),

        // Fetch categories from Firestore
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .where('isActive', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text(
                'No categories found.',
                style: TextStyle(color: Colors.white70),
              );
            }

            final docs = snapshot.data!.docs;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final slug = data['slug'] as String? ?? '';
                final name = data['name'] as String? ?? 'No Name';
                final description = data['description'] as String? ?? '';
                final iconUrl = data['iconUrl'] as String? ?? '';

                final isSelected = slug == selectedCategory;

                return GestureDetector(
                  onTap: () => onCategorySelected(slug),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0085FF) : const Color(0xFF1A1A1A),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF0085FF) : Colors.white.withOpacity(0.1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        if (iconUrl.isNotEmpty)
                          Image.network(iconUrl, width: 48, height: 48, fit: BoxFit.contain)
                        else
                          const SizedBox(height: 48), // Placeholder if no icon
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: isSelected ? Colors.white.withOpacity(0.9) : const Color(0xFF999999),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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