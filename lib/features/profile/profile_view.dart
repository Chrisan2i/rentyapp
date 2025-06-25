// lib/features/profile/profile_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/profile/widgets/account_info_section.dart';
import 'package:rentyapp/features/profile/widgets/profile_actions_section.dart';
import 'package:rentyapp/features/profile/widgets/profile_header.dart';
import 'package:rentyapp/features/profile/widgets/profile_header_bar.dart';
import 'package:rentyapp/features/profile/widgets/user_stats_grid.dart';
import 'package:rentyapp/features/profile/widgets/wallet_summary_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, AppController controller) {
    switch (controller.userState) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      case ViewState.error:
      // ✨ MEJORA: Estado de error más amigable e interactivo.
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text("Error al cargar el perfil.", style: TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                const Text("Por favor, verifica tu conexión a internet.", style: TextStyle(color: AppColors.white70), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => controller.fetchCurrentUser(),
                  label: const Text("Intentar de nuevo"),
                )
              ],
            ),
          ),
        );
      case ViewState.idle:
        final user = controller.currentUser;
        if (user == null) {
          // ✨ MEJORA: Mensaje más claro
          return const Center(child: Text("Usuario no encontrado.\nPor favor, inicia sesión de nuevo.", textAlign: TextAlign.center,));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchCurrentUser(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                // ✨ MEJORA: Pinned y Floating para una mejor experiencia de scroll.
                pinned: true,
                floating: true,
                automaticallyImplyLeading: false,
                title: const ProfileHeaderBar(),
                centerTitle: false,
                titleSpacing: 0, // El padding ya está en el widget
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      ProfileHeader(user: user),
                      const SizedBox(height: 24),
                      WalletSummaryCard(wallet: user.wallet),
                      const SizedBox(height: 24),
                      UserStatsGrid(user: user),
                      const SizedBox(height: 32),
                      StreamBuilder<int>(
                        stream: controller.pendingRequestsCountStream,
                        initialData: 0,
                        builder: (context, snapshot) {
                          return ProfileActionsSection(
                            pendingRequestsCount: snapshot.data ?? 0,
                            isVerified: user.verificationStatus != VerificationStatus.notVerified,
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      AccountInfoSection(user: user),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}