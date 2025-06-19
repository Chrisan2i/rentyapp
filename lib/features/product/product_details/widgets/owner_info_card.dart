// lib/features/product/widgets/owner_info_card.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart'; // Importa el enum
import 'section_card.dart';

class OwnerInfoCard extends StatelessWidget {
  // <<<--- CORRECCIÓN: Recibe el mapa de ownerInfo directamente ---<<<
  final Map<String, dynamic> ownerInfo;

  const OwnerInfoCard({Key? key, required this.ownerInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extraemos los datos del mapa. Usamos valores por defecto seguros.
    final String fullName = ownerInfo['fullName'] ?? 'Usuario';
    final String profileImageUrl = ownerInfo['profileImageUrl'] ?? '';
    final double rating = (ownerInfo['rating'] as num?)?.toDouble() ?? 0.0;
    final VerificationStatus verificationStatus = VerificationStatus.values.firstWhere(
            (e) => e.name == ownerInfo['verificationStatus'],
        orElse: () => VerificationStatus.notVerified);

    final String ownerInitials = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

    return SectionCard(
      title: 'Owner Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: profileImageUrl.isNotEmpty ? NetworkImage(profileImageUrl) : null,
                backgroundColor: Colors.deepPurple,
                child: profileImageUrl.isEmpty
                    ? Text(ownerInitials, style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      '${rating.toStringAsFixed(1)} Rating',
                      style: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: 12),
                    ),
                  ],
                ),
              ),
              // <<<--- CORRECCIÓN: Comparamos con el enum ---<<<
              if (verificationStatus != VerificationStatus.notVerified)
                const Icon(Icons.verified, color: AppColors.primary, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}