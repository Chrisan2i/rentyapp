// lib/features/landing/landing_page.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/landing/widgets/bottom_cta_banner.dart';
import 'package:rentyapp/features/landing/widgets/explore_button.dart'; // <<<--- Usamos el widget corregido
import 'package:rentyapp/features/landing/widgets/header_logo_and_notification.dart';
import 'package:rentyapp/features/landing/widgets/headline_texts.dart';
import 'package:rentyapp/features/landing/widgets/popular_categories.dart';
import 'package:rentyapp/features/landing/widgets/quick_access_row.dart';
import 'package:rentyapp/features/landing/widgets/statistics_row.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTA: Ya no necesitamos instanciar el controlador aquí si no lo usamos directamente.
    // Los widgets hijos como HeaderLogoAndNotification lo obtendrán por su cuenta.

    return Scaffold(
      // Se usa Scaffold para tener un color de fondo por defecto y estructura.
      backgroundColor: Colors.black, // O tu color de fondo de AppColors
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: const [ // Usamos const porque los widgets hijos son constantes
          SizedBox(height: 60),
          HeaderLogoAndNotification(),
          SizedBox(height: 40),
          HeadlineTexts(),
          SizedBox(height: 20),
          Text(
            'Trusted by thousands to rent tools, gadgets, and more.',
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle,
          ),
          SizedBox(height: 30),
          ExploreButton(), // <<<--- Usamos nuestro widget refactorizado
          SizedBox(height: 30),
          StatisticsRow(),
          SizedBox(height: 30),
          Text('Quick Access', style: AppTextStyles.sectionTitle),
          SizedBox(height: 16),
          QuickAccessRow(),
          SizedBox(height: 30),
          Text('Popular Categories', style: AppTextStyles.sectionTitle),
          SizedBox(height: 16),
          PopularCategories(),
          SizedBox(height: 30),
          BottomCtaBanner(),
          SizedBox(height: 100), // Espacio para que el contenido no quede pegado al BottomNavBar
        ],
      ),
    );
  }
}