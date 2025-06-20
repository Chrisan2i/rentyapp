// ARCHIVO: lib/features/profile/profile_view.dart

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
    // Usamos 'watch' para que la UI se reconstruya cuando cambie el estado del controlador.
    final controller = context.watch<AppController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      // MEJORA: Se usa CustomScrollView para una experiencia de scroll más rica.
      // Permite que la barra superior se comporte de forma más dinámica.
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, AppController controller) {
    switch (controller.userState) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      case ViewState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text("Error loading profile.", style: TextStyle(color: Colors.red, fontSize: 16)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => controller.fetchCurrentUser(),
                child: const Text("Try Again"),
              )
            ],
          ),
        );
      case ViewState.idle:
        final user = controller.currentUser;
        if (user == null) {
          return const Center(child: Text("User not found. Please log in again."));
        }

        // Si todo está bien, mostramos el contenido del perfil.
        // MEJORA: Se usa CustomScrollView para un layout más profesional.
        return CustomScrollView(
          slivers: [
            // La barra superior ahora es un SliverAppBar.
            // Se puede configurar para que flote o se fije al hacer scroll.
            const SliverAppBar(
              backgroundColor: AppColors.background,
              pinned: true, // Se mantiene visible en la parte superior
              automaticallyImplyLeading: false, // Oculta el botón de "atrás"
              title: ProfileHeaderBar(),
              centerTitle: false,
              titleSpacing: 24,
            ),

            // El contenido principal del perfil va dentro de un SliverList
            // para un mejor rendimiento y efectos de scroll.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    ProfileHeader(user: user),
                    const SizedBox(height: 24),

                    // NUEVO WIDGET: Destacando la billetera del usuario.
                    WalletSummaryCard(wallet: user.wallet),
                    const SizedBox(height: 24),

                    // WIDGET MEJORADO: Ahora muestra estadísticas clave.
                    UserStatsGrid(user: user),
                    const SizedBox(height: 32),

                    // NUEVO WIDGET: Para acciones y accesos directos.
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

                    // WIDGET MEJORADO: La antigua sección de detalles, ahora más completa.
                    AccountInfoSection(user: user),
                    const SizedBox(height: 60), // Espacio al final del scroll
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }
}