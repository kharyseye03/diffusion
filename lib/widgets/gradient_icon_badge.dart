import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Icône dorée sur carré vert en dégradé, utilisée en tête d'écran.
class GradientIconBadge extends StatelessWidget {
  const GradientIconBadge(this.icon, {super.key, this.size = 52});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.accent, size: size * 0.5),
    );
  }
}
