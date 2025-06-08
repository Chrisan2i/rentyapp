import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/landing/controllers/controller.dart';
import 'package:rentyapp/features/landing/widgets/bottom_cta_banner.dart';
import 'package:rentyapp/core/widgets/custom_bottom_navbar.dart';
import 'package:rentyapp/features/landing/widgets/header_logo_and_notification.dart';
import 'package:rentyapp/features/landing/widgets/headline_texts.dart';
import 'package:rentyapp/features/landing/widgets/popular_categories.dart';
import 'package:rentyapp/features/landing/widgets/quick_access_row.dart';
import 'package:rentyapp/features/landing/widgets/statistics_row.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<Controller>();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 60),
          const HeaderLogoAndNotification(),
          const SizedBox(height: 40),
          const HeadlineTexts(),
          const SizedBox(height: 20),
          const Text(
            'Trusted by thousands to rent tools, gadgets, and more.',
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.read<Controller>().onExplorePressed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Center(
              child: Text('Start Exploring', style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: 30),
          const StatisticsRow(),
          const SizedBox(height: 30),
          const Text('Quick Access', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 16),
          const QuickAccessRow(),
          const SizedBox(height: 30),
          const Text('Popular Categories', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 16),
          const PopularCategories(),
          const SizedBox(height: 30),
          const BottomCtaBanner(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

