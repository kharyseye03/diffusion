import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_call_mixin.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/gradient_icon_badge.dart';
import '../../widgets/pin_input.dart';
import 'biometric_screen.dart';
import 'login_screen.dart';

enum _PinStep { create, confirm }

class CreatePinScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const CreatePinScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen>
    with ApiCallMixin {
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
    final ok = await callApi(
        () => ref.read(authServiceProvider).createPin(widget.phoneNumber, pin));
    if (ok) await _finish(pin);
    return null;
  }

  /// Vers le login, en proposant la biométrie si l'appareil la gère.
  Future<void> _finish(String pin) async {
    final canUseBiometric =
        await ref.read(biometricServiceProvider).isAvailable;
    if (!mounted) return;
    final login = LoginScreen(phoneNumber: widget.phoneNumber);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            canUseBiometric ? BiometricScreen(pin: pin, next: login) : login,
      ),
      (_) => false,
    );
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

  @override
  Widget build(BuildContext context) {
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
