import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class LoginInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  const LoginInput({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white10),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: AppTextStyles.inputLabel,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: AppTextStyles.inputHint,
          ),
        ),
      ),
    );
  }
}
