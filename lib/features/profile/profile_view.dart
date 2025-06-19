// ARCHIVO: lib/features/profile/profile_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/controllers/controller.dart'; // Asegúrate que esta ruta es correcta
import 'package:rentyapp/features/profile/widgets/profile_header.dart';
import 'package:rentyapp/features/profile/widgets/profile_info_cards.dart';
import 'package:rentyapp/features/profile/widgets/profile_details.dart' as details;
import 'package:rentyapp/features/profile/widgets/profile_header_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que la UI se reconstruya cuando cambie el estado del controlador.
    final controller = context.watch<AppController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, AppController controller) {
    switch (controller.userState) {
      case ViewState.loading:
      // Muestra un esqueleto o un spinner mientras carga el perfil inicial.
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
                onPressed: () => controller.fetchCurrentUser(), // Asume que tienes un método para reintentar
                child: const Text("Try Again"),
              )
            ],
          ),
        );
      case ViewState.idle:
        final user = controller.currentUser;
        if (user == null) {
          // Este caso podría ocurrir si el usuario cierra sesión.
          return const Center(child: Text("User not found. Please log in again."));
        }

        // Si todo está bien, mostramos el contenido del perfil.
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const ProfileHeaderBar(),
              const SizedBox(height: 30),
              ProfileHeader(user: user), // Este widget ahora es robusto
              const SizedBox(height: 24),
              StreamBuilder<int>(
                stream: controller.pendingRequestsCountStream,
                initialData: 0,
                builder: (context, snapshot) {
                  return ProfileInfoCards(user: user, pendingRequestsCount: snapshot.data ?? 0);
                },
              ),
              const SizedBox(height: 32),
              details.ProfileDetails(user: user),
              const SizedBox(height: 60),
            ],
          ),
        );
    }
  }
}