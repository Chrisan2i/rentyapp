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

// En lib/features/profile/profile_view.dart

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final user = controller.currentUser;

    // ... (tu código de isLoading y user == null)

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const ProfileHeaderBar(),
            const SizedBox(height: 30),
            ProfileHeader(user: user!), // Sabemos que user no es null aquí
            const SizedBox(height: 24),

            // --- MODIFICACIÓN AQUÍ ---
            // Usamos un StreamBuilder para escuchar el conteo de solicitudes
            StreamBuilder<int>(
              stream: controller.pendingRequestsCountStream,
              initialData: 0, // Muestra 0 mientras carga el stream
              builder: (context, snapshot) {
                // Obtenemos el conteo del snapshot, o 0 si hay un error o no ha llegado.
                final requestsCount = snapshot.data ?? 0;

                // Pasamos el conteo actualizado al widget de tarjetas
                return ProfileInfoCards(user: user, pendingRequestsCount: requestsCount);
              },
            ),
            // --- FIN DE LA MODIFICACIÓN ---

            const SizedBox(height: 32),
            details.ProfileDetails(user: user),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}