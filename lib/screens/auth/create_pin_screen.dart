import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
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
  String _pin = '';
  bool _error = false;

  void _onKeyTap(String value) {
    if (_pin.length >= 4) return;
    setState(() {
      _error = false;
      _pin += value;
    });
    if (_pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 150), _onComplete);
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _onComplete() {
    if (_step == _PinStep.create) {
      setState(() {
        _firstPin = _pin;
        _pin = '';
        _step = _PinStep.confirm;
      });
    } else if (_step == _PinStep.confirm) {
      if (_pin == _firstPin) {
        setState(() => _step = _PinStep.biometric);
      } else {
        setState(() {
          _error = true;
          _pin = '';
        });
      }
    }
  }

  void _finish() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_step == _PinStep.biometric) {
      return _BiometricStep(onActivate: _finish, onSkip: _finish);
    }

    final isCreate = _step == _PinStep.create;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (_step == _PinStep.confirm) {
              setState(() {
                _step = _PinStep.create;
                _pin = '';
                _firstPin = '';
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  color: AppColors.accent, size: 26),
            ),
            const SizedBox(height: 24),
            Text(
              isCreate ? 'Créez votre code PIN' : 'Confirmez votre code PIN',
              style: const TextStyle(
                fontFamily: 'Manrope',
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
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Points PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _pin.length;
                final color = _error
                    ? AppColors.error
                    : (filled ? AppColors.primary : AppColors.divider);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: filled ? color : Colors.transparent,
                    border: Border.all(color: color, width: 2),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),
            SizedBox(
              height: 20,
              child: _error
                  ? const Text(
                      'Les codes ne correspondent pas',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : null,
            ),

            const Spacer(),

            // Clavier numérique
            _Keypad(onKeyTap: _onKeyTap, onDelete: _onDelete),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final void Function(String) onKeyTap;
  final VoidCallback onDelete;

  const _Keypad({required this.onKeyTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          for (final row in [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: row.map((d) => _key(d)).toList(),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 72, height: 72),
              _key('0'),
              SizedBox(
                width: 72,
                height: 72,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(36),
                    onTap: onDelete,
                    child: const Icon(Icons.backspace_outlined,
                        color: AppColors.textPrimary, size: 26),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _key(String digit) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(36),
          onTap: () => onKeyTap(digit),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.fingerprint_rounded,
                    color: AppColors.accent, size: 52),
              ),
              const SizedBox(height: 32),
              const Text(
                'Activer la biométrie',
                style: TextStyle(
                  fontFamily: 'Manrope',
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
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onActivate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Activer la biométrie',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onSkip,
                child: const Text(
                  'Plus tard',
                  style: TextStyle(
                    fontFamily: 'Manrope',
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
