import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/settings/settings_view.dart';


class ProfileHeader extends StatelessWidget {
  final UserModel user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage(
            user.profileImageUrl.isNotEmpty
                ? user.profileImageUrl
                : 'https://res.cloudinary.com/do9dtxrvh/image/upload/v1742413057/Untitled_design_1_hvuwau.png',
          ),
        ),
        const SizedBox(height: 16),
        Text(user.fullName, style: AppTextStyles.sectionTitle),
        Text('@\${user.username}', style: AppTextStyles.subtitle),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Color(0xFF0085FF), size: 18),
            const SizedBox(width: 4),
            Text((user.rating / 10).toStringAsFixed(1), style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            const Text('(127 reviews)', style: TextStyle(color: Color(0xFF999999))),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsView()),
            );
          },
          icon: const Icon(Icons.edit, size: 18, color: Color(0xFF0085FF)),
          label: const Text('Settings', style: TextStyle(color: Color(0xFF0085FF))),
        ),
        const SizedBox(height: 16),
        if (user.verified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0085FF)),
              color: const Color(0x330085FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Verified User',
              style: TextStyle(color: Color(0xFF0085FF), fontSize: 12),
            ),
          ),
      ],
    );
  }
}
