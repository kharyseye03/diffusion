// ⚠️ TEMPLATE — Copiez ce fichier vers api_config.dart
// et remplacez les valeurs par les vraies URLs.
// api_config.dart est ignoré par git (contient les URLs du backend).

class ApiConfig {
  // ── API Base ──────────────────────────────────────────────
  static const String baseUrl = 'http://VOTRE_IP:PORT/api';

  // ── Timeouts ──────────────────────────────────────────────
  static const Duration timeout = Duration(seconds: 30);

  // ── Endpoints Auth ────────────────────────────────────────
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String createPin = '/auth/create-pin';
}
