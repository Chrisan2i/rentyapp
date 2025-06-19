// ARCHIVO: lib/features/profile/profile_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/features/profile/widgets/profile_header.dart';
import 'package:rentyapp/features/profile/widgets/profile_info_cards.dart';
import 'package:rentyapp/features/profile/widgets/profile_details.dart' as details;
import 'package:rentyapp/features/profile/widgets/profile_header_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // <<<--- CORRECCIÓN: Se usa AppController en lugar de Controller ---<<<
    final controller = Provider.of<AppController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      // <<<--- MEJORA: Manejo de estados de carga para una UI robusta ---<<<
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, AppController controller) {
    // Usamos el estado de carga del controlador para decidir qué mostrar
    switch (controller.userState) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      case ViewState.error:
        return const Center(child: Text("Error al cargar el perfil.", style: TextStyle(color: Colors.red)));
      case ViewState.idle:
        final user = controller.currentUser;
        // Aunque esté 'idle', es buena práctica verificar si el usuario es nulo.
        if (user == null) {
          return const Center(child: Text("No se encontró información del usuario."));
        }
        // Si todo está bien, mostramos el contenido del perfil.
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const ProfileHeaderBar(), // Este widget ahora se actualiza solo
              const SizedBox(height: 30),
              ProfileHeader(user: user),
              const SizedBox(height: 24),

              // Usamos un StreamBuilder para escuchar el conteo de solicitudes
              StreamBuilder<int>(
                stream: controller.pendingRequestsCountStream,
                initialData: 0,
                builder: (context, snapshot) {
                  final requestsCount = snapshot.data ?? 0;
                  // Pasamos el conteo actualizado y el usuario a las tarjetas
                  return ProfileInfoCards(user: user, pendingRequestsCount: requestsCount);
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