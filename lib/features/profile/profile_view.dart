import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

import 'package:rentyapp/core/widgets/custom_bottom_navbar.dart';
import 'package:rentyapp/features/profile/widgets/profile_header.dart';
import 'package:rentyapp/features/profile/widgets/profile_info_cards.dart';

import 'package:rentyapp/features/profile/widgets/profile_details.dart' as details;

import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/features/profile/widgets/profile_header_bar.dart'; // 👈 añade esta línea

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final user = controller.currentUser;

    if (controller.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text("No user data found", style: AppTextStyles.subtitle),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const ProfileHeaderBar(), // 👈 aquí lo insertamos
            const SizedBox(height: 30),
            ProfileHeader(user: user),
            const SizedBox(height: 24),
            ProfileInfoCards(user: user),
            const SizedBox(height: 32),
            details.ProfileDetails(user: user),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}