import 'package:flutter/foundation.dart';
import '../config/api/api_config.dart';
import '../core/network/api_client.dart';
import 'storage/token_storage.dart';

class AuthService {
  const AuthService(this._client, this._storage);

  final ApiClient _client;
  final TokenStorage _storage;

  /// Rôle attribué à tout compte créé depuis l'app.
  static const _role = 'GROSSISTE';

  Future<void> register(String phoneNumber) async => _logOtp(await _client.post(
        ApiConfig.register,
        data: {'phoneNumber': phoneNumber, 'role': _role},
      ));

  Future<void> verifyOtp(String phoneNumber, String code) => _client.post(
        ApiConfig.verifyOtp,
        data: {'phoneNumber': phoneNumber, 'code': code},
      );

  Future<void> resendOtp(String phoneNumber) async => _logOtp(await _client.post(
        ApiConfig.resendOtp,
        data: {'phoneNumber': phoneNumber},
      ));

  /// Le compte appartient désormais à cet appareil : le numéro est
  /// retenu et la biométrie d'un éventuel ancien compte est retirée.
  Future<void> createPin(String phoneNumber, String pin) async {
    await _client.post(
      ApiConfig.createPin,
      data: {'phoneNumber': phoneNumber, 'pin': pin},
    );
    await _switchAccount(phoneNumber);
  }

  /// Ouvre la session. Renvoie `true` si ce numéro se connecte pour la
  /// première fois sur l'appareil.
  Future<bool> login(String phoneNumber, String pin) async {
    final data = await _client.post(
      ApiConfig.login,
      data: {'phoneNumber': phoneNumber, 'pin': pin},
    );
    await _storage.save(accessToken: data['accessToken'] as String);
    return _switchAccount(phoneNumber);
  }

  Future<bool> _switchAccount(String phoneNumber) async {
    if (await _storage.phoneNumber == phoneNumber) return false;
    await _storage.clearPin();
    await _storage.savePhoneNumber(phoneNumber);
    return true;
  }

  /// Dev : le backend renvoie l'OTP, affiché pour ne pas attendre le SMS.
  void _logOtp(dynamic data) {
    if (kDebugMode && data is Map && data['otp'] != null) {
      debugPrint('🔑 OTP : ${data['otp']}');
    }
  }
}
