// lib/features/landing/widgets/popular_categories.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart'; // <<<--- Importa tu controlador de navegación
import 'package:rentyapp/features/category/models/category_model.dart';
import 'package:rentyapp/features/category/service/category_service.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/search/search_view.dart';

class PopularCategories extends StatelessWidget {
  const PopularCategories({super.key});

  IconData _getIconForCategory(String slug) {
    switch (slug) {
      case 'gadgets-electronics':
        return Icons.camera_alt_outlined;
      case 'home-garden':
        return Icons.chair_outlined;
      case 'outdoor-camping':
        return Icons.terrain_outlined;
      case 'sports-fitness':
        return Icons.fitness_center_outlined;
      case 'tools-equipment':
        return Icons.build_outlined; // Cambiado a un ícono más apropiado
      default:
        return Icons.category_outlined;
    }
  }

  // <<<--- NUEVA FUNCIÓN PARA LA NAVEGACIÓN ---<<<
  void _navigateToCategorySearch(BuildContext context, Category category) {
    // 1. Obtenemos el controlador de navegación
    final appController = context.read<AppController>();

    // 2. Cambiamos el índice para mostrar la SearchScreen
    appController.setSelectedIndex(1);

    // 3. Pasamos el filtro de categoría a la SearchScreen
    // Para hacer esto, necesitamos modificar SearchScreen para aceptar un filtro inicial.
    // (Ver el paso 4 más abajo)
    appController.setInitialSearchFilter({'category': category.slug});
  }

  @override
  Widget build(BuildContext context) {
    final CategoryService categoryService = CategoryService();

    return FutureBuilder<List<Category>>(
      future: categoryService.getActiveCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: AppColors.primary)));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(child: Center(child: Text('No se pudieron cargar las categorías.')));
        }

        final categories = snapshot.data!;

        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell( // <<<--- Envolvemos en InkWell para hacerlo tappable
              onTap: () => _navigateToCategorySearch(context, category),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForCategory(category.slug),
                      size: 28,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: AppTextStyles.quickAccessLabel,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}