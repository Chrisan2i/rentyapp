import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/login/login.dart';
import 'package:rentyapp/features/profile/edit/edit_profile_view.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';
import 'widgets/section_title.dart';
import 'widgets/settings_card.dart';
import 'widgets/settings_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SectionTitle('Account'),
            SettingsCard(
              child: Column(
                children: [
                  SettingsTile(
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileView()),
                      );
                    },
                  ),
                  SettingsTile(title: 'Change Email', onTap: () {}),
                  SettingsTile(title: 'Change Password', onTap: () {}),
                  SettingsTile(
                    title: 'Verify Identity',
                    subtitle: 'Not verified',
                    onTap: () {},
                  ),
                  SettingsTile(
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add extra security to your account',
                    trailing: Switch(
                      value: false,
                      onChanged: (val) {},
                    ),
                  ),
                ],
              ),
            ),

            const SectionTitle('App Preferences'),
            SettingsCard(
              child: Column(
                children: [
                  SettingsTile(title: 'Notifications Settings', onTap: () {}),
                  SettingsTile(title: 'Language', subtitle: 'English', onTap: () {}),
                  SettingsTile(
                    title: 'Theme',
                    subtitle: 'Auto',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _themeOption('Light'),
                        _themeOption('Dark'),
                        _themeOption('Auto', selected: true),
                      ],
                    ),
                  ),
                  SettingsTile(title: 'Currency', subtitle: 'US Dollar (USD)', onTap: () {}),
                ],
              ),
            ),

            const SectionTitle('Privacy & Security'),
            SettingsCard(
              child: Column(
                children: [
                  SettingsTile(title: 'Blocked Users', onTap: () {}),
                  SettingsTile(title: 'Manage Devices', onTap: () {}),
                  SettingsTile(title: 'View Activity Log', onTap: () {}),
                  SettingsTile(
                    title: 'Delete Account',
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1A1A),
                          title: const Text('Confirm Deletion', style: TextStyle(color: Colors.white)),
                          content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await AuthService().deleteAccount();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error deleting account: $e')),
                          );
                        }
                      }
                    },
                    titleStyle: const TextStyle(
                      color: Color(0xFFFF4757),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),

                ],
              ),
            ),

            const SectionTitle('Help & Legal'),
            SettingsCard(
              child: Column(
                children: [
                  SettingsTile(title: 'Terms of Service', onTap: () {}),
                  SettingsTile(title: 'Privacy Policy', onTap: () {}),
                  SettingsTile(title: 'FAQs', onTap: () {}),
                  SettingsTile(title: 'Contact Support', onTap: () {}),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4757),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                    await AuthService().signOut();
                    // Navegar al login (reemplaza según tu ruta)

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                    );
                },
                child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _themeOption(String label, {bool selected = false}) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0085FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : const Color(0xFF999999),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

