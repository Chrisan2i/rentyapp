import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class LoginSocialButton extends StatelessWidget {
  final String label;

  const LoginSocialButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.white10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(label, style: AppTextStyles.loginButton),
      ),
    );
  }
}
