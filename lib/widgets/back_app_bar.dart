import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// AppBar blanche avec flèche retour (masquée s'il n'y a rien à dépiler).
class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({super.key, this.onBack});

  /// Remplace le simple `Navigator.pop` si fourni.
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: onBack ?? () => Navigator.pop(context),
            )
          : null,
    );
  }
}
