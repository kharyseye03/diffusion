import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_icon_badge.dart';
import '../../widgets/primary_button.dart';

/// Propose d'activer la biométrie, puis ouvre [next].
class BiometricScreen extends ConsumerWidget {
  const BiometricScreen({super.key, required this.pin, required this.next});

  final String pin;
  final Widget next;

  void _continue(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => next),
      (_) => false,
    );
  }

  Future<void> _activate(BuildContext context, WidgetRef ref) async {
    final enabled = await ref.read(biometricServiceProvider).enable(pin);
    if (enabled && context.mounted) _continue(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              const GradientIconBadge(Icons.fingerprint_rounded, size: 96),
              const SizedBox(height: 32),
              const Text(
                'Activer la biométrie',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Connectez-vous encore plus vite avec votre empreinte ou Face ID, sans saisir votre PIN.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Activer la biométrie',
                onPressed: () => _activate(context, ref),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _continue(context),
                child: const Text(
                  'Plus tard',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
