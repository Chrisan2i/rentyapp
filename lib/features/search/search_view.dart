import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'search_list_section.dart';
import 'search_and_filter_header.dart';
import 'filter_options_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FilterOptionsSheet(
          initialFilters: _activeFilters,
          onApplyFilters: (newFilters) {
            setState(() {
              _activeFilters = newFilters;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                // Ajusta el padding según tu diseño. Un poco de espacio vertical arriba es bueno.
                padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32, // Tamaño grande para que sea un título prominente
                    fontWeight: FontWeight.bold, // Fuente en negrita para destacar
                    fontFamily: 'YourAppFont', // Opcional: Reemplaza con tu fuente personalizada
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                // Se reduce el padding superior de este widget porque el título ya lo proporciona
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SearchAndFilterHeader(
                  onSearchChanged: _onSearchChanged,
                  onFilterTapped: _showFilterSheet,
                ),
              ),
            ),


            const SliverToBoxAdapter(
              child: SizedBox(height: 24.0),
            ),


            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ProductListSection(
                  searchQuery: _searchQuery,
                  filters: _activeFilters,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}