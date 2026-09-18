import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_call_mixin.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/gradient_icon_badge.dart';
import '../../widgets/primary_button.dart';
import 'create_pin_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  /// Numéro envoyé à l'API (chiffres uniquement).
  final String phoneNumber;

  /// Numéro formaté affiché à l'utilisateur.
  final String displayNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.displayNumber,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> with ApiCallMixin {
  static const _codeLength = 6;

  final _controllers =
      List.generate(_codeLength, (_) => TextEditingController());
  final _focusNodes = List.generate(_codeLength, (_) => FocusNode());
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
    if (_code.length == _codeLength) {
      FocusScope.of(context).unfocus();
      _verify();
    }
  }

  Future<void> _verify() async {
    final ok = await callApi(() =>
        ref.read(authServiceProvider).verifyOtp(widget.phoneNumber, _code));
    if (!mounted) return;
    if (!ok) {
      setState(() {
        for (final c in _controllers) {
          c.clear();
        }
      });
      _focusNodes.first.requestFocus();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePinScreen(phoneNumber: widget.phoneNumber),
      ),
    );
  }

  Future<void> _resend() async {
    final ok = await callApi(
        () => ref.read(authServiceProvider).resendOtp(widget.phoneNumber));
    if (ok && mounted) setState(_startTimer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const GradientIconBadge(Icons.sms_outlined),
              const SizedBox(height: 32),
              const Text(
                'Code de vérification',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Entrez le code envoyé au\n',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: widget.displayNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Cases OTP
              Row(
                spacing: 8,
                children: List.generate(_codeLength, (index) {
                  final filled = _controllers[index].text.isNotEmpty;
                  return Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        autofocus: index == 0,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: filled
                              ? AppColors.primary.withValues(alpha: 0.05)
                              : AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: filled ? AppColors.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        onChanged: (v) => _onChanged(v, index),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Renvoyer le code
              Center(
                child: _secondsLeft > 0
                    ? Text(
                        'Renvoyer le code dans 0:${_secondsLeft.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : TextButton(
                        onPressed: isLoading ? null : _resend,
                        child: const Text(
                          'Renvoyer le code',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Vérifier',
                onPressed: _code.length == _codeLength ? _verify : null,
                isLoading: isLoading,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
