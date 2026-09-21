import 'package:local_auth/local_auth.dart';
import 'storage/token_storage.dart';

/// La biométrie ne remplace pas le login : elle débloque le PIN
/// enregistré, qui est ensuite envoyé au backend comme une saisie.
class BiometricService {
  BiometricService(this._storage);

  final TokenStorage _storage;
  final _auth = LocalAuthentication();

  Future<bool> get isAvailable async =>
      await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;

  Future<bool> get isEnabled async => await _storage.pin != null;

  /// Enregistre le PIN si l'utilisateur confirme avec sa biométrie.
  Future<bool> enable(String pin) async {
    if (!await _authenticate('Activez la connexion par biométrie')) return false;
    await _storage.savePin(pin);
    return true;
  }

  /// PIN enregistré, ou `null` si la reconnaissance échoue ou est annulée.
  Future<String?> unlockPin() async =>
      await _authenticate('Connectez-vous à votre compte') ? _storage.pin : null;

  Future<void> disable() => _storage.clearPin();

  Future<bool> _authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, biometricOnly: true);
    } on LocalAuthException {
      return false;
    }
  }
}
