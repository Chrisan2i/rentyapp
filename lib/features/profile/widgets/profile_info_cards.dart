import 'package:flutter/material.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class ProfileInfoCards extends StatelessWidget {
  final UserModel user;
  const ProfileInfoCards({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildInfoCard('My Listings', '${user.totalRentsReceived} items'),
        _buildInfoCard('Rental History', '${user.totalRentsMade} rentals'),
        _buildInfoCard('Favorites', '8 saved'),
        _buildInfoCard('Verification', user.verified ? 'Complete' : 'Pending', highlight: user.verified),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle, {bool highlight = false}) {
    return Container(
      width: 160,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: highlight ? const Color(0xFF0085FF) : const Color(0xFF999999),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
