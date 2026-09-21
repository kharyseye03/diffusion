import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_call_mixin.dart';
import '../../models/country.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/accent_title.dart';
import '../../widgets/gradient_icon_badge.dart';
import '../../widgets/phone_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/text_link.dart';
import 'otp_screen.dart';
import 'login_screen.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> with ApiCallMixin {
  final _phoneController = PhoneController();
  Country _country = kCountries.first;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final phoneNumber = _phoneController.digits;
    final ok = await callApi(
        () => ref.read(authServiceProvider).register(phoneNumber));
    if (!ok || !mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          phoneNumber: phoneNumber,
          displayNumber: '${_country.dialCode} ${_phoneController.text}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const GradientIconBadge(Icons.smartphone_rounded),
              const SizedBox(height: 32),
              // Badge inscription rapide
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 16, color: AppColors.accentDark),
                    SizedBox(width: 4),
                    Text(
                      'Inscription en 30 secondes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const AccentTitle(
                text: 'Bienvenue ',
                accent: 'à bord',
                fontSize: 28,
              ),
              const SizedBox(height: 12),
              const Text(
                'Pour commencer, inscrivez-vous avec votre numéro de téléphone. Aucun mot de passe à retenir.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),
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
                  onPressed: _phoneController.isValid ? _continue : null,
                  isLoading: isLoading,
                ),
              ),
              const SizedBox(height: 16),
              TextLink(
                text: 'Vous avez déjà un compte ?',
                action: 'Se connecter',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(
                      phoneNumber: _phoneController.isValid
                          ? _phoneController.digits
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
