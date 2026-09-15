import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/gradient_icon_badge.dart';
import '../../widgets/pin_input.dart';
import '../../widgets/primary_button.dart';
import 'login_screen.dart';

enum _PinStep { create, confirm, biometric }

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  _PinStep _step = _PinStep.create;
  String _firstPin = '';

  Future<String?> _onPinCompleted(String pin) async {
    if (_step == _PinStep.create) {
      setState(() {
        _firstPin = pin;
        _step = _PinStep.confirm;
      });
      return null;
    }
    if (pin != _firstPin) return 'Les codes ne correspondent pas';
    setState(() => _step = _PinStep.biometric);
    return null;
  }

  void _onBack() {
    if (_step == _PinStep.confirm) {
      setState(() {
        _step = _PinStep.create;
        _firstPin = '';
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _finish() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_step == _PinStep.biometric) {
      return _BiometricStep(onActivate: _finish, onSkip: _finish);
    }

    final isCreate = _step == _PinStep.create;
    return Scaffold(
      appBar: BackAppBar(onBack: _onBack),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const GradientIconBadge(Icons.lock_outline_rounded),
            const SizedBox(height: 24),
            Text(
              isCreate ? 'Créez votre code PIN' : 'Confirmez votre code PIN',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                isCreate
                    ? 'Ce code vous servira à vous connecter rapidement.'
                    : 'Saisissez à nouveau votre code PIN.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 36),
            // La clé remet la saisie à zéro à chaque changement d'étape.
            Expanded(
              child: PinInput(key: ValueKey(_step), onCompleted: _onPinCompleted),
            ),
          ],
        ),
      ),
    );
  }
}

class _BiometricStep extends StatelessWidget {
  final VoidCallback onActivate;
  final VoidCallback onSkip;

  const _BiometricStep({required this.onActivate, required this.onSkip});

  @override
  Widget build(BuildContext context) {
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
              PrimaryButton(label: 'Activer la biométrie', onPressed: onActivate),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onSkip,
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
