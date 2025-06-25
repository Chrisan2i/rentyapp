// lib/features/search/widgets/filter_options_sheet.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/category/models/category_model.dart';
import 'package:rentyapp/features/category/service/category_service.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

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
  // Estados para cada filtro
  String? _sortBy;
  String? _selectedCategory;
  RangeValues? _priceRange;

  @override
  void initState() {
    super.initState();
    // Inicializamos los estados con los filtros activos
    _sortBy = widget.initialFilters['sortBy'];
    _selectedCategory = widget.initialFilters['category'];
    if (widget.initialFilters['minPrice'] != null && widget.initialFilters['maxPrice'] != null) {
      _priceRange = RangeValues(
        widget.initialFilters['minPrice'].toDouble(),
        widget.initialFilters['maxPrice'].toDouble(),
      );
    }
  }

  void _applyFilters() {
    final newFilters = {
      'sortBy': _sortBy,
      'category': _selectedCategory,
      'minPrice': _priceRange?.start,
      'maxPrice': _priceRange?.end,
    };
    // Quitamos los valores nulos antes de aplicar
    newFilters.removeWhere((key, value) => value == null);
    widget.onApplyFilters(newFilters);
  }

  void _clearFilters() {
    setState(() {
      _sortBy = null;
      _selectedCategory = null;
      _priceRange = null;
    });
    widget.onApplyFilters({}); // Aplicamos un mapa vacío para limpiar
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0).copyWith(bottom: 40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Filtros", onClear: _clearFilters),
            const SizedBox(height: 24),

            _buildSectionTitle('Ordenar por'),
            _buildSortOption('Relevancia', null),
            _buildSortOption('Precio: Menor a Mayor', 'price_asc'),
            _buildSortOption('Precio: Mayor a Menor', 'price_desc'),

            const Divider(color: AppColors.white10, height: 48),

            _buildSectionTitle('Categoría'),
            _buildCategoryFilter(),

            const Divider(color: AppColors.white10, height: 48),

            _buildSectionTitle('Rango de Precio (por día)'),
            _buildPriceRangeSlider(),

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _applyFilters,
              child: const Text('Aplicar Filtros', style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, {VoidCallback? onClear}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        if (onClear != null)
          TextButton(
            onPressed: onClear,
            child: const Text('Limpiar Todo', style: TextStyle(color: AppColors.primary)),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600));
  }

  Widget _buildSortOption(String title, String? value) {
    final bool isSelected = _sortBy == value;
    return RadioListTile<String?>(
      title: Text(title, style: TextStyle(color: isSelected ? AppColors.white : AppColors.white70)),
      value: value,
      groupValue: _sortBy,
      onChanged: (newValue) => setState(() => _sortBy = newValue),
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildCategoryFilter() {
    return FutureBuilder<List<Category>>(
      future: CategoryService().getActiveCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final categories = snapshot.data!;
        return Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: categories.map((category) {
            final isSelected = _selectedCategory == category.slug;
            return ChoiceChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category.slug : null;
                });
              },
              backgroundColor: AppColors.white10,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.white70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange ?? const RangeValues(0, 500), // Rango por defecto
          min: 0,
          max: 500, // Puedes ajustar este valor máximo
          divisions: 20,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.white10,
          labels: RangeLabels(
            '\$${(_priceRange?.start ?? 0).round()}',
            '\$${(_priceRange?.end ?? 500).round()}',
          ),
          onChanged: (values) => setState(() => _priceRange = values),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$0', style: TextStyle(color: AppColors.white70)),
            Text('\$500+', style: TextStyle(color: AppColors.white70)),
          ],
        ),
      ],
    );
  }
}