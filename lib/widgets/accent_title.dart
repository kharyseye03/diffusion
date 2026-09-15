import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Titre dont un mot est en doré, souligné d'une barre dégradée.
class AccentTitle extends StatelessWidget {
  const AccentTitle({
    super.key,
    required this.text,
    required this.accent,
    this.suffix = '',
    this.fontSize = 24,
    this.center = false,
  });

  final String text;
  final String accent;
  final String suffix;
  final double fontSize;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: text,
            children: [
              TextSpan(
                text: accent,
                style: const TextStyle(color: AppColors.accentDark),
              ),
              TextSpan(text: suffix),
            ],
          ),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.accentLight],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
