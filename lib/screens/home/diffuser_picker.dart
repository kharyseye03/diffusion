import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/channel.dart';
import 'channel_detail_screen.dart';
import 'create_canal_screen.dart';

/// Affiche le sélecteur "Diffuser dans quel canal ?"
/// puis ouvre le chat du canal choisi ou créé.
Future<void> showDiffuserPicker(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Diffuser dans...',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Créer un nouveau canal
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.accentDark),
            ),
            title: const Text(
              'Créer un nouveau canal',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.accentDark,
              ),
            ),
            onTap: () async {
              Navigator.pop(sheetContext);
              final created = await Navigator.push<Channel>(
                context,
                MaterialPageRoute(builder: (_) => const CreateCanalScreen()),
              );
              if (created != null && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChannelDetailScreen(channel: created),
                  ),
                );
              }
            },
          ),

          const Divider(height: 1, indent: 24, endIndent: 24),

          // Canaux existants
          ...MockData.myChannels.map(
            (c) => ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [c.color, c.color.withValues(alpha: 0.7)],
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(c.avatar, style: const TextStyle(fontSize: 22)),
              ),
              title: Text(
                c.name,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                '${c.subscribers} abonnés',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.muted),
              onTap: () {
                Navigator.pop(sheetContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChannelDetailScreen(channel: c),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}
