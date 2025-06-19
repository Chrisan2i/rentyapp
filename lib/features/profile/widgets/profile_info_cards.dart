// ARCHIVO: lib/features/profile/widgets/profile_info_cards.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class ProfileInfoCards extends StatelessWidget {
  final UserModel user;
  final int pendingRequestsCount;

  const ProfileInfoCards({
    super.key,
    required this.user,
    required this.pendingRequestsCount,
  });

  @override
  Widget build(BuildContext context) {
    // <<<--- CORRECCIÓN: Se comprueba el estado de verificación con el enum ---<<<
    final bool isVerified = user.verificationStatus != VerificationStatus.notVerified;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _buildInfoCard(
          context: context,
          title: 'My Listings',
          // <<<--- CORRECCIÓN: Se usa 'totalRentsAsOwner' del modelo ---<<<
          subtitle: '${user.totalRentsAsOwner} items',
          onTap: () { /* TODO: Navegar a My Listings */ },
        ),
        _buildInfoCard(
          context: context,
          title: 'Rentals Requests',
          subtitle: '$pendingRequestsCount requests',
          onTap: () { /* TODO: Navegar a Rent Requests */ },
        ),
        _buildInfoCard(
          context: context,
          title: 'Favorites',
          subtitle: '8 saved', // TODO: Conectar a datos reales si existen
          onTap: () { /* TODO: Navegar a Favorites */ },
        ),
        _buildInfoCard(
          context: context,
          title: 'Verification',
          subtitle: isVerified ? 'Complete' : 'Pending',
          highlight: isVerified,
          onTap: () { /* TODO: Navegar a Verification */ },
        ),
      ],
    );
  }

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