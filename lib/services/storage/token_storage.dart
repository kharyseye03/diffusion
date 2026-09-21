import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Données de session conservées de façon sécurisée sur l'appareil
/// (Keystore Android / Keychain iOS).
class TokenStorage {
  const TokenStorage([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _phoneKey = 'phone_number';
  static const _pinKey = 'biometric_pin';

  Future<String?> get accessToken => _storage.read(key: _accessKey);
  Future<String?> get refreshToken => _storage.read(key: _refreshKey);

  /// Numéro de la dernière connexion : l'écran de login ne demande que le PIN.
  Future<String?> get phoneNumber => _storage.read(key: _phoneKey);

  /// PIN débloqué par la biométrie. Présent seulement si elle est activée.
  Future<String?> get pin => _storage.read(key: _pinKey);

  Future<void> save({required String accessToken, String? refreshToken}) async {
    await _storage.write(key: _accessKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshKey, value: refreshToken);
    }
  }

  Future<void> savePhoneNumber(String phoneNumber) =>
      _storage.write(key: _phoneKey, value: phoneNumber);

  Future<void> savePin(String pin) => _storage.write(key: _pinKey, value: pin);

  Future<void> clearPin() => _storage.delete(key: _pinKey);

  /// Déconnexion : le numéro est conservé pour la prochaine connexion.
  Future<void> clear() => Future.wait([
        _storage.delete(key: _accessKey),
        _storage.delete(key: _refreshKey),
      ]);
}
