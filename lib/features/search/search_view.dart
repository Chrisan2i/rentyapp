// lib/features/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <<<--- 1. Importa Provider
import 'package:rentyapp/core/controllers/controller.dart'; // <<<--- 2. Importa tu AppController
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'search_list_section.dart'; // Asegúrate que las rutas a tus widgets sean correctas
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

  // <<<--- 3. Lógica para aplicar el filtro inicial al construir la pantalla ---<<<
  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para asegurar que el 'context' esté disponible
    // y para ejecutar este código solo una vez después de que el widget se construya.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Obtenemos una referencia al AppController
      final appController = context.read<AppController>();

      // Leemos el filtro inicial que pudo haber sido establecido
      final initialFilter = appController.initialSearchFilter;

      // Si existe un filtro inicial, lo aplicamos al estado local
      if (initialFilter != null) {
        setState(() {
          _activeFilters = initialFilter;
        });

        // ¡MUY IMPORTANTE! Limpiamos el filtro en el controlador para que no se
        // aplique de nuevo si el usuario sale y vuelve a esta pantalla.
        appController.clearInitialSearchFilter();
      }
    });
  }


  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
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
                padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
                child: Text(
                  'Buscar',
                  style: AppTextStyles.headline,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SearchAndFilterHeader(
                  onSearchChanged: _onSearchChanged,
                  onFilterTapped: _showFilterSheet,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
            ProductListSection(
              searchQuery: _searchQuery,
              filters: _activeFilters,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
          ],
        ),
      ),
    );
  }
}