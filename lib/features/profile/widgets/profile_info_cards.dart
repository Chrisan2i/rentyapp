// En lib/features/profile/widgets/profile_info_cards.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class ProfileInfoCards extends StatelessWidget {
  final UserModel user;
  final int pendingRequestsCount; // <-- Nuevo parámetro para el conteo

  const ProfileInfoCards({
    super.key,
    required this.user,
    required this.pendingRequestsCount, // <-- Requerido en el constructor
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center, // Centra las tarjetas si no llenan el espacio
      children: [
        _buildInfoCard(
          context: context,
          title: 'My Listings',
          subtitle: '${user.totalRentsReceived} items',
          onTap: () {
            // TODO: Navegar a la vista de "My Listings"
            // Navigator.pushNamed(context, '/my-listings');
          },
        ),
        _buildInfoCard(
          context: context,
          title: 'Rentals Requests',
          subtitle: '$pendingRequestsCount requests', // <-- Usamos el conteo en vivo
          onTap: () {
            // Navega a la vista de solicitudes de alquiler
            Navigator.pushNamed(context, '/rent-requests');
          },
        ),
        _buildInfoCard(
          context: context,
          title: 'Favorites',
          subtitle: '8 saved',
          onTap: () {
            // TODO: Navegar a la vista de "Favorites"
            // Navigator.pushNamed(context, '/favorites');
          },
        ),
        _buildInfoCard(
          context: context,
          title: 'Verification',
          subtitle: user.verified ? 'Complete' : 'Pending',
          highlight: user.verified,
          onTap: () {
            // TODO: Navegar a la vista de "Verification"
            // Navigator.pushNamed(context, '/verification');
          },
        ),
      ],
    );
  }

  // El método ahora recibe un `onTap` y el `BuildContext`
  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16), // Para que el ripple tenga bordes redondeados
        onTap: onTap, // La acción que se ejecuta al tocar
        child: Container(
          width: (MediaQuery.of(context).size.width / 2) - 32, // Ocupa casi la mitad del ancho
          height: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: AppTextStyles.inputLabel, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: highlight ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}