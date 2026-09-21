import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/country.dart';
import '../theme/app_theme.dart';

/// Contrôleur du champ téléphone : expose le numéro tel qu'attendu par l'API.
class PhoneController extends TextEditingController {
  static const length = 9;

  String get digits => text.replaceAll(' ', '');
  bool get isValid => digits.length == length;
}

/// Formate un numéro au format xx xxx xx xx.
String formatPhone(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i == 2 || i == 5 || i == 7) buffer.write(' ');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Sélecteur de pays + saisie du numéro.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryChanged,
  });

  final PhoneController controller;
  final Country country;
  final ValueChanged<Country> onCountryChanged;

  void _pickCountry(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
                  'Choisir un pays',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...kCountries.map(
              (c) => ListTile(
                leading: Text(c.flag, style: const TextStyle(fontSize: 26)),
                title: Text(
                  c.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: Text(
                  c.dialCode,
                  style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
                ),
                onTap: () {
                  onCountryChanged(c);
                  Navigator.pop(sheetContext);
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );

    return Row(
      children: [
        GestureDetector(
          onTap: () => _pickCountry(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider, width: 1.5),
            ),
            child: Row(
              children: [
                Text(country.flag, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(
                  country.dialCode,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            autofocus: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _PhoneNumberFormatter(),
            ],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 1,
            ),
            decoration: InputDecoration(
              hintText: '77 123 45 67',
              hintStyle: const TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: false,
              border: border(AppColors.divider, 1.5),
              enabledBorder: border(AppColors.divider, 1.5),
              focusedBorder: border(AppColors.primary, 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final text = formatPhone(digits.length > PhoneController.length
        ? digits.substring(0, PhoneController.length)
        : digits);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
