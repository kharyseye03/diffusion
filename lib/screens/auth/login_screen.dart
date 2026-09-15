import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/accent_title.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/gradient_icon_badge.dart';
import '../../widgets/pin_input.dart';
import '../home/home_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Démo : tout PIN à 4 chiffres ouvre l'app
  Future<String?> _unlock(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (_) => false,
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const GradientIconBadge(Icons.lock_outline_rounded, size: 64),
            const SizedBox(height: 24),
            const AccentTitle(text: 'Content de vous ', accent: 'revoir', center: true),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Saisissez votre code PIN pour vous connecter.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 36),
            Expanded(
              child: PinInput(
                onCompleted: (_) => _unlock(context),
                action: TextButton.icon(
                  onPressed: () => _unlock(context),
                  icon: const Icon(Icons.fingerprint_rounded,
                      color: AppColors.primary, size: 24),
                  label: const Text(
                    'Utiliser la biométrie',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
