// search_view.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/widgets/custom_bottom_navbar.dart';
import 'package:rentyapp/features/search/search_list_section.dart';
import 'search_header.dart';
import 'search_filter.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        // Reduced horizontal padding to allow cards to be wider
        padding: const EdgeInsets.symmetric(horizontal: 16), //
        child: Column(
          children: [
            const SizedBox(height: 40),
            const SearchHeader(), // Search Header (Title and filter bar)
            const SearchFilter(), // Search Filter Section
            const ProductListSection(), // Product List Section
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}