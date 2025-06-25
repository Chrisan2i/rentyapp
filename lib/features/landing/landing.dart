// lib/features/landing/landing_page.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/landing/widgets/bottom_cta_banner.dart';
import 'package:rentyapp/features/landing/widgets/explore_button.dart';
import 'package:rentyapp/features/landing/widgets/header_logo_and_notification.dart';
import 'package:rentyapp/features/landing/widgets/headline_texts.dart';
import 'package:rentyapp/features/landing/widgets/popular_categories.dart'; // <<<--- Usamos el widget mejorado
import 'package:rentyapp/features/landing/widgets/statistics_row.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // O tu AppColors.background
      // MEJORA: Usamos CustomScrollView con Slivers. Es más flexible y performante.
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(height: 60),
                  HeaderLogoAndNotification(),
                  SizedBox(height: 40),
                  HeadlineTexts(), // Widget externo
                  SizedBox(height: 20),
                  Text(
                    'La confianza de miles para alquilar herramientas, gadgets y más.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle,
                  ),
                  SizedBox(height: 30),
                  ExploreButton(), // Widget externo
                  SizedBox(height: 40),
                  StatisticsRow(), // Widget externo
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // SliverPadding para añadir padding a los slivers que siguen.
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Explora por Categoría', style: AppTextStyles.sectionTitle),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // MEJORA: Usamos un Padding dentro del Sliver para que el Grid no ocupe toda la pantalla
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: PopularCategories(), // <<<--- Usamos el nuevo widget de Grid
          ),
          // El banner final
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 100),
              child: BottomCtaBanner(), // Widget externo
            ),
          ),
        ],
      ),
    );
  }
}