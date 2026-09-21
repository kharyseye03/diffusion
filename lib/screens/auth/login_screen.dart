import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_exception.dart';
import '../../core/utils/snackbar.dart';
import '../../models/country.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/accent_title.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/gradient_icon_badge.dart';
import '../../widgets/phone_field.dart';
import '../../widgets/pin_input.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/text_link.dart';
import '../home/home_shell.dart';
import 'biometric_screen.dart';
import 'phone_screen.dart';

/// Connexion par PIN. Le numéro est demandé seulement s'il n'est pas
/// connu (nouvel appareil, réinstallation).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.phoneNumber});

  /// Numéro déjà connu. À défaut, celui de la dernière connexion
  /// enregistré sur l'appareil.
  final String? phoneNumber;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = PhoneController();
  Country _country = kCountries.first;
  String? _phone;
  bool _biometricEnabled = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final stored = await ref.read(tokenStorageProvider).phoneNumber;
    final phone = widget.phoneNumber ?? stored;
    // Le PIN enregistré n'appartient qu'au compte du numéro enregistré.
    final biometric = phone != null &&
        phone == stored &&
        await ref.read(biometricServiceProvider).isEnabled;
    if (!mounted) return;
    setState(() {
      _phone = phone;
      _biometricEnabled = biometric;
      _ready = true;
    });
    if (biometric) _loginWithBiometric();
  }

  Future<void> _loginWithBiometric() async {
    final pin = await ref.read(biometricServiceProvider).unlockPin();
    if (pin == null) return;
    final error = await _login(pin, fromBiometric: true);
    if (error != null && mounted) showErrorSnackBar(context, error);
  }

  Future<String?> _login(String pin, {bool fromBiometric = false}) async {
    final bool isNewUser;
    try {
      isNewUser = await ref.read(authServiceProvider).login(_phone!, pin);
    } on ApiException catch (e) {
      // PIN enregistré refusé (changé entre-temps) : retour à la saisie.
      // Une simple panne réseau ne désactive pas la biométrie.
      if (fromBiometric && e.statusCode != null) {
        await ref.read(biometricServiceProvider).disable();
        if (mounted) setState(() => _biometricEnabled = false);
      }
      return e.message;
    }
    final offerBiometric =
        isNewUser && await ref.read(biometricServiceProvider).isAvailable;
    if (mounted) {
      _open(offerBiometric
          ? BiometricScreen(pin: pin, next: const HomeShell())
          : const HomeShell());
    }
    return null;
  }

  void _open(Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = _phone;
    return Scaffold(
      appBar: const BackAppBar(),
      body: SafeArea(
        child: !_ready
            ? const SizedBox.shrink()
            : Column(
                children: [
                  const SizedBox(height: 16),
                  const GradientIconBadge(Icons.lock_outline_rounded, size: 64),
                  const SizedBox(height: 24),
                  const AccentTitle(
                      text: 'Content de vous ', accent: 'revoir', center: true),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      phone == null
                          ? 'Saisissez votre numéro de téléphone.'
                          : 'Saisissez le code PIN du ${formatPhone(phone)}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (phone != null)
                    TextButton(
                      onPressed: () => setState(() {
                        _phone = null;
                        _biometricEnabled = false;
                      }),
                      child: const Text(
                        'Changer de numéro',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  SizedBox(height: phone == null ? 24 : 8),
                  Expanded(
                    child: phone == null ? _phoneStep() : _pinStep(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _phoneStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          PhoneField(
            controller: _phoneController,
            country: _country,
            onCountryChanged: (c) => setState(() => _country = c),
          ),
          const Spacer(),
          ListenableBuilder(
            listenable: _phoneController,
            builder: (context, _) => PrimaryButton(
              label: 'Continuer',
              onPressed: _phoneController.isValid
                  ? () => setState(() => _phone = _phoneController.digits)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          TextLink(
            text: 'Pas encore de compte ?',
            action: "S'inscrire",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PhoneScreen()),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _pinStep() {
    return PinInput(
      onCompleted: _login,
      action: !_biometricEnabled
          ? null
          : TextButton.icon(
              onPressed: _loginWithBiometric,
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
    );
  }
}
