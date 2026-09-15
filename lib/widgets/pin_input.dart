import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Saisie d'un code PIN : points, message d'erreur et clavier numérique.
///
/// [onCompleted] renvoie un message d'erreur, ou `null` si le code est
/// accepté. Dans les deux cas la saisie est remise à zéro.
class PinInput extends StatefulWidget {
  const PinInput({super.key, required this.onCompleted, this.action});

  static const length = 4;

  final Future<String?> Function(String pin) onCompleted;

  /// Widget optionnel affiché au-dessus du clavier (ex : biométrie).
  final Widget? action;

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  String _pin = '';
  String? _error;
  bool _busy = false;

  void _onKey(String digit) {
    if (_busy || _pin.length == PinInput.length) return;
    setState(() {
      _error = null;
      _pin += digit;
    });
    if (_pin.length == PinInput.length) _submit();
  }

  void _onDelete() {
    if (_busy || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submit() async {
    _busy = true;
    await Future.delayed(const Duration(milliseconds: 150));
    final error = await widget.onCompleted(_pin);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
      _pin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(PinInput.length, (i) {
            final filled = i < _pin.length;
            final color = _error != null
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
          child: _error == null
              ? null
              : Text(
                  _error!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
        const Spacer(),
        if (widget.action != null) ...[widget.action!, const SizedBox(height: 8)],
        _Keypad(onKey: _onKey, onDelete: _onDelete),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onKey, required this.onDelete});

  final ValueChanged<String> onKey;
  final VoidCallback onDelete;

  static const _delete = 'del';
  static const _keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', _delete];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          for (var row = 0; row < 4; row++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [for (final key in _keys.skip(row * 3).take(3)) _key(key)],
            ),
        ],
      ),
    );
  }

  Widget _key(String key) {
    return SizedBox(
      width: 72,
      height: 72,
      child: key.isEmpty
          ? null
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(36),
                onTap: key == _delete ? onDelete : () => onKey(key),
                child: Center(
                  child: key == _delete
                      ? const Icon(Icons.backspace_outlined,
                          color: AppColors.textPrimary, size: 26)
                      : Text(
                          key,
                          style: const TextStyle(
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
