// lib/features/add_product/widgets/action_button.dart
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final double? width;
  final double height;

  const ActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    /// Determines the button's style. `true` for primary action, `false` for secondary.
    this.isPrimary = true,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final Color primaryColor = const Color(0xFF0085FF);
    final Color surfaceColor = Colors.white.withOpacity(0.1);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? primaryColor : surfaceColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isPrimary
              ? primaryColor.withOpacity(0.5)
              : surfaceColor.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: isEnabled && isPrimary ? 8 : 0,
          shadowColor: isPrimary ? primaryColor.withOpacity(0.3) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
        )
            : Text(text),
      ),
    );
  }
}