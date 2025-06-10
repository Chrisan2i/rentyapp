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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 45),
            const SearchHeader(), // Search Header (Title and filter bar)
            const SizedBox(height: 2),
            const SearchFilter(), // Search Filter Section
            const SizedBox(height: 10),
            const ProductListSection(), // Product List Section
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
